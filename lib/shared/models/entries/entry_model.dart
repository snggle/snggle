import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entry_preview_item_type.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryModel extends AListItemModel {
  final int index;
  final String website;
  final bool emailExistsBool;
  final bool usernameExistsBool;
  final bool passwordExistsBool;
  final bool totpExistsBool;

  EntryModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required super.name,
    required this.index,
    required this.website,
    this.emailExistsBool = false,
    this.usernameExistsBool = false,
    this.passwordExistsBool = false,
    this.totpExistsBool = false,
  });

  @override
  EntryModel copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    FilesystemPath? filesystemPath,
    String? name,
    int? index,
    String? website,
    bool? emailExistsBool,
    bool? usernameExistsBool,
    bool? passwordExistsBool,
    bool? totpExistsBool,
  }) {
    return EntryModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      index: index ?? this.index,
      website: website ?? this.website,
      emailExistsBool: emailExistsBool ?? this.emailExistsBool,
      usernameExistsBool: usernameExistsBool ?? this.usernameExistsBool,
      passwordExistsBool: passwordExistsBool ?? this.passwordExistsBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
    );
  }

  @override
  String get defaultItemName => 'Entry';

  @override
  String get name {
    return super.name ?? 'Entry $index'.toUpperCase();
  }

  List<EntryPreviewItemType> get previewItems => <EntryPreviewItemType>[
        if (emailExistsBool) EntryPreviewItemType.email,
        if (usernameExistsBool) EntryPreviewItemType.username,
        if (passwordExistsBool) EntryPreviewItemType.password,
        if (totpExistsBool) EntryPreviewItemType.totp,
      ];

  @override
  List<Object?> get props => <Object?>[
        id,
        encryptedBool,
        pinnedBool,
        index,
        filesystemPath,
        name,
        website,
        emailExistsBool,
        usernameExistsBool,
        passwordExistsBool,
        totpExistsBool,
      ];
}
