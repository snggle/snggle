import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class PasskeyAuthenticationService {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordController _passwordController =
  globalLocator<PasswordController>();

  Future<String> authenticate({
    required PasskeyModel passkeyModel,
    required String requestJson,
    required String clientDataJson,
  }) async {
    final Uint8List clientDataHash = Uint8List.fromList(
      Sha256().convert(utf8.encode(clientDataJson)).byteList,
    );

    return _authenticate(
      passkeyModel: passkeyModel,
      requestJson: requestJson,
      clientDataHash: clientDataHash,
      clientDataJson: clientDataJson,
    );
  }

  Future<String> authenticateWithClientDataHash({
    required PasskeyModel passkeyModel,
    required String requestJson,
    required Uint8List clientDataHash,
  }) async {
    if (clientDataHash.length != 32) {
      throw ArgumentError('Invalid clientDataHash length');
    }

    return _authenticate(
      passkeyModel: passkeyModel,
      requestJson: requestJson,
      clientDataHash: clientDataHash,
      clientDataJson: null,
    );
  }

  Future<String> _authenticate({
    required PasskeyModel passkeyModel,
    required String requestJson,
    required Uint8List clientDataHash,
    required String? clientDataJson,
  }) async {
    if (clientDataHash.length != 32) {
      throw ArgumentError('Invalid clientDataHash length');
    }

    final Map<String, dynamic> request =
    jsonDecode(requestJson) as Map<String, dynamic>;

    final Map<String, dynamic>? clientData = clientDataJson != null
        ? jsonDecode(clientDataJson) as Map<String, dynamic>
        : null;

    _validateRequest(
      passkeyModel: passkeyModel,
      request: request,
      clientData: clientData,
    );

    final ECPrivateKey privateKey = await _getPrivateKey(passkeyModel);

    final Uint8List authenticatorData = _buildAuthenticatorData(
      rpId: passkeyModel.rpId,
    );

    final Uint8List dataToSign = Uint8List.fromList(<int>[
      ...authenticatorData,
      ...clientDataHash,
    ]);

    // ECDSASigner.sign() expects a SHA-256 digest.
    final Uint8List messageHash =
        Sha256().convert(dataToSign).byteList;

    final ECDSASigner signer = ECDSASigner(
      hashFunction: Sha256(),
      ecPrivateKey: privateKey,
    );

    final ECSignature signature = signer.sign(messageHash);

    final Uint8List signatureDer = _encodeDerSignature(signature);

    final String credentialId = _encodeBase64Url(
      passkeyModel.credentialId,
    );

    final Uint8List clientDataBytes = Uint8List.fromList(
      utf8.encode(clientDataJson ?? '{}'),
    );

    return jsonEncode(<String, dynamic>{
      'id': credentialId,
      'rawId': credentialId,
      'type': 'public-key',
      'response': <String, dynamic>{
        'clientDataJSON': _encodeBase64Url(clientDataBytes),
        'authenticatorData': _encodeBase64Url(authenticatorData),
        'signature': _encodeBase64Url(signatureDer),
        'userHandle': _encodeBase64Url(passkeyModel.userId),
      },
      'clientExtensionResults': <String, dynamic>{},
      'authenticatorAttachment': 'platform',
    });
  }

  void _validateRequest({
    required PasskeyModel passkeyModel,
    required Map<String, dynamic> request,
    required Map<String, dynamic>? clientData,
  }) {
    if (passkeyModel.algorithm != -7) {
      throw StateError('Unsupported passkey algorithm');
    }

    if (request['rpId'] != passkeyModel.rpId) {
      throw StateError('RP ID mismatch');
    }

    if (clientData != null) {
      if (clientData['type'] != 'webauthn.get') {
        throw StateError('Invalid WebAuthn operation');
      }

      final dynamic challenge = request['challenge'];
      final dynamic clientChallenge = clientData['challenge'];

      if (challenge is! String || clientChallenge is! String) {
        throw StateError('Missing WebAuthn challenge');
      }

      final Uint8List requestedChallenge =
      base64Url.decode(base64Url.normalize(challenge));

      final Uint8List receivedChallenge =
      base64Url.decode(base64Url.normalize(clientChallenge));

      if (!_bytesEqual(requestedChallenge, receivedChallenge)) {
        throw StateError('Challenge mismatch');
      }
    } else {
      // For a privileged browser, clientDataHash is supplied by Android.
      // Its origin and calling application must be verified natively.
      if (request['challenge'] is! String) {
        throw StateError('Missing WebAuthn challenge');
      }
    }

    final dynamic allowedCredentials = request['allowCredentials'];

    if (allowedCredentials is List && allowedCredentials.isNotEmpty) {
      final bool allowed = allowedCredentials.any((dynamic item) {
        if (item is! Map || item['type'] != 'public-key') {
          return false;
        }

        final dynamic id = item['id'];

        if (id is! String) {
          return false;
        }

        try {
          final Uint8List decodedId =
          base64Url.decode(base64Url.normalize(id));

          return _bytesEqual(
            decodedId,
            passkeyModel.credentialId,
          );
        } on FormatException {
          return false;
        }
      });

      if (!allowed) {
        throw StateError('Credential is not allowed');
      }
    }

    // Until persistent counter updates are implemented,
    // support only credentials registered with signCount = 0.
    if (passkeyModel.signCount != 0) {
      throw StateError('Signature counter update not implemented');
    }
  }

  Future<ECPrivateKey> _getPrivateKey(
      PasskeyModel passkeyModel,
      ) async {
    final PasswordModel passwordModel =
    await _passwordController.getPasswordByFilesystemPath(
      passkeyModel.filesystemPath,
    );

    final PasskeySecretsModel secretsModel =
    await _secretsService.get<PasskeySecretsModel>(
      passkeyModel.filesystemPath,
      passwordModel,
    );

    final ECPoint generator = CurvePoints.generatorSecp256r1;

    final ECPrivateKey privateKey = ECPrivateKey.fromBytes(
      secretsModel.privateKey,
      generator,
    );

    if (privateKey.d <= BigInt.zero || privateKey.d >= generator.n) {
      throw StateError('Invalid P-256 private key');
    }

    return privateKey;
  }

  Uint8List _buildAuthenticatorData({
    required String rpId,
  }) {
    final Uint8List rpIdHash =
        Sha256().convert(utf8.encode(rpId)).byteList;

    // UP = 1, UV = 0, AT = 0, ED = 0.
    const int flags = 0x01;

    // Counterless authenticator: signCount = 0.
    const int signCount = 0;

    final ByteData counter = ByteData(4)
    ..setUint32(0, signCount, Endian.big);

    return Uint8List.fromList(<int>[
      ...rpIdHash,
      flags,
      ...counter.buffer.asUint8List(),
    ]);
  }

  Uint8List _encodeDerSignature(ECSignature signature) {
    final Uint8List r = _encodeDerInteger(signature.r);
    final Uint8List s = _encodeDerInteger(signature.s);

    final Uint8List content = Uint8List.fromList(<int>[
      ...r,
      ...s,
    ]);

    return Uint8List.fromList(<int>[
      0x30,
      content.length,
      ...content,
    ]);
  }

  Uint8List _encodeDerInteger(BigInt value) {
    if (value <= BigInt.zero) {
      throw ArgumentError('Invalid ECDSA signature component');
    }

    String hex = value.toRadixString(16);

    if (hex.length.isOdd) {
      hex = '0$hex';
    }

    final List<int> bytes = <int>[
      for (int i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ];

    // DER INTEGER must be positive.
    if ((bytes.first & 0x80) != 0) {
      bytes.insert(0, 0x00);
    }

    return Uint8List.fromList(<int>[
      0x02,
      bytes.length,
      ...bytes,
    ]);
  }

  String _encodeBase64Url(List<int> bytes) {
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  bool _bytesEqual(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }

    int difference = 0;

    for (int i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }

    return difference == 0;
  }
}