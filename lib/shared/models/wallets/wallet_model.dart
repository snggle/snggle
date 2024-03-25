import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class WalletModel extends AContainerModel {
  final bool pinnedBool;
  final int index;
  final String uuid;
  final String vaultUuid;
  final String address;
  final String derivationPath;
  final String? name;

  WalletModel({
    required this.pinnedBool,
    required this.index,
    required this.uuid,
    required this.vaultUuid,
    required this.address,
    required this.derivationPath,
    this.name,
  }) : super(containerPathModel: ContainerPathModel(<String>[vaultUuid, uuid]));

  WalletModel copyWith({
    bool? pinnedBool,
    int? index,
    String? uuid,
    String? vaultUuid,
    String? address,
    String? derivationPath,
    String? name,
  }) {
    return WalletModel(
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      uuid: uuid ?? this.uuid,
      vaultUuid: vaultUuid ?? this.vaultUuid,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, index, uuid, vaultUuid, address, derivationPath, name];
}
