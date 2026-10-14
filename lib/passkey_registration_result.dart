import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:snggle/shared/models/passkeys/passkey_model.dart';

class PasskeyRegistrationResult {
  final PasskeyModel passkeyModel;
  final Uint8List credentialId;
  final Uint8List attestationObject;

  const PasskeyRegistrationResult({
    required this.passkeyModel,
    required this.credentialId,
    required this.attestationObject,
  });
}