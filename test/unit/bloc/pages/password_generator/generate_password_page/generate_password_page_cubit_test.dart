import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

void main() {
  late GeneratePasswordPageCubit actualGeneratePasswordPageCubit;

  setUp(() {
    actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
  });

  tearDown(() async {
    await actualGeneratePasswordPageCubit.close();
  });

  group('Tests of GeneratePasswordPageCubit initialization', () {
    test('Should [return GeneratePasswordPageState] with [DEFAULT values] as initial state', () {
      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
    });

    for (PasswordCharacterSetMode passwordCharacterSetMode in PasswordCharacterSetMode.values) {
      test('Should [use provided character set mode: ${passwordCharacterSetMode.name}] and [obscurePasswordBool == FALSE]', () async {
        // Arrange
        await actualGeneratePasswordPageCubit.close();

        // Act
        actualGeneratePasswordPageCubit = GeneratePasswordPageCubit(
          passwordCharacterSetMode: passwordCharacterSetMode,
          obscurePasswordBool: false,
        );

        // Assert
        GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
          checksumCharacterCount: 0,
          customPasswordLength: '',
          password: '',
          passwordEntropy: 0,
          randomCharacterCount: 0,
          advancedPasswordCharactersConfig: PasswordCharactersConfig(),
          calculatedPasswordLevelType: PasswordLevelType.excellent,
          passwordCharacterSetMode: passwordCharacterSetMode,
          selectedPasswordLevelType: PasswordLevelType.excellent,
          obscurePasswordBool: false,
        );

        expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      });
    }
  });

  group('Tests of GeneratePasswordPageCubit.init()', () {
    test('Should [generate ASCII password] with [EXCELLENT security level]', () {
      // Act
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[\x21-\x7e]+$')));
      expect(actualGeneratePasswordPageState.passwordEntropy, greaterThanOrEqualTo(128));
      expect(actualGeneratePasswordPageState.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageState.randomCharacterCount, 20);
      expect(actualGeneratePasswordPageState.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageState.selectedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });
  });

  group('Tests of GeneratePasswordPageCubit.generatePassword()', () {
    test('Should [regenerate password] and [preserve settings]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('24')
        ..toggleObscurePassword();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.generatePassword();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      expect(actualGeneratePasswordPageState.password, isNot(expectedGeneratePasswordPageState.password));
      expect(actualGeneratePasswordPageState.password.length, 24);
      expect(
        actualGeneratePasswordPageState,
        expectedGeneratePasswordPageState.copyWith(password: actualGeneratePasswordPageState.password),
      );
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [keep password EMPTY] if [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..selectCustomPasswordLevel()
        ..updateCustomLength('3');
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.generatePassword();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.password, '');
      expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 0);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.unsafe);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
    });
  });

  group('Tests of GeneratePasswordPageCubit.changeCharacterSetMode()', () {
    test('Should [generate SIP2 password] and [restore ASCII mode]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        // Act
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      expect(actualGeneratePasswordPageState.passwordCharacterSetMode, PasswordCharacterSetMode.sip2);
      expect(actualGeneratePasswordPageState.password.length, 24);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[!+\-0-9=@A-HJ-NP-Za-km-z]+$')));
      expect(actualGeneratePasswordPageState.passwordEntropy, 132);
      expect(actualGeneratePasswordPageState.checksumCharacterCount, 2);
      expect(actualGeneratePasswordPageState.randomCharacterCount, 22);
      expect(actualGeneratePasswordPageState.selectedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.ascii);
      actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      expect(actualGeneratePasswordPageState.passwordCharacterSetMode, PasswordCharacterSetMode.ascii);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageState.randomCharacterCount, 20);
      expect(actualGeneratePasswordPageState.selectedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [apply saved advanced settings] when [ADVANCED mode selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..toggleUppercase()
        ..toggleNumbers()
        ..toggleSpecial()
        // Act
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      PasswordCharactersConfig expectedPasswordCharactersConfig = PasswordCharactersConfig(uppercase: false, numbers: false, special: false);

      expect(actualGeneratePasswordPageState.passwordCharacterSetMode, PasswordCharacterSetMode.advanced);
      expect(actualGeneratePasswordPageState.advancedPasswordCharactersConfig, expectedPasswordCharactersConfig);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[a-z]+$')));
      expect(actualGeneratePasswordPageState.password.length, 28);
      expect(actualGeneratePasswordPageState.randomCharacterCount, 28);
      expect(actualGeneratePasswordPageState.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageState.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [preserve custom length] when [character set mode CHANGED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('16')
        ..selectCustomPasswordLevel()
        // Act
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '16');
      expect(actualGeneratePasswordPageCubit.state.password.length, 16);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 1);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 15);
      expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 90);
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.custom);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.weak);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [preserve EMPTY password] when [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state.copyWith(
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
      );

      // Act
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
    });

    test('Should [NOT change state] if [character set mode ALREADY selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.ascii);

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
    });
  });

  group('Tests of GeneratePasswordPageCubit.changePasswordLevelType()', () {
    test('Should [change security level] and [restore EXCELLENT level]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        // Act
        ..changePasswordLevelType(PasswordLevelType.good);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.good);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.good);
      expect(actualGeneratePasswordPageCubit.state.password.length, 18);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.magnificent);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.magnificent);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.magnificent);
      expect(actualGeneratePasswordPageCubit.state.password.length, 40);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.excellent);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualGeneratePasswordPageCubit.state.password.length, 20);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    for (PasswordLevelType passwordLevelType in <PasswordLevelType>[PasswordLevelType.unsafe, PasswordLevelType.weak, PasswordLevelType.excellent]) {
      test('Should [NOT change state] if [security level ${passwordLevelType.name} UNAVAILABLE or ALREADY selected]', () {
        // Arrange
        actualGeneratePasswordPageCubit.init();
        GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

        // Act
        actualGeneratePasswordPageCubit.changePasswordLevelType(passwordLevelType);

        // Assert
        expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
      });
    }
  });

  group('Tests of GeneratePasswordPageCubit.selectCustomPasswordLevel()', () {
    test('Should [clear generated password] if [custom length EMPTY]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state.copyWith(
        selectedPasswordLevelType: PasswordLevelType.custom,
        password: '',
        passwordEntropy: 0,
        checksumCharacterCount: 0,
        randomCharacterCount: 0,
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
      );

      // Act
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
      expect(actualGeneratePasswordPageCubit.state.generationAvailableBool, false);
    });

    test('Should [generate password with saved length] and [restore preset level]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..updateCustomLength('32')
        // Act
        ..selectCustomPasswordLevel();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.custom);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '32');
      expect(actualGeneratePasswordPageCubit.state.password.length, 32);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.good);

      // Assert
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.good);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '32');
      expect(actualGeneratePasswordPageCubit.state.password.length, 18);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.custom);
      expect(actualGeneratePasswordPageCubit.state.password.length, 32);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });
  });

  group('Tests of GeneratePasswordPageCubit.updateCustomLength()', () {
    test('Should [save custom length WITHOUT regenerating password] if [preset level selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state.copyWith(customPasswordLength: '32');

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('32');

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [generate passwords] for [MINIMUM and MAXIMUM custom lengths]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..selectCustomPasswordLevel()
        // Act
        ..updateCustomLength('4');

      // Assert
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '4');
      expect(actualGeneratePasswordPageCubit.state.password.length, 4);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 4);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLengthInvalidBool, false);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('256');

      // Assert
      expect(actualGeneratePasswordPageCubit.state.customPasswordLength, '256');
      expect(actualGeneratePasswordPageCubit.state.password.length, 256);
      expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 256);
      expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 0);
      expect(actualGeneratePasswordPageCubit.state.customPasswordLengthInvalidBool, false);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    for (String customPasswordLength in <String>['', '0', '3', '257', '-4', 'invalid', '4.5']) {
      test('Should [clear password and metadata] if [custom length INVALID: "$customPasswordLength"] and [recover after correction]', () {
        // Arrange
        actualGeneratePasswordPageCubit
          ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
          ..updateCustomLength('24')
          ..selectCustomPasswordLevel();
        GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state.copyWith(
          customPasswordLength: customPasswordLength,
          password: '',
          passwordEntropy: 0,
          checksumCharacterCount: 0,
          randomCharacterCount: 0,
          calculatedPasswordLevelType: PasswordLevelType.unsafe,
        );

        // Act
        actualGeneratePasswordPageCubit.updateCustomLength(customPasswordLength);

        // Assert
        expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
        expect(actualGeneratePasswordPageCubit.state.customPasswordLengthInvalidBool, true);
        expect(actualGeneratePasswordPageCubit.state.generationAvailableBool, false);
        expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);

        // Act
        actualGeneratePasswordPageCubit.updateCustomLength('24');

        // Assert
        expect(actualGeneratePasswordPageCubit.state.password.length, 24);
        expect(actualGeneratePasswordPageCubit.state.passwordEntropy, 132);
        expect(actualGeneratePasswordPageCubit.state.checksumCharacterCount, 2);
        expect(actualGeneratePasswordPageCubit.state.randomCharacterCount, 22);
        expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.excellent);
        expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
      });
    }

    test('Should [NOT change state] if [custom length UNCHANGED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('24');

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
    });

    test('Should [calculate security levels] when [custom length CHANGED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel();
      Map<String, PasswordLevelType> expectedPasswordLevels = <String, PasswordLevelType>{
        '14': PasswordLevelType.unsafe,
        '15': PasswordLevelType.weak,
        '19': PasswordLevelType.weak,
        '20': PasswordLevelType.good,
        '23': PasswordLevelType.good,
        '24': PasswordLevelType.excellent,
        '44': PasswordLevelType.excellent,
        '45': PasswordLevelType.magnificent,
      };

      for (MapEntry<String, PasswordLevelType> expectedPasswordLevel in expectedPasswordLevels.entries) {
        // Act
        actualGeneratePasswordPageCubit.updateCustomLength(expectedPasswordLevel.key);

        // Assert
        expect(actualGeneratePasswordPageCubit.state.selectedPasswordLevelType, PasswordLevelType.custom);
        expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, expectedPasswordLevel.value);
        expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
      }
    });
  });

  group('Tests of GeneratePasswordPageCubit.applyCustomPasswordLevel()', () {
    test('Should [NOT regenerate password] if [preset level selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.applyCustomPasswordLevel();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
    });

    test('Should [NOT regenerate password] if [custom password READY]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.applyCustomPasswordLevel();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [keep password EMPTY] if [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..selectCustomPasswordLevel();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.applyCustomPasswordLevel();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.password, '');
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleLowercase()', () {
    test('Should [disable and restore lowercase] WITHOUT [regenerating ASCII password]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();

      // Assert
      expect(
        actualGeneratePasswordPageCubit.state,
        expectedGeneratePasswordPageState.copyWith(advancedPasswordCharactersConfig: PasswordCharactersConfig(lowercase: false)),
      );

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });

    test('Should [regenerate advanced password] when [lowercase DISABLED and RESTORED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      String expectedPreviousPassword = actualGeneratePasswordPageCubit.state.password;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig(lowercase: false));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(matches(RegExp('[a-z]'))));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(expectedPreviousPassword));
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig());
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [NOT disable lowercase] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleUppercase()
        ..toggleNumbers()
        ..toggleSpecial();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[a-z]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleNumbers()', () {
    test('Should [disable and restore numbers] WITHOUT [regenerating SIP2 password]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();

      // Assert
      expect(
        actualGeneratePasswordPageCubit.state,
        expectedGeneratePasswordPageState.copyWith(advancedPasswordCharactersConfig: PasswordCharactersConfig(numbers: false)),
      );

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });

    test('Should [regenerate advanced password] when [numbers DISABLED and RESTORED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      String expectedPreviousPassword = actualGeneratePasswordPageCubit.state.password;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig(numbers: false));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(matches(RegExp('[0-9]'))));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(expectedPreviousPassword));
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig());
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [NOT disable numbers] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase()
        ..toggleUppercase()
        ..toggleSpecial();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[0-9]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleSpecial()', () {
    test('Should [disable and restore special characters] WITHOUT [regenerating ASCII password]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();

      // Assert
      expect(
        actualGeneratePasswordPageCubit.state,
        expectedGeneratePasswordPageState.copyWith(advancedPasswordCharactersConfig: PasswordCharactersConfig(special: false)),
      );

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });

    test('Should [regenerate advanced password] when [special characters DISABLED and RESTORED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      String expectedPreviousPassword = actualGeneratePasswordPageCubit.state.password;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig(special: false));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[a-zA-Z0-9]+$')));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(expectedPreviousPassword));
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig());
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [NOT disable special characters] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase()
        ..toggleUppercase()
        ..toggleNumbers();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[^a-zA-Z0-9]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleUppercase()', () {
    test('Should [disable and restore uppercase] WITHOUT [regenerating ASCII password]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();

      // Assert
      expect(
        actualGeneratePasswordPageCubit.state,
        expectedGeneratePasswordPageState.copyWith(advancedPasswordCharactersConfig: PasswordCharactersConfig(uppercase: false)),
      );

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });

    test('Should [regenerate advanced password] when [uppercase DISABLED and RESTORED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      String expectedPreviousPassword = actualGeneratePasswordPageCubit.state.password;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig(uppercase: false));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(matches(RegExp('[A-Z]'))));
      expect(actualGeneratePasswordPageCubit.state.password, isNot(expectedPreviousPassword));
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state.advancedPasswordCharactersConfig, PasswordCharactersConfig());
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [NOT disable uppercase] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase()
        ..toggleNumbers()
        ..toggleSpecial();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, same(expectedGeneratePasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[A-Z]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.shouldWarnPassword()', () {
    test('Should [return TRUE] for [UNSAFE and WEAK passwords] and [FALSE] for [GOOD, EXCELLENT and MAGNIFICENT passwords]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        // Act
        ..updateCustomLength('14');

      // Assert
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.unsafe);
      expect(actualWarningBool, true);

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('15');

      // Assert
      actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.weak);
      expect(actualWarningBool, true);

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('20');

      // Assert
      actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.good);
      expect(actualWarningBool, false);

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('24');

      // Assert
      actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualWarningBool, false);

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('45');

      // Assert
      actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();
      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.magnificent);
      expect(actualWarningBool, false);
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleObscurePassword()', () {
    test('Should [reveal and obscure password] WITHOUT [regenerating password]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState expectedGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleObscurePassword();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState.copyWith(obscurePasswordBool: false));

      // Act
      actualGeneratePasswordPageCubit.toggleObscurePassword();

      // Assert
      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });
  });
}
