import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultEntity extends Equatable {
  final bool encryptedBool;
  final bool pinnedBool;
  final int index;
  final String uuid;
  final FilesystemPath filesystemPath;
  final String? name;

  const VaultEntity({
    required this.encryptedBool,
    required this.pinnedBool,
    required this.index,
    required this.uuid,
    required this.filesystemPath,
    this.name,
  });

  factory VaultEntity.fromJson(Map<String, dynamic> json) {
    return VaultEntity(
      encryptedBool: json['encrypted'] as bool,
      pinnedBool: json['pinned'] as bool,
      index: json['index'] as int,
      uuid: json['uuid'] as String,
      filesystemPath: FilesystemPath.fromString(json['filesystem_path'] as String),
      name: json['name'] as String?,
    );
  }

  factory VaultEntity.fromVaultModel(VaultModel vaultModel) {
    return VaultEntity(
      encryptedBool: vaultModel.encryptedBool,
      pinnedBool: vaultModel.pinnedBool,
      index: vaultModel.index,
      uuid: vaultModel.uuid,
      filesystemPath: vaultModel.filesystemPath,
      name: vaultModel.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'encrypted': encryptedBool,
      'pinned': pinnedBool,
      'index': index,
      'uuid': uuid,
      'filesystem_path': filesystemPath.fullPath,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, index, uuid, filesystemPath, name];
}
