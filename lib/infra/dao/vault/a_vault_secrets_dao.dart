import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/dao/secrets_dao_type.dart';
import 'package:snuggle/infra/dao/vault/vault_decrypted_secrets_dao.dart';
import 'package:snuggle/infra/dao/vault/vault_encrypted_secrets_dao.dart';
import 'package:snuggle/shared/enum_utils.dart';

abstract class AVaultSecretsDao extends Equatable {
  final SecretsDaoType type;

  const AVaultSecretsDao({
    required this.type,
  });

  static AVaultSecretsDao fromJson(Map<String, dynamic> json) {
    final SecretsDaoType secretsDaoType = EnumUtils.parseFromString(SecretsDaoType.values, json['type'] as String);

    switch (secretsDaoType) {
      case SecretsDaoType.decrypted:
        return VaultDecryptedSecretsDao.fromJson(json);
      case SecretsDaoType.encrypted:
        return VaultEncryptedSecretsDao.fromJson(json);
    }
  }
  
  Map<String, dynamic> toJson();
}
