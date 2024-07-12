import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'vault_entity.g.dart';

@Collection(accessor: 'vaults', ignore: <String>{'props', 'stringify', 'hashCode'})
class VaultEntity extends Equatable {
  final Id id;
  final bool encryptedBool;
  final bool pinnedBool;

  @Index()
  final int index;

  @Index()
  final String filesystemPathString;
  final String? name;

  const VaultEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.index,
    required this.filesystemPathString,
    this.name,
  });

  factory VaultEntity.fromVaultModel(VaultModel vaultModel) {
    return VaultEntity(
      id: vaultModel.id,
      encryptedBool: vaultModel.encryptedBool,
      pinnedBool: vaultModel.pinnedBool,
      index: vaultModel.index,
      filesystemPathString: vaultModel.filesystemPath.fullPath,
      name: vaultModel.name,
    );
  }

  VaultEntity copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    int? index,
    String? filesystemPathString,
    String? name,
  }) {
    return VaultEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, index, filesystemPathString, name];
}
