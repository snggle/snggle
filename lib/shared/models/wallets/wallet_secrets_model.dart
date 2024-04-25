import 'dart:typed_data';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletSecretsModel extends ASecretsModel {
  final Uint8List privateKey;

  const WalletSecretsModel({
    required super.filesystemPath,
    required this.privateKey,
  });

  factory WalletSecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    return WalletSecretsModel(
      filesystemPath: filesystemPath,
      privateKey: Uint8List.fromList(hex.decode(json['private_key'] as String)),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'private_key': hex.encode(privateKey)};
  }

  @override
  List<Object?> get props => <Object?>[privateKey];
}
