import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/dao/secrets_dao_type.dart';
import 'package:snuggle/infra/dao/wallet/wallet_decrypted_secrets_dao.dart';
import 'package:snuggle/infra/dao/wallet/wallet_encrypted_secrets_dao.dart';
import 'package:snuggle/shared/enum_utils.dart';

abstract class AWalletSecretsDao extends Equatable {
  final SecretsDaoType type;

  const AWalletSecretsDao({
    required this.type,
  });

  static AWalletSecretsDao fromJson(Map<String, dynamic> json) {
    final SecretsDaoType secretsDaoType = EnumUtils.parseFromString(SecretsDaoType.values, json['type'] as String);

    switch (secretsDaoType) {
      case SecretsDaoType.decrypted:
        return WalletDecryptedSecretsDao.fromJson(json);
      case SecretsDaoType.encrypted:
        return WalletEncryptedSecretsDao.fromJson(json);
    }
  }
  
  Map<String, dynamic> toJson();
}