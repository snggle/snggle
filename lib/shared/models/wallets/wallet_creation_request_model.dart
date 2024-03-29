import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/container_path_model.dart';

class WalletCreationRequestModel extends Equatable {
  final int index;
  final String derivationPath;
  final String network;
  final Uint8List publicKey;
  final ContainerPathModel parentContainerPathModel;
  final String? name;

  const WalletCreationRequestModel({
    required this.index,
    required this.derivationPath,
    required this.network,
    required this.publicKey,
    required this.parentContainerPathModel,
    this.name,
  });

  @override
  List<Object?> get props => <Object?>[index, derivationPath, network, publicKey, parentContainerPathModel, name];
}
