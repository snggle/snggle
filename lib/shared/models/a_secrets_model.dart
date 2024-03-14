import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_secrets_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

abstract class ASecretsModel extends Equatable {
  final ContainerPathModel containerPathModel;

  const ASecretsModel({required this.containerPathModel});

  static T fromJson<T extends ASecretsModel>(ContainerPathModel containerPath, Map<String, dynamic> json) {
    return switch (T) {
      VaultSecretsModel => VaultSecretsModel.fromJson(containerPath, json),
      WalletSecretsModel => WalletSecretsModel.fromJson(containerPath, json),
      WalletGroupSecretsModel => WalletGroupSecretsModel.fromJson(containerPath, json),
      Type() => throw ArgumentError('Invalid type: $T'),
    } as T;
  }

  Map<String, dynamic> toJson();
}
