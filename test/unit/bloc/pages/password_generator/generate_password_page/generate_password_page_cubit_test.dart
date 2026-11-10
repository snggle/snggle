import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

void main() {
  late GeneratePasswordPageCubit actualGeneratePasswordPageCubit;

  setUp(() {
    actualGeneratePasswordPageCubit = GeneratePasswordPageCubit()..init();
  });

  tearDown(() async {
    await actualGeneratePasswordPageCubit.close();
  });

  test('Generates passwords when changing modes and restoring defaults', () {
    int expectedLength = 20;
    expect(actualGeneratePasswordPageCubit.state.password.length, expectedLength);
    expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, expectedLength);
    expect(actualGeneratePasswordPageCubit.state.passwordReadyBool, true);

    actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);
    expectedLength = 24;
    expect(actualGeneratePasswordPageCubit.state.password.length, expectedLength);
    expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 2);
    expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 132);

    actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.ascii);
    expectedLength = 20;
    expect(actualGeneratePasswordPageCubit.state.password.length, expectedLength);
    expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
    expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.excellent);
  });

  test('Applies and removes custom lengths, including invalid input', () {
    actualGeneratePasswordPageCubit.selectCustomPasswordLevel();
    expect(actualGeneratePasswordPageCubit.state.passwordReadyBool, false);
    expect(actualGeneratePasswordPageCubit.state.password, '');

    for (String customPasswordLength in <String>['4', '256', '3', '257', 'invalid', '', '-4']) {
      actualGeneratePasswordPageCubit.updateCustomLength(customPasswordLength);
      bool expectedReadyBool = <String>['4', '256'].contains(customPasswordLength);
      bool actualReadyBool = actualGeneratePasswordPageCubit.state.passwordReadyBool;
      expect(actualReadyBool, expectedReadyBool);
      int expectedLength = expectedReadyBool ? int.parse(customPasswordLength) : 0;
      expect(actualGeneratePasswordPageCubit.state.password.length, expectedLength);
      bool invalidLengthBool = expectedReadyBool == false;
      if (invalidLengthBool) {
        expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 0);
        expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
        expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 0);
      }
    }

    actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.good);
    expect(actualGeneratePasswordPageCubit.state.passwordReadyBool, true);
    expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.good);
  });

  test('Preserves at least one advanced character category and restores settings', () {
    actualGeneratePasswordPageCubit
      ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
      ..toggleUppercase()
      ..toggleNumbers()
      ..toggleSpecial();

    bool expectedLowercaseBool = true;
    expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig.lowercase, expectedLowercaseBool);
    expect(RegExp(r'^[a-z]+$').hasMatch(actualGeneratePasswordPageCubit.state.password), true);

    String expectedPassword = actualGeneratePasswordPageCubit.state.password;
    actualGeneratePasswordPageCubit.toggleLowercase();
    expect(actualGeneratePasswordPageCubit.state.password, expectedPassword);
    expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig.lowercase, expectedLowercaseBool);

    actualGeneratePasswordPageCubit
      ..toggleUppercase()
      ..toggleNumbers()
      ..toggleSpecial();
    expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig.uppercase, true);
    expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig.numbers, true);
    expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig.special, true);
    expect(actualGeneratePasswordPageCubit.state.passwordReadyBool, true);
  });

  test('Rejects unavailable security levels without changing the password', () {
    String expectedPassword = actualGeneratePasswordPageCubit.state.password;
    for (PasswordLevelType passwordLevelType in <PasswordLevelType>[PasswordLevelType.unsafe, PasswordLevelType.weak]) {
      actualGeneratePasswordPageCubit.changePasswordLevelType(passwordLevelType);
      String actualPassword = actualGeneratePasswordPageCubit.state.password;
      expect(actualPassword, expectedPassword);
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.excellent);
    }
  });

  test('Updates the warning and visibility when settings change', () {
    actualGeneratePasswordPageCubit
      ..selectCustomPasswordLevel()
      ..updateCustomLength('4');
    expect(actualGeneratePasswordPageCubit.shouldWarnPassword(), true);
    actualGeneratePasswordPageCubit.updateCustomLength('40');
    expect(actualGeneratePasswordPageCubit.shouldWarnPassword(), false);

    actualGeneratePasswordPageCubit.toggleObscurePassword();
    expect(actualGeneratePasswordPageCubit.state.obscurePasswordBool, false);
    actualGeneratePasswordPageCubit.toggleObscurePassword();
    expect(actualGeneratePasswordPageCubit.state.obscurePasswordBool, true);
  });
}
