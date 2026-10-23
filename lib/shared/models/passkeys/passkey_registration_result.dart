import 'dart:typed_data';

import 'package:snggle/shared/models/passkeys/passkey_model.dart';

class PasskeyRegistrationResult {
  final PasskeyModel passkeyModel;
  final Uint8List credentialId;
  final Uint8List attestationObject;
  final Uint8List authenticatorData;
  final Uint8List publicKey;

  const PasskeyRegistrationResult({
    required this.passkeyModel,
    required this.credentialId,
    required this.attestationObject,
    required this.authenticatorData,
    required this.publicKey,
  });
}