import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultCreatePageState extends Equatable {
  final bool confirmPageEnabledBool;
  final MnemonicSize? mnemonicSize;
  final List<String>? mnemonic;
  final VaultModel? repeatedVaultModel;
  final bool vaultNameEmptyBool;

  const VaultCreatePageState({
    this.confirmPageEnabledBool = false,
    this.mnemonicSize,
    this.mnemonic,
    this.repeatedVaultModel,
    this.vaultNameEmptyBool = false,
  });

  VaultCreatePageState copyWith({
    bool? confirmPageEnabledBool,
    bool? loadingBool,
    int? lastVaultIndex,
    MnemonicSize? mnemonicSize,
    List<String>? mnemonic,
    VaultModel? repeatedVaultModel,
    bool? vaultNameEmptyBool,
  }) {
    return VaultCreatePageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      mnemonic: mnemonic ?? this.mnemonic,
      repeatedVaultModel: repeatedVaultModel ?? this.repeatedVaultModel,
      vaultNameEmptyBool: vaultNameEmptyBool ?? this.vaultNameEmptyBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, mnemonicSize, mnemonic, repeatedVaultModel, vaultNameEmptyBool];
}
