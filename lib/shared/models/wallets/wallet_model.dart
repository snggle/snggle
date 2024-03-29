import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class WalletModel extends AContainerModel {
  final bool pinnedBool;
  final int index;
  final String address;
  final String derivationPath;
  final String network;
  final String uuid;
  final String? name;

  WalletModel({
    required this.pinnedBool,
    required this.index,
    required this.address,
    required this.derivationPath,
    required this.network,
    required this.uuid,
    required String parentPath,
    this.name,
  }) : super(containerPathModel: ContainerPathModel.fromString('${parentPath}/${uuid}'));

  WalletModel copyWith({
    bool? pinnedBool,
    int? index,
    String? address,
    String? derivationPath,
    String? network,
    String? uuid,
    String? parentPath,
    String? name,
  }) {
    return WalletModel(
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      network: network ?? this.network,
      uuid: uuid ?? this.uuid,
      parentPath: parentPath ?? containerPathModel.parentPath,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[containerPathModel, pinnedBool, index, address, derivationPath, network, uuid, name];
}
