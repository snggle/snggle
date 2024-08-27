import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletCreationRequestModel extends Equatable {
  final String derivationPathString;
  final String name;
  final FilesystemPath parentFilesystemPath;
  final AHDWallet hdWallet;

  const WalletCreationRequestModel({
    required this.derivationPathString,
    required this.name,
    required this.parentFilesystemPath,
    required this.hdWallet,
  });

  @override
  List<Object?> get props => <Object?>[derivationPathString, name, parentFilesystemPath, hdWallet];
}
