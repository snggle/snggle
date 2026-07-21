import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@Entity()
// ignore_for_file: must_be_immutable
/*
All fields of a class which extends Equatable should be immutable, but ObjectBox
requires the `id` field to be mutable because its value is set after an instance of
the class has been created.  Because of this, we ignore the linter rule
"must_be_immutable" on all ObjectBox entities.
*/
class WalletEntity extends Equatable {
  @Id()
  int id;
  final bool encryptedBool;
  final bool pinnedBool;
  final String address;
  final String derivationPath;
  @Index()
  final String filesystemPathString;
  final String name;

  WalletEntity({
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
    int? id,
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

  @Transient()
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, address, derivationPath, filesystemPathString, name];
}
