import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path.dart';

class VaultModel extends AContainerModel {
  final int index;
  final String uuid;
  final String? name;
  bool passwordProtectedBool;

  VaultModel({
    required this.index,
    required this.uuid,
    required this.passwordProtectedBool,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[uuid]));

  @override
  List<Object?> get props => <Object?>[index, uuid, passwordProtectedBool, name];
}
