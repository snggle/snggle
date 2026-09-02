import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

void main() {
  late GeneratePasswordPageCubit actualGeneratePasswordPageCubit;

  tearDown(() async {
    await actualGeneratePasswordPageCubit.close();
  });

  group('Tests of GeneratePasswordPageCubit initialization', () {
    test('Should [return default state] if [Cubit initialized without arguments]', () {
      // Act
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();

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

    test('Should [use provided settings] if [character set ASCII and visibility provided]', () {
      // Act
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit(
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
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
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: false,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });

    test('Should [use provided settings] if [character set SIP2 and visibility provided]', () {
      // Act
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit(
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
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
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: false,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });

    test('Should [use provided settings] if [character set ADVANCED and visibility provided]', () {
      // Act
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit(
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
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
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: false,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
    });
  });

  group('Tests of GeneratePasswordPageCubit.init()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [generate EXCELLENT ASCII password] if [default settings used]', () {
      // Act
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[\x21-\x7e]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.generatePassword()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [regenerate password and preserve settings] if [custom SIP2 password configured]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('24')
        ..toggleObscurePassword();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.generatePassword();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '24',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 132,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: false,
      );

      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
      expect(actualGeneratePasswordPageState.password.length, 24);
      expect(
        actualGeneratePasswordPageState,
        expectedGeneratePasswordPageState,
      );
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [keep password EMPTY] if [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..selectCustomPasswordLevel()
        ..updateCustomLength('3');

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.generatePassword();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '3',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

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
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [generate SIP2 password] if [SIP2 character set selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 132,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 24);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[!+\-0-9=@A-HJ-NP-Za-km-z]+$')));
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [generate ASCII password] if [ASCII character set selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.ascii);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[\x21-\x7e]+$')));
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [apply saved advanced settings] if [ADVANCED mode selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..toggleUppercase()
        ..toggleNumbers()
        ..toggleSpecial();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.6123121079506,
        randomCharacterCount: 28,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(uppercase: false, numbers: false, special: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 28);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[a-z]+$')));
    });

    test('Should [preserve custom length] if [character set mode CHANGED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('16')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 1,
        customPasswordLength: '16',
        password: actualGeneratePasswordPageCubit.state.password,
        passwordEntropy: 90,
        randomCharacterCount: 15,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.weak,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.password.length, 16);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [preserve EMPTY password] if [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
    });

    test('Should [NOT change state] if [character set mode ALREADY selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.ascii);

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
    });
  });

  group('Tests of GeneratePasswordPageCubit.changePasswordLevelType()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [select GOOD level] if [GOOD preset selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.good);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 117.98259933019747,
        randomCharacterCount: 18,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.good,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.good,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 18);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [select MAGNIFICENT level] if [MAGNIFICENT preset selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.magnificent);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 262.1835540671055,
        randomCharacterCount: 40,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.magnificent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.magnificent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 40);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [select EXCELLENT level] if [GOOD level currently selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.good);

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.excellent);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [retain saved custom length] if [GOOD preset selected after CUSTOM level]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.good);
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '32',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 117.98259933019747,
        randomCharacterCount: 18,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.good,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.good,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 18);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [NOT change state] if [security level UNSAFE UNAVAILABLE]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.unsafe);

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
    });

    test('Should [NOT change state] if [security level WEAK UNAVAILABLE]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.weak);

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
    });

    test('Should [NOT change state] if [security level EXCELLENT ALREADY selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.changePasswordLevelType(PasswordLevelType.excellent);

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
    });
  });

  group('Tests of GeneratePasswordPageCubit.selectCustomPasswordLevel()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [clear generated password] if [custom length EMPTY]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
      expect(actualGeneratePasswordPageCubit.state.generationAvailableBool, false);
    });

    test('Should [generate password with saved length] if [CUSTOM level selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..updateCustomLength('32');

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '32',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 209.7468432536844,
        randomCharacterCount: 32,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 32);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });
  });

  group('Tests of GeneratePasswordPageCubit.updateCustomLength()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [save custom length WITHOUT regenerating password] if [preset level selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('32');

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '32',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [generate password] if [custom length at MINIMUM boundary]', () {
      // Arrange
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('4');
      GeneratePasswordPageState actualMinimumLengthPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '4',
        password: actualMinimumLengthPasswordPageState.password,
        passwordEntropy: 26.21835540671055,
        randomCharacterCount: 4,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualMinimumLengthPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualMinimumLengthPasswordPageState.password.length, 4);
      expect(actualMinimumLengthPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [generate password] if [custom length at MAXIMUM boundary]', () {
      // Arrange
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('256');
      GeneratePasswordPageState actualMaximumLengthPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '256',
        password: actualMaximumLengthPasswordPageState.password,
        passwordEntropy: 1677.9747460294752,
        randomCharacterCount: 256,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.magnificent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualMaximumLengthPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualMaximumLengthPasswordPageState.password.length, 256);
      expect(actualMaximumLengthPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [clear password and metadata] if [custom length EMPTY]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [clear password and metadata] if [custom length ZERO]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('0');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '0',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [clear password and metadata] if [custom length BELOW MINIMUM]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('3');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '3',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [clear password and metadata] if [custom length ABOVE MAXIMUM]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('257');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '257',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [clear password and metadata] if [custom length NEGATIVE]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('-4');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '-4',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [clear password and metadata] if [custom length NONNUMERIC]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('invalid');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: 'invalid',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [clear password and metadata] if [custom length FRACTIONAL]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('4.5');
      GeneratePasswordPageState actualInvalidPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '4.5',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualInvalidPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualInvalidPasswordPageState.customPasswordLengthInvalidBool, true);
      expect(actualInvalidPasswordPageState.generationAvailableBool, false);
      expect(actualInvalidPasswordPageState.passwordUpdatedBool, false);
    });

    test('Should [generate password] if [invalid custom length corrected]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('3');

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('24');
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '24',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 132,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 24);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [NOT change state] if [custom length UNCHANGED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.updateCustomLength('24');

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '24',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 157.31013244026332,
        randomCharacterCount: 24,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
    });

    test('Should [calculate UNSAFE level] if [custom SIP2 length changed to 14]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('14');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 1,
        customPasswordLength: '14',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 78,
        randomCharacterCount: 13,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 14);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate WEAK level] if [custom SIP2 length changed to 15]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('15');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 1,
        customPasswordLength: '15',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 84,
        randomCharacterCount: 14,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.weak,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 15);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate WEAK level] if [custom SIP2 length changed to 19]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('19');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 1,
        customPasswordLength: '19',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 108,
        randomCharacterCount: 18,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.weak,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 19);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate GOOD level] if [custom SIP2 length changed to 20]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('20');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 1,
        customPasswordLength: '20',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 114,
        randomCharacterCount: 19,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.good,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 20);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate GOOD level] if [custom SIP2 length changed to 23]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('23');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '23',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 126,
        randomCharacterCount: 21,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.good,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 23);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate EXCELLENT level] if [custom SIP2 length changed to 24]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('24');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '24',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 132,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 24);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate EXCELLENT level] if [custom SIP2 length changed to 44]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('44');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '44',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 252,
        randomCharacterCount: 42,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 44);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });

    test('Should [calculate MAGNIFICENT level] if [custom SIP2 length changed to 45]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..updateCustomLength('32')
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.updateCustomLength('45');
      GeneratePasswordPageState actualChangedPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '45',
        password: actualChangedPasswordPageState.password,
        passwordEntropy: 258,
        randomCharacterCount: 43,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.magnificent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualChangedPasswordPageState, expectedGeneratePasswordPageState);
      expect(actualChangedPasswordPageState.password.length, 45);
      expect(actualChangedPasswordPageState.passwordUpdatedBool, true);
    });
  });

  group('Tests of GeneratePasswordPageCubit.applyCustomPasswordLevel()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [NOT regenerate password] if [preset level selected]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.applyCustomPasswordLevel();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
    });

    test('Should [NOT regenerate password] if [custom password READY]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..updateCustomLength('24')
        ..selectCustomPasswordLevel();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.applyCustomPasswordLevel();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '24',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 157.31013244026332,
        randomCharacterCount: 24,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, true);
    });

    test('Should [keep password EMPTY] if [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..selectCustomPasswordLevel();

      // Act
      // ignore: cascade_invocations
      actualGeneratePasswordPageCubit.applyCustomPasswordLevel();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: '',
        passwordEntropy: 0,
        randomCharacterCount: 0,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.unsafe,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.custom,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state.password, '');
      expect(actualGeneratePasswordPageCubit.state.passwordUpdatedBool, false);
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleLowercase()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [disable lowercase without regenerating password] if [ASCII mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(lowercase: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [enable lowercase without regenerating password] if [ASCII mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..toggleLowercase();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [disable lowercase and regenerate password] if [ADVANCED mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 133.92418250750748,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(lowercase: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 22);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
      expect(actualGeneratePasswordPageState.password, isNot(matches(RegExp('[a-z]'))));
    });

    test('Should [enable lowercase and regenerate password] if [ADVANCED mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
    });

    test('Should [NOT disable lowercase] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleUppercase()
        ..toggleNumbers()
        ..toggleSpecial();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleLowercase();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.6123121079506,
        randomCharacterCount: 28,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(uppercase: false, numbers: false, special: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[a-z]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleNumbers()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [disable numbers without regenerating password] if [SIP2 mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.sip2);
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 132,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(numbers: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [enable numbers without regenerating password] if [SIP2 mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..toggleNumbers();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 2,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 132,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.sip2,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [disable numbers and regenerate password] if [ADVANCED mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 134.23866587835397,
        randomCharacterCount: 21,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(numbers: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 21);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
      expect(actualGeneratePasswordPageState.password, isNot(matches(RegExp('[0-9]'))));
    });

    test('Should [enable numbers and regenerate password] if [ADVANCED mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleNumbers();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
    });

    test('Should [NOT disable numbers] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase()
        ..toggleUppercase()
        ..toggleSpecial();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleNumbers();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 129.55519570060713,
        randomCharacterCount: 39,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(lowercase: false, uppercase: false, special: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[0-9]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleSpecial()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [disable special without regenerating password] if [ASCII mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(special: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [enable special without regenerating password] if [ASCII mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..toggleSpecial();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [disable special and regenerate password] if [ADVANCED mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 130.99231882851126,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(special: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 22);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
      expect(actualGeneratePasswordPageState.password, matches(RegExp(r'^[a-zA-Z0-9]+$')));
    });

    test('Should [enable special and regenerate password] if [ADVANCED mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleSpecial();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
    });

    test('Should [NOT disable special characters] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase()
        ..toggleUppercase()
        ..toggleNumbers();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleSpecial();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 130,
        randomCharacterCount: 26,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(lowercase: false, uppercase: false, numbers: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[^a-zA-Z0-9]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleUppercase()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [disable uppercase without regenerating password] if [ASCII mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(uppercase: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [enable uppercase without regenerating password] if [ASCII mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..toggleUppercase();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [disable uppercase and regenerate password] if [ADVANCED mode and category ENABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.changeCharacterSetMode(PasswordCharacterSetMode.advanced);
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 133.92418250750748,
        randomCharacterCount: 22,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(uppercase: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 22);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
      expect(actualGeneratePasswordPageState.password, isNot(matches(RegExp('[A-Z]'))));
    });

    test('Should [enable uppercase and regenerate password] if [ADVANCED mode and category DISABLED]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleUppercase();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualGeneratePasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageState.password.length, 20);
      expect(actualGeneratePasswordPageState.passwordUpdatedBool, true);
      expect(actualGeneratePasswordPageState.password, isNot(actualPreviousPasswordPageState.password));
    });

    test('Should [NOT disable uppercase] if [LAST enabled category]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.advanced)
        ..toggleLowercase()
        ..toggleNumbers()
        ..toggleSpecial();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleUppercase();

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.6123121079506,
        randomCharacterCount: 28,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(lowercase: false, numbers: false, special: false),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.advanced,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageCubit.state, expectedGeneratePasswordPageState);
      expect(actualGeneratePasswordPageCubit.state, same(actualPreviousPasswordPageState));
      expect(actualGeneratePasswordPageCubit.state.password, matches(RegExp(r'^[A-Z]+$')));
    });
  });

  group('Tests of GeneratePasswordPageCubit.shouldWarnPassword()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [return TRUE] if [password security level UNSAFE]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('14');

      // Act
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();

      // Assert
      bool expectedWarningBool = true;

      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.unsafe);
      expect(actualWarningBool, expectedWarningBool);
    });

    test('Should [return TRUE] if [password security level WEAK]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('15');

      // Act
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();

      // Assert
      bool expectedWarningBool = true;

      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.weak);
      expect(actualWarningBool, expectedWarningBool);
    });

    test('Should [return FALSE] if [password security level GOOD]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('20');

      // Act
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();

      // Assert
      bool expectedWarningBool = false;

      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.good);
      expect(actualWarningBool, expectedWarningBool);
    });

    test('Should [return FALSE] if [password security level EXCELLENT]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('24');

      // Act
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();

      // Assert
      bool expectedWarningBool = false;

      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.excellent);
      expect(actualWarningBool, expectedWarningBool);
    });

    test('Should [return FALSE] if [password security level MAGNIFICENT]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..changeCharacterSetMode(PasswordCharacterSetMode.sip2)
        ..selectCustomPasswordLevel()
        ..updateCustomLength('45');

      // Act
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();

      // Assert
      bool expectedWarningBool = false;

      expect(actualGeneratePasswordPageCubit.state.calculatedPasswordLevelType, PasswordLevelType.magnificent);
      expect(actualWarningBool, expectedWarningBool);
    });

    test('Should [return TRUE] if [custom length INVALID]', () {
      // Arrange
      actualGeneratePasswordPageCubit.selectCustomPasswordLevel();

      // Act
      bool actualWarningBool = actualGeneratePasswordPageCubit.shouldWarnPassword();

      // Assert
      bool expectedWarningBool = true;

      expect(actualWarningBool, expectedWarningBool);
    });
  });

  group('Tests of GeneratePasswordPageCubit.toggleObscurePassword()', () {
    setUp(() {
      actualGeneratePasswordPageCubit = GeneratePasswordPageCubit();
    });

    test('Should [reveal password without regeneration] if [password OBSCURED]', () {
      // Arrange
      actualGeneratePasswordPageCubit.init();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleObscurePassword();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: false,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });

    test('Should [obscure password without regeneration] if [password VISIBLE]', () {
      // Arrange
      actualGeneratePasswordPageCubit
        ..init()
        ..toggleObscurePassword();
      GeneratePasswordPageState actualPreviousPasswordPageState = actualGeneratePasswordPageCubit.state;

      // Act
      actualGeneratePasswordPageCubit.toggleObscurePassword();
      GeneratePasswordPageState actualGeneratePasswordPageState = actualGeneratePasswordPageCubit.state;

      // Assert
      GeneratePasswordPageState expectedGeneratePasswordPageState = GeneratePasswordPageState(
        checksumCharacterCount: 0,
        customPasswordLength: '',
        password: actualPreviousPasswordPageState.password,
        passwordEntropy: 131.09177703355275,
        randomCharacterCount: 20,
        advancedPasswordCharactersConfig: PasswordCharactersConfig(),
        calculatedPasswordLevelType: PasswordLevelType.excellent,
        passwordCharacterSetMode: PasswordCharacterSetMode.ascii,
        selectedPasswordLevelType: PasswordLevelType.excellent,
        obscurePasswordBool: true,
      );

      expect(actualGeneratePasswordPageState, expectedGeneratePasswordPageState);
    });
  });
}
