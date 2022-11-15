import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/dao/vault/a_vault_secrets_dao.dart';

class SaveVaultRequest extends Equatable {
  final String id;
  final String name;
  final AVaultSecretsDao vaultSecretsDao;

  const SaveVaultRequest({
    required this.id,
    required this.name,
    required this.vaultSecretsDao,
  });

  @override
  List<Object?> get props => <Object>[id, name, vaultSecretsDao];
}
