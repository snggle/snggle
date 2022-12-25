import 'package:equatable/equatable.dart';
import 'package:snuggle/shared/models/vaults/vault_model.dart';

class VaultListItemModel extends Equatable {
  final VaultModel vaultModel;

  const VaultListItemModel({
    required this.vaultModel,
  });
  
  @override
  List<Object?> get props => <Object>[vaultModel];
}
