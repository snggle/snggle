import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class WalletCreationRequestModel extends Equatable {
  final int index;
  final String vaultUuid;
  final String derivationPath;
  final Uint8List publicKey;
  final String? name;

  const WalletCreationRequestModel({
    required this.index,
    required this.vaultUuid,
    required this.derivationPath,
    required this.publicKey,
    this.name,
  });

  @override
  List<Object?> get props => <Object?>[index, vaultUuid, derivationPath, publicKey, derivationPath, name];
}
