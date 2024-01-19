import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletEntity extends Equatable {
  final int index;
  final String uuid;
  final String vaultUuid;
  final String address;
  final String derivationPath;
  final bool passwordProtectedBool;
  final String? name;

  const WalletEntity({
    required this.index,
    required this.uuid,
    required this.vaultUuid,
    required this.address,
    required this.derivationPath,
    required this.passwordProtectedBool,
    this.name,
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      index: json['index'] as int,
      uuid: json['uuid'] as String,
      vaultUuid: json['vault_uuid'] as String,
      address: json['address'] as String,
      derivationPath: json['derivation_path'] as String,
      passwordProtectedBool: json['password_protected'] as bool,
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
      passwordProtectedBool: walletModel.passwordProtectedBool,
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
      'password_protected': passwordProtectedBool,
      'name': name,
    };
  }

  @override
  List<Object?> get props => <Object?>[index, uuid, vaultUuid, address, derivationPath, passwordProtectedBool, name];
}
