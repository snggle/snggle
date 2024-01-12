import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class WalletModel extends AContainerModel {
  final int index;
  final String uuid;
  final String vaultUuid;
  final String address;
  final String derivationPath;
  final String? name;

  WalletModel({
    required this.index,
    required this.uuid,
    required this.vaultUuid,
    required this.address,
    required this.derivationPath,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[vaultUuid, uuid]));

  @override
  List<Object?> get props => <Object?>[index, uuid, vaultUuid, address, derivationPath, name];
}
