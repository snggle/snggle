import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletCreationRequestModel extends Equatable {
  final int index;
  final String derivationPath;
  final String network;
  final Uint8List publicKey;
  final Uint8List privateKey;
  final FilesystemPath parentFilesystemPath;
  final String? name;

  const WalletCreationRequestModel({
    required this.index,
    required this.derivationPath,
    required this.network,
    required this.publicKey,
    required this.privateKey,
    required this.parentFilesystemPath,
    this.name,
  });

  @override
  List<Object?> get props => <Object?>[index, derivationPath, network, publicKey, parentFilesystemPath, name];
}
