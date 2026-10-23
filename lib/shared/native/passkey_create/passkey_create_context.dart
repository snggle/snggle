import 'dart:typed_data';

class PasskeyCreateContext {
  final String requestJson;
  final Uint8List? clientDataHash;
  final String? callingPackage;
  final String? origin;
  final bool privilegedBool;

  const PasskeyCreateContext({
    required this.requestJson,
    required this.clientDataHash,
    required this.callingPackage,
    required this.origin,
    required this.privilegedBool,
  });

  factory PasskeyCreateContext.fromMap(
      Map<dynamic, dynamic> map,
      ) {
    return PasskeyCreateContext(
      requestJson: map['requestJson'] as String,
      clientDataHash: map['clientDataHash'] as Uint8List?,
      callingPackage: map['callingPackage'] as String?,
      origin: map['origin'] as String?,
      privilegedBool: map['privilegedBool'] as bool? ?? false,
    );
  }
}