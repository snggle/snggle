import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/factories/passkey_model_factory.dart';
import 'package:snggle/shared/models/passkeys/passkey_create_options.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_registration_context.dart';
import 'package:snggle/shared/models/passkeys/passkey_registration_result.dart';
import 'package:snggle/shared/utils/passkey/passkey_authenticator_data_builder.dart';
import 'package:snggle/shared/utils/passkey/passkey_credential_id_generator.dart';
import 'package:snggle/shared/utils/passkey/passkey_key_generator.dart';

class PasskeyRegistrationService {
  final PasskeyModelFactory _passkeyModelFactory = globalLocator<PasskeyModelFactory>();

  Future<PasskeyRegistrationResult> register({
    required PasskeyRegistrationContext context,
  }) async {
    PasskeyCreateOptions options = PasskeyCreateOptions.fromJson(context.requestJson);

    _validateOptions(options);
    _validateContext(context);

    ECPrivateKey ecPrivateKey = PasskeyKeyGenerator.generatePrivateKey();

    Uint8List credentialId = PasskeyCredentialIdGenerator.generate();

    Uint8List publicKeyBytes = ecPrivateKey.ecPublicKey.uncompressed;

    Uint8List publicKey = _publicKeyToSpki(publicKeyBytes);

    Uint8List x = Uint8List.sublistView(publicKeyBytes, 1, 33);
    Uint8List y = Uint8List.sublistView(publicKeyBytes, 33, 65);

    Uint8List cosePublicKey = CborCosePublicKey(
      x: x,
      y: y,
    ).toSerializedCbor();

    Uint8List authenticatorData = PasskeyAuthenticatorDataBuilder.build(
      rpId: options.rpId,
      credentialId: credentialId,
      cosePublicKey: cosePublicKey,
    );

    Uint8List attestationObject = CborAttestationObject(
      authenticatorData: authenticatorData,
    ).toSerializedCbor();

    PasskeyModel passkeyModel = await _passkeyModelFactory.createNewPasskey(
      rpId: options.rpId,
      rpName: options.rpName,
      userName: options.userName,
      userDisplayName: options.userDisplayName,
      userId: options.userId,
      credentialId: credentialId,
      privateKey: _privateKeyToBytes(ecPrivateKey),
    );

    return PasskeyRegistrationResult(
      passkeyModel: passkeyModel,
      credentialId: credentialId,
      attestationObject: attestationObject,
      authenticatorData: authenticatorData,
      publicKey: publicKey,
    );
  }

  void _validateOptions(PasskeyCreateOptions options) {
    if (options.rpId.isEmpty) {
      throw ArgumentError('Missing RP ID');
    }

    if (options.userId.isEmpty) {
      throw ArgumentError('Missing user ID');
    }

    if (!options.supportsES256) {
      throw UnsupportedError('ES256 is not supported');
    }
  }

  void _validateContext(PasskeyRegistrationContext context) {
    if (context.origin.isEmpty) {
      throw ArgumentError('Missing origin');
    }

    if (context.privilegedBool) {
      if (context.clientDataHash == null || context.clientDataHash!.length != 32) {
        throw ArgumentError('Invalid clientDataHash');
      }
    }
  }

  Uint8List _privateKeyToBytes(ECPrivateKey ecPrivateKey) {
    BigInt value = ecPrivateKey.d;
    Uint8List bytes = Uint8List(32);

    for (int i = 31; i >= 0; i--) {
      bytes[i] = (value & BigInt.from(0xff)).toInt();
      value >>= 8;
    }

    if (value != BigInt.zero) {
      throw ArgumentError('Private key exceeds 32 bytes');
    }

    return bytes;
  }

  Uint8List _publicKeyToSpki(Uint8List publicKeyBytes) {
    if (publicKeyBytes.length != 65 || publicKeyBytes[0] != 0x04) {
      throw ArgumentError('Invalid uncompressed P-256 public key');
    }

    Uint8List prefix = Uint8List.fromList(<int>[
      0x30, 0x59,
      0x30, 0x13,
      0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01,
      0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07,
      0x03, 0x42, 0x00,
    ]);

    return Uint8List.fromList(<int>[
      ...prefix,
      ...publicKeyBytes,
    ]);
  }
}
