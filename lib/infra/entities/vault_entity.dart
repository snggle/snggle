import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultEntity extends Equatable {
  final int index;
  final bool pinnedBool;
  final String uuid;
  final String? name;

  const VaultEntity({
    required this.index,
    required this.pinnedBool,
    required this.uuid,
    this.name,
  });

  factory VaultEntity.fromJson(Map<String, dynamic> json) {
    return VaultEntity(
      index: json['index'] as int,
      pinnedBool: json['pinned'] as bool,
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
    );
  }

  factory VaultEntity.fromVaultModel(VaultModel vaultModel) {
    return VaultEntity(
      index: vaultModel.index,
      pinnedBool: vaultModel.pinnedBool,
      uuid: vaultModel.uuid,
      name: vaultModel.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'index': index,
      'pinned': pinnedBool,
      'uuid': uuid,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[index, pinnedBool, uuid, name];
}
