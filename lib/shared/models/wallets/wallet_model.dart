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
    FilesystemPath? filesystemPath,
    String? name,
    int? index,
    String? address,
    String? derivationPath,
  }) {
    return WalletModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      index: index ?? this.index,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
    );
  }

  @override
  String get name {
    return super.name ?? 'Wallet $index'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, filesystemPath, name, index, address, derivationPath];
}
