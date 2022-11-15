import 'dart:typed_data';

import 'package:snuggle/infra/dao/secrets_dao_type.dart';
import 'package:snuggle/infra/dao/vault/a_vault_secrets_dao.dart';
import 'package:snuggle/shared/enum_utils.dart';

class VaultDecryptedSecretsDao extends AVaultSecretsDao {
  final Uint8List seed;

  const VaultDecryptedSecretsDao({
    required this.seed,
  }) : super(type: SecretsDaoType.decrypted);
  
  factory VaultDecryptedSecretsDao.fromJson(Map<String, dynamic> json) {
    List<dynamic> unparsedSeed = json['seed'] as List<dynamic>;
    return VaultDecryptedSecretsDao(
      seed: Uint8List.fromList(unparsedSeed.map((dynamic e) => e as int).toList()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': EnumUtils.parseToString(type),
      'seed': seed,
    };
  }

  @override
  List<Object?> get props => <Object>[seed, type];
}
