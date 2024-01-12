import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

abstract class ASecretsModel extends Equatable {
  final FilesystemPath filesystemPath;

  const ASecretsModel({required this.filesystemPath});

  static T fromJson<T extends ASecretsModel>(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    switch (T) {
      case VaultSecretsModel:
        return VaultSecretsModel.fromJson(filesystemPath, json) as T;
      case WalletSecretsModel:
        return WalletSecretsModel.fromJson(filesystemPath, json) as T;
      default:
        throw ArgumentError('Invalid type: $T');
    }
  }

  Map<String, dynamic> toJson();
}
