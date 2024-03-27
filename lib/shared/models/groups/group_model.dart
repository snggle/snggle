import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';

class GroupModel extends AContainerModel {
  final bool pinnedBool;
  final String id;
  final String parentPath;
  final String name;

  GroupModel({
    required this.pinnedBool,
    required this.id,
    required this.parentPath,
    required this.name,
  }) : super(containerPathModel: ContainerPathModel.fromString('${parentPath}/${id}'));

  factory GroupModel.fromNetworkConfig({required NetworkConfigModel networkConfigModel, required String parentPath}) {
    return GroupModel(
      pinnedBool: false,
      id: networkConfigModel.id,
      parentPath: parentPath,
      name: networkConfigModel.name,
    );
  }

  GroupModel copyWith({
    bool? pinnedBool,
    String? id,
    String? parentPath,
    String? name,
  }) {
    return GroupModel(
      pinnedBool: pinnedBool ?? this.pinnedBool,
      id: id ?? this.id,
      parentPath: parentPath ?? this.parentPath,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, id, parentPath, name];
}
