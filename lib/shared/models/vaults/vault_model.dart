import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class VaultModel extends AContainerModel {
  final int index;
  final String uuid;
  final String? name;

  VaultModel({
    required this.index,
    required this.uuid,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[uuid]));

  VaultModel copyWith({
    int? index,
    bool? encryptedBool,
    String? uuid,
    String? name,
  }) {
    return VaultModel(
      index: index ?? this.index,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, uuid, name];
}
