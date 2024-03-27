import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/groups/group_model.dart';

class GroupEntity extends Equatable {
  final bool pinnedBool;
  final String id;
  final String parentPath;
  final String name;

  const GroupEntity({
    required this.pinnedBool,
    required this.id,
    required this.parentPath,
    required this.name,
  });

  factory GroupEntity.fromJson(Map<String, dynamic> json) {
    return GroupEntity(
      pinnedBool: json['pinned'] as bool,
      id: json['id'] as String,
      parentPath: json['access_path'] as String,
      name: json['name'] as String,
    );
  }

  factory GroupEntity.fromGroupModel(GroupModel groupModel) {
    return GroupEntity(
      pinnedBool: groupModel.pinnedBool,
      id: groupModel.id,
      parentPath: groupModel.parentPath,
      name: groupModel.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pinned': pinnedBool,
      'id': id,
      'access_path': parentPath,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, id, parentPath, name];
}
