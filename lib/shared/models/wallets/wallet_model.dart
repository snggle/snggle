import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletModel extends AListItemModel {
  final int index;
  final String address;
  final String derivationPath;
  final String network;

  WalletModel({
    required super.encryptedBool,
    required super.pinnedBool,
    required super.uuid,
    required super.filesystemPath,
    required super.name,
    required this.index,
    required this.address,
    required this.derivationPath,
    required this.network,
  });

  @override
  WalletModel copyWith({
    bool? encryptedBool,
    bool? pinnedBool,
    int? index,
    String? address,
    String? derivationPath,
    String? network,
    String? uuid,
    FilesystemPath? filesystemPath,
    String? name,
  }) {
    return WalletModel(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      network: network ?? this.network,
      uuid: uuid ?? this.uuid,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
    );
  }

  @override
  String get name {
    return super.name ?? 'Wallet $index'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, index, address, derivationPath, network, uuid, name, filesystemPath];
}
