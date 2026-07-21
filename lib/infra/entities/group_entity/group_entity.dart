import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@Entity()
// ignore_for_file: must_be_immutable
/*
All fields of a class which extends Equatable should be immutable, but ObjectBox
requires the `id` field to be mutable because its value is set after an instance of
the class has been created.  Because of this, we ignore the linter rule
"must_be_immutable" on all ObjectBox entities.
*/
class GroupEntity extends Equatable {
  @Id()
  int id;
  final bool pinnedBool;
  final bool encryptedBool;
  final String name;
  @Index()
  final String filesystemPathString;

  GroupEntity({
    required this.id,
    required this.pinnedBool,
    required this.encryptedBool,
    required this.name,
    required this.filesystemPathString,
  });

  factory GroupEntity.fromGroupModel(GroupModel groupModel) {
    return GroupEntity(
      id: groupModel.id,
      pinnedBool: groupModel.pinnedBool,
      encryptedBool: groupModel.encryptedBool,
      name: groupModel.name,
      filesystemPathString: groupModel.filesystemPath.fullPath,
    );
  }

  GroupEntity copyWith({
    int? id,
    bool? pinnedBool,
    bool? encryptedBool,
    String? name,
    String? filesystemPathString,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      name: name ?? this.name,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
    );
  }

  @Transient()
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object>[id, pinnedBool, encryptedBool, name, filesystemPathString];
}
