import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletCreationRequestModel extends Equatable {
  final String derivationPath;
  final String name;
  final Uint8List publicKey;
  final Uint8List privateKey;
  final FilesystemPath parentFilesystemPath;

  const WalletCreationRequestModel({
    required this.derivationPath,
    required this.name,
    required this.publicKey,
    required this.privateKey,
    required this.parentFilesystemPath,
  });

  @override
  List<Object?> get props => <Object?>[derivationPath, name, publicKey, parentFilesystemPath];
}
