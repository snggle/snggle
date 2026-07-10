import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultCreatePageState extends Equatable {
  final bool mnemonicFormVisibleBool;
  final bool nameEmptyBool;
  final MnemonicModel? mnemonicModel;
  final VaultModel? repeatedVaultModel;

  const VaultCreatePageState({
    this.mnemonicFormVisibleBool = false,
    this.nameEmptyBool = false,
    this.mnemonicModel,
    this.repeatedVaultModel,
  });

  VaultCreatePageState copyWith({
    bool? mnemonicFormVisibleBool,
    bool? nameEmptyBool,
    MnemonicModel? mnemonicModel,
    VaultModel? repeatedVaultModel,
  }) {
    return VaultCreatePageState(
      mnemonicFormVisibleBool: mnemonicFormVisibleBool ?? this.mnemonicFormVisibleBool,
      mnemonicModel: mnemonicModel ?? this.mnemonicModel,
      repeatedVaultModel: repeatedVaultModel ?? this.repeatedVaultModel,
      nameEmptyBool: nameEmptyBool ?? this.nameEmptyBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        mnemonicFormVisibleBool,
        nameEmptyBool,
        mnemonicModel,
        repeatedVaultModel,
      ];
}
