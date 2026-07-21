// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@Entity()
class VaultEntity extends Equatable {
  @Id()
  int id;
  final bool encryptedBool;
  final bool pinnedBool;

  @Index()
  final String fingerprint;

  @Index()
  final int index;

  @Index()
  final String filesystemPathString;
  final String name;

  VaultEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.fingerprint,
    required this.index,
    required this.filesystemPathString,
    required this.name,
  });

  factory VaultEntity.fromVaultModel(VaultModel vaultModel) {
    return VaultEntity(
      id: vaultModel.id,
      encryptedBool: vaultModel.encryptedBool,
      pinnedBool: vaultModel.pinnedBool,
      fingerprint: vaultModel.fingerprint,
      index: vaultModel.index,
      filesystemPathString: vaultModel.filesystemPath.fullPath,
      name: vaultModel.name,
    );
  }

  VaultEntity copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    String? fingerprint,
    int? index,
    String? filesystemPathString,
    String? name,
  }) {
    return VaultEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      fingerprint: fingerprint ?? this.fingerprint,
      index: index ?? this.index,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
    );
  }

  @Transient()
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, fingerprint, index, filesystemPathString, name];
}
