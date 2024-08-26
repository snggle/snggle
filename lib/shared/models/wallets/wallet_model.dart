import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletModel extends AListItemModel {
  final int index;
  final String address;
  final String derivationPath;

  WalletModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required super.name,
    required this.index,
    required this.address,
    required this.derivationPath,
  });

  @override
  WalletModel copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    int? index,
    String? address,
    String? derivationPath,
    FilesystemPath? filesystemPath,
    String? name,
  }) {
    return WalletModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      index: index ?? this.index,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
    );
  }

  @override
  String get name {
    return super.name ?? 'Wallet $index'.toUpperCase();
  }

  String getShortAddress(int length) {
    return '${address.substring(0, length + 2)}...${address.substring(address.length - length)}';
  }

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, index, address, derivationPath, name, filesystemPath];
}
