import 'dart:convert';
import 'dart:typed_data';

class PasskeyCreationOptions {
  final String rpId;
  final String rpName;
  final String userName;
  final String userDisplayName;
  final Uint8List userId;
  final Uint8List challenge;
  final List<int> supportedAlgorithms;

  const PasskeyCreationOptions({
    required this.rpId,
    required this.rpName,
    required this.userName,
    required this.userDisplayName,
    required this.userId,
    required this.challenge,
    required this.supportedAlgorithms,
  });

  factory PasskeyCreationOptions.fromJson(String requestJson) {
    Map<String, dynamic> json = jsonDecode(requestJson) as Map<String, dynamic>;

    Map<String, dynamic> rp = json['rp'] as Map<String, dynamic>;
    Map<String, dynamic> user = json['user'] as Map<String, dynamic>;

    List<Map<String, dynamic>> pubKeyCredParams =
    (json['pubKeyCredParams'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    List<int> supportedAlgorithms = pubKeyCredParams
        .where((Map<String, dynamic> param) => param['type'] == 'public-key')
        .map<int>((Map<String, dynamic> param) => param['alg'] as int)
        .toList();

    String rpId = rp['id'] as String;
    String rpName = rp['name'] as String;
    String userName = user['name'] as String;
    String userDisplayName = user['displayName'] as String;

    String encodedUserId = user['id'] as String;
    String encodedChallenge = json['challenge'] as String;

    Uint8List userId = base64Url.decode(base64Url.normalize(encodedUserId));
    Uint8List challenge = base64Url.decode(base64Url.normalize(encodedChallenge));

    return PasskeyCreationOptions(
      rpId: rpId,
      rpName: rpName,
      userName: userName,
      userDisplayName: userDisplayName,
      userId: userId,
      challenge: challenge,
      supportedAlgorithms: supportedAlgorithms,
    );
  }

  bool get supportsES256 => supportedAlgorithms.contains(-7);
}
