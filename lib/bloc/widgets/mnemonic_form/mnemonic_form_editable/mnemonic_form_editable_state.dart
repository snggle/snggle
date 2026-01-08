import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class MnemonicFormEditableState extends Equatable {
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final MnemonicSize mnemonicSize;
  final List<TextEditingController> textControllers;
  final VaultModel? repeatedVaultModel;

  const MnemonicFormEditableState({
    required this.mnemonicSize,
    required this.textControllers,
    this.mnemonicValidBool = false,
    this.mnemonicFilledBool = false,
    this.repeatedVaultModel,
  });

  MnemonicFormEditableState copyWith({
    bool? mnemonicValidBool,
    bool? mnemonicFilledBool,
    MnemonicSize? mnemonicSize,
    List<TextEditingController>? textControllers,
    VaultModel? repeatedVaultModel,
    bool? vaultNameExistsBool,
    bool clearRepeatedVaultModelBool = false,
  }) {
    return MnemonicFormEditableState(
      mnemonicValidBool: mnemonicValidBool ?? this.mnemonicValidBool,
      mnemonicFilledBool: mnemonicFilledBool ?? this.mnemonicFilledBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      textControllers: textControllers ?? this.textControllers,
      repeatedVaultModel: clearRepeatedVaultModelBool ? null : repeatedVaultModel ?? this.repeatedVaultModel,
    );
  }

  bool get mnemonicCompleteBool => mnemonicFilledBool && mnemonicValidBool && repeatedVaultModel == null;

  @override
  List<Object?> get props => <Object?>[mnemonicValidBool, mnemonicFilledBool, mnemonicSize, textControllers, repeatedVaultModel];
}
