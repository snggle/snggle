import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultModel extends AListItemModel {
  final int index;
  final String fingerprint;
  final List<AListItemModel> listItemsPreview;

  VaultModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required super.name,
    required this.index,
    required this.fingerprint,
    required this.listItemsPreview,
  });

  @override
  VaultModel copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    int? index,
    FilesystemPath? filesystemPath,
    String? fingerprint,
    String? name,
    List<AListItemModel>? listItemsPreview,
  }) {
    return VaultModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      fingerprint: fingerprint ?? this.fingerprint,
      name: name ?? this.name,
      listItemsPreview: listItemsPreview ?? this.listItemsPreview,
    );
  }

  @override
  String get name {
    return super.name ?? 'Vault $index'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, index, filesystemPath, fingerprint, name, listItemsPreview];
}
