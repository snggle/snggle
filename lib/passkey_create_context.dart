import 'dart:typed_data';

class PasskeyCreateContext {
  final String requestJson;
  final Uint8List clientDataHash;
  final String callingPackage;

  const PasskeyCreateContext({
    required this.requestJson,
    required this.clientDataHash,
    required this.callingPackage,
  });
}