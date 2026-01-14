import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryModel extends AListItemModel {
  final int index;

  //final String? login;
  //final String? password;
  //final List<AListItemModel> listItemsPreview;

  EntryModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required super.name,
    required this.index,
    //required this.login,
    //required this.password,
    //required this.listItemsPreview,
  });

  @override
  EntryModel copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    FilesystemPath? filesystemPath,
    String? name,
    int? index,
    //String? login,
    //String? password,
    //List<AListItemModel>? listItemsPreview,
  }) {
    return EntryModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      index: index ?? this.index,
      //login: login ?? this.login,
      //password: password ?? this.password,
      //listItemsPreview: listItemsPreview ?? this.listItemsPreview,
    );
  }

  @override
  String get name {
    return super.name ?? 'Entry $index'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        encryptedBool,
        pinnedBool,
        index,
        filesystemPath,
        name, /*login, password, listItemsPreview*/
      ];

  @override
  String get defaultItemName => 'Entry';
}
