import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultRecoverPageState extends Equatable {
  final bool confirmPageEnabledBool;
  final bool loadingBool;
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final int? mnemonicSize;
  final List<TextEditingController>? textControllers;
  final VaultModel? repeatedVaultModel;
  final bool vaultNameEmptyBool;

  const VaultRecoverPageState({
    this.confirmPageEnabledBool = false,
    this.loadingBool = false,
    this.mnemonicValidBool = false,
    this.mnemonicFilledBool = false,
    this.mnemonicSize,
    this.textControllers,
    this.repeatedVaultModel,
    this.vaultNameEmptyBool = false,
  });

  const VaultRecoverPageState.loading() : this(loadingBool: true);

  VaultRecoverPageState copyWith({
    bool? confirmPageEnabledBool,
    bool? mnemonicValidBool,
    bool? mnemonicFilledBool,
    int? lastVaultIndex,
    int? mnemonicSize,
    List<FocusNode>? focusNodes,
    List<TextEditingController>? textControllers,
    VaultModel? repeatedVaultModel,
    bool clearRepeatedVaultModelBool = false,
    bool? vaultNameEmptyBool,
  }) {
    return VaultRecoverPageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      mnemonicValidBool: mnemonicValidBool ?? this.mnemonicValidBool,
      mnemonicFilledBool: mnemonicFilledBool ?? this.mnemonicFilledBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      textControllers: textControllers ?? this.textControllers,
      repeatedVaultModel: clearRepeatedVaultModelBool ? null : repeatedVaultModel ?? this.repeatedVaultModel,
      vaultNameEmptyBool: vaultNameEmptyBool ?? this.vaultNameEmptyBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        confirmPageEnabledBool,
        mnemonicValidBool,
        mnemonicFilledBool,
        mnemonicSize,
        textControllers,
        repeatedVaultModel,
        vaultNameEmptyBool,
      ];
}
