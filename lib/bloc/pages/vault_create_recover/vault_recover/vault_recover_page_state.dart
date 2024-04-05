import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VaultRecoverPageState extends Equatable {
  final bool confirmPageEnabledBool;
  final bool loadingBool;
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final int? lastVaultIndex;
  final int? mnemonicSize;
  final List<TextEditingController>? textControllers;

  const VaultRecoverPageState({
    this.confirmPageEnabledBool = false,
    this.loadingBool = false,
    this.mnemonicValidBool = false,
    this.mnemonicFilledBool = false,
    this.lastVaultIndex,
    this.mnemonicSize,
    this.textControllers,
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
  }) {
    return VaultRecoverPageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      mnemonicValidBool: mnemonicValidBool ?? this.mnemonicValidBool,
      mnemonicFilledBool: mnemonicFilledBool ?? this.mnemonicFilledBool,
      lastVaultIndex: lastVaultIndex ?? this.lastVaultIndex,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      textControllers: textControllers ?? this.textControllers,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, mnemonicValidBool, mnemonicFilledBool, lastVaultIndex, mnemonicSize, textControllers];
}
