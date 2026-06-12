import 'package:equatable/equatable.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'entry_entity.g.dart';

@Collection(accessor: 'entries', ignore: <String>{'props', 'stringify', 'hashCode'})
class EntryEntity extends Equatable {
  final Id id;
  final bool encryptedBool;
  final bool pinnedBool;
  final bool emailExistsBool;
  final bool usernameExistsBool;
  final bool passwordExistsBool;

  @Index()
  final int index;

  @Index()
  final String filesystemPathString;
  final String name;
  final String website;

  const EntryEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.emailExistsBool,
    required this.usernameExistsBool,
    required this.passwordExistsBool,
    required this.index,
    required this.filesystemPathString,
    required this.name,
    required this.website,
  });

  factory EntryEntity.fromEntryModel(EntryModel entryModel) {
    return EntryEntity(
      id: entryModel.id,
      encryptedBool: entryModel.encryptedBool,
      pinnedBool: entryModel.pinnedBool,
      emailExistsBool: entryModel.emailExistsBool,
      usernameExistsBool: entryModel.usernameExistsBool,
      passwordExistsBool: entryModel.passwordExistsBool,
      index: entryModel.index,
      filesystemPathString: entryModel.filesystemPath.fullPath,
      name: entryModel.name,
      website: entryModel.website,
    );
  }

  EntryEntity copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    bool? emailExistsBool,
    bool? usernameExistsBool,
    bool? passwordExistsBool,
    String? fingerprint,
    int? index,
    String? filesystemPathString,
    String? name,
    String? website,
  }) {
    return EntryEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      emailExistsBool: emailExistsBool ?? this.emailExistsBool,
      usernameExistsBool: usernameExistsBool ?? this.usernameExistsBool,
      passwordExistsBool: passwordExistsBool ?? this.passwordExistsBool,
      index: index ?? this.index,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
      website: website ?? this.website,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[
    id,
    encryptedBool,
    pinnedBool,
    emailExistsBool,
    usernameExistsBool,
    passwordExistsBool,
    index,
    filesystemPathString,
    name,
    website,
  ];
}
