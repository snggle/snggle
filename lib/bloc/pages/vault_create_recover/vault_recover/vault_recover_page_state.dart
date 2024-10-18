import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VaultRecoverPageState extends Equatable {
  final bool confirmPageEnabledBool;
  final bool loadingBool;
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final bool mnemonicRepeatedBool;
  final int? mnemonicSize;
  final List<TextEditingController>? textControllers;

  const VaultRecoverPageState({
    this.confirmPageEnabledBool = false,
    this.loadingBool = false,
    this.mnemonicValidBool = false,
    this.mnemonicFilledBool = false,
    this.mnemonicRepeatedBool = false,
    this.mnemonicSize,
    this.textControllers,
  });

  const VaultRecoverPageState.loading() : this(loadingBool: true);

  VaultRecoverPageState copyWith({
    bool? confirmPageEnabledBool,
    bool? mnemonicValidBool,
    bool? mnemonicFilledBool,
    bool? mnemonicRepeatedBool,
    int? lastVaultIndex,
    int? mnemonicSize,
    List<FocusNode>? focusNodes,
    List<TextEditingController>? textControllers,
  }) {
    return VaultRecoverPageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      mnemonicValidBool: mnemonicValidBool ?? this.mnemonicValidBool,
      mnemonicFilledBool: mnemonicFilledBool ?? this.mnemonicFilledBool,
      mnemonicRepeatedBool: mnemonicRepeatedBool ?? this.mnemonicRepeatedBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      textControllers: textControllers ?? this.textControllers,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, mnemonicValidBool, mnemonicFilledBool, mnemonicRepeatedBool, mnemonicSize, textControllers];
}
