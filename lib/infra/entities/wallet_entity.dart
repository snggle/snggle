import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletEntity extends Equatable {
  final bool pinnedBool;
  final int index;
  final String address;
  final String derivationPath;
  final String network;
  final String uuid;
  final String parentPath;
  final String? name;

  const WalletEntity({
    required this.pinnedBool,
    required this.index,
    required this.address,
    required this.derivationPath,
    required this.network,
    required this.uuid,
    required this.parentPath,
    this.name,
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      pinnedBool: json['pinned'] as bool,
      index: json['index'] as int,
      address: json['address'] as String,
      derivationPath: json['derivation_path'] as String,
      network: json['network'] as String,
      uuid: json['uuid'] as String,
      parentPath: json['parent_path'] as String,
      name: json['name'] as String?,
    );
  }

  factory WalletEntity.fromWalletModel(WalletModel walletModel) {
    return WalletEntity(
      pinnedBool: walletModel.pinnedBool,
      index: walletModel.index,
      address: walletModel.address,
      derivationPath: walletModel.derivationPath,
      network: walletModel.network,
      uuid: walletModel.uuid,
      parentPath: walletModel.containerPathModel.parentPath,
      name: walletModel.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pinned': pinnedBool,
      'index': index,
      'address': address,
      'derivation_path': derivationPath,
      'network': network,
      'uuid': uuid,
      'parent_path': parentPath,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, index, address, derivationPath, network, uuid, parentPath, name];
}
