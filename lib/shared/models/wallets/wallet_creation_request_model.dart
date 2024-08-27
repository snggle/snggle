import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletCreationRequestModel extends Equatable {
  final int index;
  final String derivationPathString;
  final FilesystemPath parentFilesystemPath;
  final AHDWallet hdWallet;
  final String? name;

  const WalletCreationRequestModel({
    required this.index,
    required this.derivationPathString,
    required this.parentFilesystemPath,
    required this.hdWallet,
    this.name,
  });

  @override
  List<Object?> get props => <Object?>[index, derivationPathString, parentFilesystemPath, hdWallet, name];
}
