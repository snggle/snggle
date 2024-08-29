import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupModel extends AListItemModel {
  final List<AListItemModel> listItemsPreview;
  final String _name;

  GroupModel({
    required super.id,
    required super.pinnedBool,
    required super.encryptedBool,
    required super.filesystemPath,
    required this.listItemsPreview,
    required String name,
  }) : _name = name;

  @override
  GroupModel copyWith({
    int? id,
    bool? pinnedBool,
    bool? encryptedBool,
    List<AListItemModel>? listItemsPreview,
    FilesystemPath? filesystemPath,
    String? name,
  }) {
    return GroupModel(
      id: id ?? this.id,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      listItemsPreview: listItemsPreview ?? this.listItemsPreview,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
    );
  }

  @override
  String get name => _name;

  bool get hasSingleItem => listItemsPreview.length == 1;

  @override
  List<Object?> get props => <Object?>[id, pinnedBool, encryptedBool, listItemsPreview, filesystemPath, name];
}
