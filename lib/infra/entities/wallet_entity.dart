import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletEntity extends Equatable {
  final int index;
  final String uuid;
  final String vaultUuid;
  final String address;
  final String derivationPath;
  final String? name;

  const WalletEntity({
    required this.index,
    required this.uuid,
    required this.vaultUuid,
    required this.address,
    required this.derivationPath,
    this.name,
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      index: json['index'] as int,
      uuid: json['uuid'] as String,
      vaultUuid: json['vault_uuid'] as String,
      address: json['address'] as String,
      derivationPath: json['derivation_path'] as String,
      name: json['name'] as String?,
    );
  }

  factory WalletEntity.fromWalletModel(WalletModel walletModel) {
    return WalletEntity(
      index: walletModel.index,
      uuid: walletModel.uuid,
      vaultUuid: walletModel.vaultUuid,
      address: walletModel.address,
      derivationPath: walletModel.derivationPath,
      name: walletModel.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'index': index,
      'uuid': uuid,
      'vault_uuid': vaultUuid,
      'address': address,
      'derivation_path': derivationPath,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[index, uuid, vaultUuid, address, derivationPath, name];
}
