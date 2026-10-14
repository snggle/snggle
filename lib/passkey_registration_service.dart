import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/passkey_authenticator_data_builder.dart';
import 'package:snggle/passkey_creation_options.dart';
import 'package:snggle/passkey_credential_id_generator.dart';
import 'package:snggle/passkey_key_generator.dart';
import 'package:snggle/passkey_registration_context.dart';
import 'package:snggle/passkey_registration_result.dart';
import 'package:snggle/shared/factories/passkey_model_factory.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';

class PasskeyRegistrationService {
  final PasskeyModelFactory _passkeyModelFactory = globalLocator<PasskeyModelFactory>();

  Future<PasskeyRegistrationResult> register({
    required PasskeyRegistrationContext context,
  }) async {
    PasskeyCreationOptions options = PasskeyCreationOptions.fromJson(context.requestJson);

    _validateOptions(options);
    _validateContext(context);

    ECPrivateKey privateKey = PasskeyKeyGenerator.generatePrivateKey();

    Uint8List credentialId = PasskeyCredentialIdGenerator.generate();

    Uint8List cosePublicKey = CborCosePublicKey(
      x: privateKey.publicKey.x,
      y: privateKey.publicKey.y,
    ).toSerializedCbor();

    Uint8List authenticatorData = PasskeyAuthenticatorDataBuilder.build(
      rpId: options.rpId,
      credentialId: credentialId,
      cosePublicKey: cosePublicKey,
    );

    Uint8List attestationObject = CborAttestationObject(
      authenticatorData: authenticatorData,
    ).toSerializedCbor();

    // Credential jest zapisywany dopiero po przygotowaniu
    // wszystkich danych authenticatora.
    PasskeyModel passkeyModel = await _passkeyModelFactory.createNewPasskey(
      rpId: options.rpId,
      rpName: options.rpName,
      userName: options.userName,
      userDisplayName: options.userDisplayName,
      userId: options.userId,
      credentialId: credentialId,
      privateKey: privateKey.bytes,
    );

    return PasskeyRegistrationResult(
      passkeyModel: passkeyModel,
      credentialId: credentialId,
      attestationObject: attestationObject,
    );
  }

  void _validateOptions(PasskeyCreationOptions options) {
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
}
