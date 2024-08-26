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
  final int index;
  final String address;
  final String derivationPath;
  @Index()
  final String filesystemPathString;
  final String? name;

  const WalletEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.index,
    required this.address,
    required this.derivationPath,
    required this.filesystemPathString,
    this.name,
  });

  factory WalletEntity.fromWalletModel(WalletModel walletModel) {
    return WalletEntity(
      id: walletModel.id,
      encryptedBool: walletModel.encryptedBool,
      pinnedBool: walletModel.pinnedBool,
      index: walletModel.index,
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
    int? index,
    String? address,
    String? derivationPath,
    String? filesystemPathString,
    String? name,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, index, address, derivationPath, filesystemPathString, name];
}
