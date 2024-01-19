import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path.dart';

class WalletModel extends AContainerModel {
  final int index;
  final String uuid;
  final String vaultUuid;
  final String address;
  final String derivationPath;
  final String? name;
  bool passwordProtectedBool;

  WalletModel({
    required this.index,
    required this.uuid,
    required this.vaultUuid,
    required this.address,
    required this.derivationPath,
    required this.passwordProtectedBool,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[vaultUuid, uuid]));

  @override
  List<Object?> get props => <Object?>[index, uuid, vaultUuid, address, derivationPath, passwordProtectedBool, name];
}
