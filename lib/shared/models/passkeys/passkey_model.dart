import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

class PasskeyModel {
  final String rpId;
  final String rpName;

  final String userName;
  final String userDisplayName;
  final Uint8List userId;

  final Uint8List credentialId;

  final int algorithm;
  final int signCount;

  const PasskeyModel({
    required this.rpId,
    required this.rpName,
    required this.userName,
    required this.userDisplayName,
    required this.userId,
    required this.credentialId,
    required this.algorithm,
    required this.signCount,
  });
}