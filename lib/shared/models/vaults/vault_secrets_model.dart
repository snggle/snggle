import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class VaultSecretsModel extends Equatable {
  final String vaultUUid;
  final MnemonicModel mnemonicModel;

  const VaultSecretsModel({
    required this.vaultUUid,
    required this.mnemonicModel,
  });

  factory VaultSecretsModel.decrypt({
    required String vaultUuid,
    required String encryptedSecrets,
    required PasswordModel passwordModel,
  }) {
    String decryptedHash = passwordModel.decrypt(encryptedData: encryptedSecrets);
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return VaultSecretsModel(
      vaultUUid: vaultUuid,
      mnemonicModel: MnemonicModel.fromString(json['mnemonic'] as String),
    );
  }

  String encrypt(PasswordModel passwordModel) {
    Map<String, dynamic> secretsJson = <String, dynamic>{
      'mnemonic': mnemonicModel.toString(),
    };
    String secretsJsonString = jsonEncode(secretsJson);
    return passwordModel.encrypt(decryptedData: secretsJsonString);
  }

  @override
  List<Object?> get props => <Object>[mnemonicModel];
}
