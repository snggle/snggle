import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

abstract class ASecretsModel extends Equatable {
  final String path;

  const ASecretsModel({required this.path});

  static T fromJson<T extends ASecretsModel>(String path, Map<String, dynamic> json) {
    return switch (T) {
      VaultSecretsModel => VaultSecretsModel.fromJson(path, json),
      WalletSecretsModel => WalletSecretsModel.fromJson(path, json),
      Type() => throw ArgumentError('Invalid type: $T'),
    } as T;
  }

  Map<String, dynamic> toJson();
}