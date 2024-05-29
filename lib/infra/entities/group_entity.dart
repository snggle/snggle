import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/group_type.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupEntity extends Equatable {
  final bool pinnedBool;
  final bool encryptedBool;
  final String uuid;
  final String name;
  final FilesystemPath filesystemPath;

  const GroupEntity({
    required this.pinnedBool,
    required this.encryptedBool,
    required this.uuid,
    required this.name,
    required this.filesystemPath,
  });

  factory GroupEntity.fromJson(Map<String, dynamic> json) {
    return GroupEntity(
      pinnedBool: json['pinned'] as bool,
      encryptedBool: json['encrypted'] as bool,
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      filesystemPath: FilesystemPath.fromString(json['filesystem_path'] as String),
    );
  }

  factory GroupEntity.fromGroupModel(GroupModel groupModel) {
    return GroupEntity(
      pinnedBool: groupModel.pinnedBool,
      encryptedBool: groupModel.encryptedBool,
      uuid: groupModel.uuid,
      name: groupModel.name,
      filesystemPath: groupModel.filesystemPath,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': GroupType.group.name,
      'pinned': pinnedBool,
      'encrypted': encryptedBool,
      'uuid': uuid,
      'name': name,
      'filesystem_path': filesystemPath.fullPath,
    };
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, encryptedBool, uuid, name, filesystemPath];
}
