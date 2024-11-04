import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultCreatePageState extends Equatable {
  final bool confirmPageEnabledBool;
  final int? mnemonicSize;
  final List<String>? mnemonic;
  final VaultModel? repeatedVaultModel;

  const VaultCreatePageState({
    this.confirmPageEnabledBool = false,
    this.mnemonicSize,
    this.mnemonic,
    this.repeatedVaultModel,
  });

  VaultCreatePageState copyWith({
    bool? confirmPageEnabledBool,
    bool? loadingBool,
    int? lastVaultIndex,
    int? mnemonicSize,
    List<String>? mnemonic,
    VaultModel? repeatedVaultModel,
  }) {
    return VaultCreatePageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      mnemonic: mnemonic ?? this.mnemonic,
      repeatedVaultModel: repeatedVaultModel ?? this.repeatedVaultModel,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, mnemonicSize, mnemonic, repeatedVaultModel];
}
