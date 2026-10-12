import 'dart:convert';
import 'dart:typed_data';

class PasskeyRegistrationResponseBuilder {
  static String build({
    required Uint8List credentialId,
    required Uint8List clientDataJson,
    required Uint8List attestationObject,
  }) {
    String encodedCredentialId = base64UrlEncode(credentialId)
        .replaceAll('=', '');

    String encodedClientDataJson = base64UrlEncode(clientDataJson)
        .replaceAll('=', '');

    String encodedAttestationObject = base64UrlEncode(attestationObject)
        .replaceAll('=', '');

    Map<String, dynamic> response = <String, dynamic>{
      'id': encodedCredentialId,
      'rawId': encodedCredentialId,
      'type': 'public-key',
      'response': <String, dynamic>{
        'clientDataJSON': encodedClientDataJson,
        'attestationObject': encodedAttestationObject,
      },
      'clientExtensionResults': <String, dynamic>{},
      'authenticatorAttachment': 'platform',
    };

    return jsonEncode(response);
  }
}