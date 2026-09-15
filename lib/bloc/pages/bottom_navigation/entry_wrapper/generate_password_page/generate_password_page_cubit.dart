import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/sip2_password_generator.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/generate_password_page/password_character_set_type.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/generate_password_page/password_length_type.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  final TextEditingController checksumTextEditingController = TextEditingController();
  final TextEditingController customPasswordLengthTextEditingController = TextEditingController();
  final TextEditingController entropyTextEditingController = TextEditingController();
  final TextEditingController passwordLengthTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  PasswordCharacterSetType passwordCharacterSetType = PasswordCharacterSetType.ascii;
  PasswordLengthType passwordLengthType = PasswordLengthType.excellent;

  final Random _random = Random.secure();

  GeneratePasswordPageCubit() : super(const GeneratePasswordPageState());

  @override
  Future<void> close() async {
    checksumTextEditingController.dispose();
    customPasswordLengthTextEditingController.dispose();
    entropyTextEditingController.dispose();
    passwordLengthTextEditingController.dispose();
    passwordTextEditingController.dispose();

    await super.close();
  }

  Future<void> init() async {
    checksumTextEditingController.text = '';
    customPasswordLengthTextEditingController.text = '20';
    entropyTextEditingController.text = '';
    passwordLengthTextEditingController.text = '';
    passwordTextEditingController.text = '';

    generatePassword();
  }

  void generatePassword() {
    int passwordLength = _getPasswordLength();
    String characterSet = _getCharacterSet();
    int entropyCharacterCount = passwordLength;
    int checksumCharacterCount = 0;
    String password;

    if (passwordCharacterSetType == PasswordCharacterSetType.sip2) {
      Sip2GeneratedPassword generatedPassword = Sip2PasswordGenerator(random: _random).generate(passwordLength);
      password = generatedPassword.password;
      entropyCharacterCount = generatedPassword.randomCharacterCount;
      checksumCharacterCount = generatedPassword.checksumCharacterCount;
    } else {
      password = List<String>.generate(passwordLength, (_) => characterSet[_random.nextInt(characterSet.length)]).join();
    }

    passwordTextEditingController.text = password;
    passwordLengthTextEditingController.text = passwordLength.toString();

    double entropy = entropyCharacterCount * (log(characterSet.length) / ln2);

    entropyTextEditingController.text = entropy.toStringAsFixed(1);
    checksumTextEditingController.text = checksumCharacterCount.toString();
  }

  int _getPasswordLength() {
    switch (passwordLengthType) {
      case PasswordLengthType.good:
        return 18;
      case PasswordLengthType.excellent:
        return 20;
      case PasswordLengthType.superb:
        return 40;
      case PasswordLengthType.custom:
        return int.tryParse(customPasswordLengthTextEditingController.text) ?? 20;
    }
  }

  String _getCharacterSet() {
    switch (passwordCharacterSetType) {
      case PasswordCharacterSetType.ascii:
        return String.fromCharCodes(List<int>.generate(94, (int index) => 33 + index));

      case PasswordCharacterSetType.sip2:
        return Sip2PasswordGenerator.characterSet;
    }
  }
}
