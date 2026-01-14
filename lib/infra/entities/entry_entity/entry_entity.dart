import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'entry_entity.g.dart';

@Collection(accessor: 'entries', ignore: <String>{'props', 'stringify', 'hashCode'})
class EntryEntity extends Equatable {
  final Id id;
  final bool encryptedBool;
  final bool pinnedBool;

  @Index()
  final int index;

  @Index()
  final String filesystemPathString;
  final String? name;
  //final String? login;
  //final String? password;

  const EntryEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.index,
    required this.filesystemPathString,
    this.name,
    //this.login,
    //this.password,
  });

  factory EntryEntity.fromEntryModel(EntryModel entryModel) {
    return EntryEntity(
      id: entryModel.id,
      encryptedBool: entryModel.encryptedBool,
      pinnedBool: entryModel.pinnedBool,
      index: entryModel.index,
      filesystemPathString: entryModel.filesystemPath.fullPath,
      name: entryModel.name,
      //login: entryModel.login,
      //password: entryModel.password,
    );
  }

  EntryEntity copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    String? fingerprint,
    int? index,
    String? filesystemPathString,
    String? name,
    //String? login,
    //String? password,
  }) {
    return EntryEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
      //login: login ?? this.login,
      //password: password ?? this.password,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, index, filesystemPathString, name/*, login, password*/];
}
