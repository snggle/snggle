import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';

class AppMasterKeyRecoverPageState extends Equatable {
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final List<TextEditingController> textControllersList;
  final MnemonicModel? mnemonicModel;

  const AppMasterKeyRecoverPageState({
    this.mnemonicValidBool = false,
    this.mnemonicFilledBool = false,
    this.textControllersList = const <TextEditingController>[],
    this.mnemonicModel,
  });

  AppMasterKeyRecoverPageState copyWith({
    bool? mnemonicValidBool,
    bool? mnemonicFilledBool,
    List<TextEditingController>? textControllersList,
    MnemonicModel? mnemonicModel,
  }) {
    return AppMasterKeyRecoverPageState(
      mnemonicValidBool: mnemonicValidBool ?? this.mnemonicValidBool,
      mnemonicFilledBool: mnemonicFilledBool ?? this.mnemonicFilledBool,
      textControllersList: textControllersList ?? this.textControllersList,
      mnemonicModel: mnemonicModel ?? this.mnemonicModel,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        mnemonicValidBool,
        mnemonicFilledBool,
        textControllersList,
        mnemonicModel,
      ];
}
