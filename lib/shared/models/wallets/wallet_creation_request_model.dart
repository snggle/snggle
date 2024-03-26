import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class WalletCreationRequestModel extends Equatable {
  final int index;
  final String type;
  final String vaultUuid;
  final String derivationPath;
  final Uint8List publicKey;
  final String? name;
  final ContainerPathModel parentContainerPathModel;

  const WalletCreationRequestModel({
    required this.index,
    required this.type,
    required this.vaultUuid,
    required this.derivationPath,
    required this.publicKey,
    required this.parentContainerPathModel,
    this.name,
  });

  @override
  List<Object?> get props => <Object?>[index, type, vaultUuid, derivationPath, publicKey, derivationPath, parentContainerPathModel, name];
}
