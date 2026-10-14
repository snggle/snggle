import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

class PasskeyRegistrationContext {
  final String requestJson;
  final Uint8List? clientDataHash;
  final String origin;
  final bool privilegedBool;

  const PasskeyRegistrationContext({
    required this.requestJson,
    required this.clientDataHash,
    required this.origin,
    required this.privilegedBool,
  });
}