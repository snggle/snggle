import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class VaultModel extends AContainerModel {
  final int index;
  final String uuid;
  final bool pinnedBool;
  final String? name;

  VaultModel({
    required this.index,
    required this.uuid,
    required this.pinnedBool,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[uuid]));

  VaultModel copyWith({
    int? index,
    bool? pinnedBool,
    String? uuid,
    String? name,
  }) {
    return VaultModel(
      index: index ?? this.index,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, pinnedBool, uuid, name];
}
