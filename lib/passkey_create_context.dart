import 'dart:typed_data';

class PasskeyCreateContext {
  final String requestJson;
  final Uint8List? clientDataHash;
  final String? callingPackage;

  const PasskeyCreateContext({
    required this.requestJson,
    required this.clientDataHash,
    required this.callingPackage,
  });

  factory PasskeyCreateContext.fromMap(
      Map<dynamic, dynamic> map,
      ) {
    return PasskeyCreateContext(
      requestJson: map['requestJson'] as String,
      clientDataHash: map['clientDataHash'] as Uint8List?,
      callingPackage: map['callingPackage'] as String?,
    );
  }
}