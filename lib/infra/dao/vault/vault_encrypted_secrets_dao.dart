import 'package:snuggle/infra/dao/secrets_dao_type.dart';
import 'package:snuggle/infra/dao/vault/a_vault_secrets_dao.dart';
import 'package:snuggle/shared/enum_utils.dart';

class VaultEncryptedSecretsDao extends AVaultSecretsDao {
  final String hash;

  const VaultEncryptedSecretsDao({
    required this.hash,
  }) : super(type: SecretsDaoType.encrypted);

  factory VaultEncryptedSecretsDao.fromJson(Map<String, dynamic> json) {
    return VaultEncryptedSecretsDao(
      hash: json['hash'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': EnumUtils.parseToString(type),
      'hash': hash,
    };
  }

  @override
  List<Object?> get props => <Object>[hash, type];
}
