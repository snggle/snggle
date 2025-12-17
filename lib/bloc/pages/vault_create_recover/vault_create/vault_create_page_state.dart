import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultCreatePageState extends Equatable {
  final bool confirmPageEnabledBool;
  final MnemonicSize? mnemonicSize;
  final List<String>? mnemonic;
  final VaultModel? repeatedVaultModel;
  final bool vaultNameExistsBool;

  const VaultCreatePageState({
    this.confirmPageEnabledBool = false,
    this.mnemonicSize,
    this.mnemonic,
    this.repeatedVaultModel,
    this.vaultNameExistsBool = false,
  });

  VaultCreatePageState copyWith({
    bool? confirmPageEnabledBool,
    bool? loadingBool,
    int? lastVaultIndex,
    MnemonicSize? mnemonicSize,
    List<String>? mnemonic,
    VaultModel? repeatedVaultModel,
    bool? vaultNameExistsBool,
  }) {
    return VaultCreatePageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      mnemonic: mnemonic ?? this.mnemonic,
      repeatedVaultModel: repeatedVaultModel ?? this.repeatedVaultModel,
      vaultNameExistsBool: vaultNameExistsBool ?? this.vaultNameExistsBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, mnemonicSize, mnemonic, repeatedVaultModel, vaultNameExistsBool];
}
