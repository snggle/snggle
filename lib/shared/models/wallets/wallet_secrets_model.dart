import 'dart:convert';
import 'dart:typed_data';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/password_model.dart';

class WalletSecretsModel extends Equatable {
  final String walletUuid;
  final Uint8List privateKey;

  const WalletSecretsModel({
    required this.walletUuid,
    required this.privateKey,
  });

  factory WalletSecretsModel.decrypt({
    required String walletUuid,
    required String encryptedSecrets,
    required PasswordModel passwordModel,
  }) {
    String decryptedHash = passwordModel.decrypt(encryptedData: encryptedSecrets);
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return WalletSecretsModel(
      walletUuid: walletUuid,
      privateKey: Uint8List.fromList(hex.decode(json['private_key'] as String)),
    );
  }

  String encrypt(PasswordModel passwordModel) {
    Map<String, dynamic> secretsJson = <String, dynamic>{
      'private_key': hex.encode(privateKey),
    };
    String secretsJsonString = jsonEncode(secretsJson);
    return passwordModel.encrypt(decryptedData: secretsJsonString);
  }

  @override
  List<Object?> get props => <Object?>[privateKey];
}
