import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultEntity extends Equatable {
  final int index;
  final String uuid;
  final String? name;

  const VaultEntity({
    required this.index,
    required this.uuid,
    this.name,
  });

  factory VaultEntity.fromJson(Map<String, dynamic> json) {
    return VaultEntity(
      index: json['index'] as int,
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
    );
  }

  factory VaultEntity.fromVaultModel(VaultModel vaultModel) {
    return VaultEntity(
      index: vaultModel.index,
      uuid: vaultModel.uuid,
      name: vaultModel.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'index': index,
      'uuid': uuid,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[index, uuid, name];
}
