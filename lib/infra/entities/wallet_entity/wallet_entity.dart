import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'wallet_entity.g.dart';

@Collection(accessor: 'wallets', ignore: <String>{'props', 'stringify', 'hashCode'})
class WalletEntity extends Equatable {
  final Id id;
  final bool encryptedBool;
  final bool pinnedBool;
  final String address;
  final String derivationPath;
  @Index()
  final String filesystemPathString;
  final String name;

  const WalletEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.address,
    required this.derivationPath,
    required this.filesystemPathString,
    required this.name,
  });

  factory WalletEntity.fromWalletModel(WalletModel walletModel) {
    return WalletEntity(
      id: walletModel.id,
      encryptedBool: walletModel.encryptedBool,
      pinnedBool: walletModel.pinnedBool,
      address: walletModel.address,
      derivationPath: walletModel.derivationPath,
      filesystemPathString: walletModel.filesystemPath.fullPath,
      name: walletModel.name,
    );
  }

  WalletEntity copyWith({
    Id? id,
    bool? encryptedBool,
    bool? pinnedBool,
    String? address,
    String? derivationPath,
    String? filesystemPathString,
    String? name,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, address, derivationPath, filesystemPathString, name];
}
