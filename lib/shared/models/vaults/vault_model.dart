import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class VaultModel extends AContainerModel {
  final bool pinnedBool;
  final int index;
  final String uuid;
  final String? name;

  VaultModel({
    required this.pinnedBool,
    required this.index,
    required this.uuid,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[uuid]));

  VaultModel copyWith({
    bool? pinnedBool,
    int? index,
    String? uuid,
    String? name,
  }) {
    return VaultModel(
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, index, uuid, name];
}
