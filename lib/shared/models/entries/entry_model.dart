import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryModel extends AListItemModel {
  final int index;

  EntryModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required super.name,
    required this.index,
  });

  @override
  EntryModel copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    FilesystemPath? filesystemPath,
    String? name,
    int? index,
  }) {
    return EntryModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      index: index ?? this.index,
    );
  }

  @override
  String get defaultItemName => 'Entry';

  @override
  String get name {
    return super.name ?? 'Entry $index'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, index, filesystemPath, name];
}
