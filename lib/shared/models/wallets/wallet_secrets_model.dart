import 'dart:typed_data';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';

class WalletSecretsModel extends ASecretsModel {
  final Uint8List privateKey;

  const WalletSecretsModel({
    required String path,
    required this.privateKey,
  }) : super(path: path);

  factory WalletSecretsModel.fromJson(String path, Map<String, dynamic> json) {
    return WalletSecretsModel(
      path: path,
      privateKey: Uint8List.fromList(hex.decode(json['private_key'] as String)),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'private_key': hex.encode(privateKey)};
  }

  @override
  List<Object?> get props => <Object?>[path, privateKey];
}
