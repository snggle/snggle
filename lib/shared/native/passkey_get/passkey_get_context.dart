import 'dart:typed_data';

class PasskeyGetContext {
  final String mode;
  final String rpId;
  final String requestJson;
  final String? credentialId;
  final Uint8List? clientDataHash;
  final String? callingPackage;

  const PasskeyGetContext({
    required this.mode,
    required this.rpId,
    required this.requestJson,
    this.credentialId,
    this.clientDataHash,
    this.callingPackage,
  });

  factory PasskeyGetContext.fromMap(Map<String, dynamic> map) {
    return PasskeyGetContext(
      mode: map['mode'] as String,
      rpId: map['rpId'] as String,
      requestJson: map['requestJson'] as String,
      credentialId: map['credentialId'] as String?,
      clientDataHash: map['clientDataHash'] as Uint8List?,
      callingPackage: map['callingPackage'] as String?,
    );
  }

  bool get isAuthenticationMode => mode == 'authenticate';
}