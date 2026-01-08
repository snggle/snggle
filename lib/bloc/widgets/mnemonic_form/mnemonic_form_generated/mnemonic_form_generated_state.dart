import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class MnemonicFormGeneratedState extends Equatable {
  final MnemonicSize mnemonicSize;
  final List<String> mnemonic;
  final VaultModel? repeatedVaultModel;

  const MnemonicFormGeneratedState({
    required this.mnemonicSize,
    required this.mnemonic,
    this.repeatedVaultModel,
  });

  MnemonicFormGeneratedState copyWith({
    MnemonicSize? mnemonicSize,
    List<String>? mnemonic,
    VaultModel? repeatedVaultModel,
  }) {
    return MnemonicFormGeneratedState(
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      mnemonic: mnemonic ?? this.mnemonic,
      repeatedVaultModel: repeatedVaultModel ?? this.repeatedVaultModel,
    );
  }

  @override
  List<Object?> get props => <Object?>[mnemonicSize, mnemonic, repeatedVaultModel];
}
