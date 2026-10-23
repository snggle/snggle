import 'dart:convert';
import 'dart:typed_data';

class PasskeyRegistrationResponseBuilder {
  static String build({
    required Uint8List credentialId,
    required Uint8List attestationObject,
    required Uint8List authenticatorData,
    required Uint8List publicKey,
  }) {
    String encodedCredentialId =
    base64UrlEncode(credentialId).replaceAll('=', '');

    String encodedAttestationObject =
    base64UrlEncode(attestationObject).replaceAll('=', '');

    String encodedAuthenticatorData =
    base64UrlEncode(authenticatorData).replaceAll('=', '');

    String encodedPublicKey =
    base64UrlEncode(publicKey).replaceAll('=', '');

    Map<String, dynamic> response = <String, dynamic>{
      'id': encodedCredentialId,
      'rawId': encodedCredentialId,
      'type': 'public-key',
      'response': <String, dynamic>{
        'clientDataJSON': 'e30',
        'attestationObject': encodedAttestationObject,
        'publicKeyAlgorithm': -7,
        'authenticatorData': encodedAuthenticatorData,
        'publicKey': encodedPublicKey,
        'transports': <String>['internal'],
      },
      'clientExtensionResults': <String, dynamic>{},
      'authenticatorAttachment': 'platform',
    };

    return jsonEncode(response);
  }
}