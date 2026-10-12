import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_level_type.dart';

void main() {
  late GeneratePasswordPageCubit actualGeneratePasswordPageCubit;

  group('Tests of GeneratePasswordPageCubit initialization', () {
    setUpAll(() async {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [generate PASSWORD] with default settings on initialization', () {
      // Act
      actualGeneratePasswordPageCubit.init();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.characterSetType, CharacterSetType.ascii);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '');
      expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 131.09177703355275);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.passwordLevelTypeList, <PasswordLevelType>[
        PasswordLevelType.good,
        PasswordLevelType.excellent,
        PasswordLevelType.magnificent,
      ]);
    });
  });

  group('Tests of GeneratePasswordPageCubit.changeCharacterSet()', () {
    setUpAll(() async {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
      await actualGeneratePasswordPageCubit.init();
    });

    test('Should [emit GeneratePasswordPageState] with default [ASCII] settings when switching to [CharacterSetType.ascii]', () async {
      // Act
      actualGeneratePasswordPageCubit.changeCharacterSet(CharacterSetType.ascii);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.characterSetType, CharacterSetType.ascii);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '');
      expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 131.09177703355275);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 20);
      expect(actualGeneratePasswordPageCubit.state.passwordLevelTypeList, <PasswordLevelType>[
        PasswordLevelType.good,
        PasswordLevelType.excellent,
        PasswordLevelType.magnificent,
        PasswordLevelType.custom,
      ]);
    });

    test('Should [emit GeneratePasswordPageState] with default [SIP-2] settings when switching to [CharacterSetType.sip2]', () async {
      // Act
      actualGeneratePasswordPageCubit.changeCharacterSet(CharacterSetType.sip2);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.characterSetType, CharacterSetType.sip2);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.good);
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.good);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '');
      expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 114.0);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 1);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 19);
      expect(actualGeneratePasswordPageCubit.state.passwordLevelTypeList, <PasswordLevelType>[
        PasswordLevelType.good,
        PasswordLevelType.custom,
      ]);
    });
  });

  group('Tests of GeneratePasswordPageCubit.changePasswordLevelType()', () {
    setUpAll(() async {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
      await actualGeneratePasswordPageCubit.init();
    });

    test('Should [emit GeneratePasswordPageState] with default [ASCII] settings when switching to [CharacterSetType.ascii]', () async {
      //
    });
  });
}
