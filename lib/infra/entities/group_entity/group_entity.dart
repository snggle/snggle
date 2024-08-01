import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'group_entity.g.dart';

@Collection(accessor: 'groups', ignore: <String>{'props', 'stringify', 'hashCode'})
class GroupEntity extends Equatable {
  final Id id;
  final bool pinnedBool;
  final bool encryptedBool;
  final String name;
  @Index()
  final String filesystemPathString;

  const GroupEntity({
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
    Id? id,
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

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object>[id, pinnedBool, encryptedBool, name, filesystemPathString];
}
