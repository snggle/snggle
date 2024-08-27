import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletModel extends AListItemModel {
  final String address;
  final String derivationPath;

  WalletModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required String super.name,
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
    String? address,
    String? derivationPath,
  }) {
    return WalletModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
    );
  }

  @override
  int compareTo(AListItemModel other) {
    if ((other is WalletModel) == false) {
      return super.compareTo(other);
    }

    bool pinnedEqualBool = pinnedBool == other.pinnedBool;
    if (pinnedEqualBool == false) {
      return pinnedBool ? -1 : 1;
    }

    LegacyDerivationPath thisDerivationPath = LegacyDerivationPath.parse(derivationPath);
    LegacyDerivationPath otherDerivationPath = LegacyDerivationPath.parse((other as WalletModel).derivationPath);

    int thisIndex = thisDerivationPath.pathElements.last.rawIndex;
    int otherIndex = otherDerivationPath.pathElements.last.rawIndex;

    return thisIndex.compareTo(otherIndex);
  }

  @override
  String get name => super.name!;

  String getShortAddress(int length) {
    return '${address.substring(0, length + 2)}...${address.substring(address.length - length)}';
  }

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, filesystemPath, name, address, derivationPath];
}
