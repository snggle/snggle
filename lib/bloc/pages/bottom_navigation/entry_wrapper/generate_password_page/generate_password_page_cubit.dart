import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  final TextEditingController checksumTextEditingController = TextEditingController();
  final TextEditingController entropyTextEditingController = TextEditingController();
  final TextEditingController passwordLengthTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  GeneratePasswordPageCubit() : super(const GeneratePasswordPageState());

  @override
  Future<void> close() async {
    checksumTextEditingController.dispose();
    entropyTextEditingController.dispose();
    passwordLengthTextEditingController.dispose();
    passwordTextEditingController.dispose();

    await super.close();
  }

  Future<void> init() async {
    checksumTextEditingController.text = '';
    entropyTextEditingController.text = '';
    passwordLengthTextEditingController.text = '';
    passwordTextEditingController.text = '';
  }
}
