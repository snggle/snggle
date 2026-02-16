import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_master_key_recover_page/app_master_key_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/app_master_key_recover_page/app_master_key_recover_page_state.dart';

Future<void> main() async {
  const List<String> validMnemonicList = <String>[
    'abandon', 'abandon', 'abandon', 'abandon', 'abandon', //
    'abandon', 'abandon', 'abandon', 'abandon', 'abandon',
    'abandon', 'about',
  ];

  const List<String> invalidMnemonicList = <String>[
    'abandon', 'abandon', 'abandon', 'abandon', 'abandon', //
    'abandon', 'abandon', 'abandon', 'abandon', 'abandon',
    'abandon', 'invalidword',
  ];

  group('Tests of [AppMasterKeyRecoverPageCubit]', () {
    group('Tests of [AppMasterKeyRecoverPageCubit] when [CREATED]', () {
      late AppMasterKeyRecoverPageCubit appMasterKeyRecoverPageCubit;

      setUpAll(() async {
        appMasterKeyRecoverPageCubit = AppMasterKeyRecoverPageCubit();
      });

      tearDownAll(() async {
        await appMasterKeyRecoverPageCubit.close();
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [DEFAULT values] as initial state', () async {
        // Assert
        const AppMasterKeyRecoverPageState expectedState = AppMasterKeyRecoverPageState();

        expect(appMasterKeyRecoverPageCubit.state, expectedState);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [UNINITIALIZED textControllers] as initial state', () async {
        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList, isEmpty);
      });
    });

    group('Tests of [AppMasterKeyRecoverPageCubit] when [MNEMONIC SIZE 12]', () {
      late AppMasterKeyRecoverPageCubit appMasterKeyRecoverPageCubit;

      setUpAll(() async {
        appMasterKeyRecoverPageCubit = AppMasterKeyRecoverPageCubit();
      });

      setUp(() async {
        await appMasterKeyRecoverPageCubit.init(12);
      });

      tearDownAll(() async {
        await appMasterKeyRecoverPageCubit.close();
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicSize: 12]', () async {
        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList.length, 12);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [NOT NULL textControllers]', () async {
        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList, isNotNull);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [12 textControllers]', () async {
        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList.length, 12);
      });
    });

    group('Tests of [AppMasterKeyRecoverPageCubit] when [RE-INITIALIZED]', () {
      late AppMasterKeyRecoverPageCubit appMasterKeyRecoverPageCubit;

      setUpAll(() async {
        appMasterKeyRecoverPageCubit = AppMasterKeyRecoverPageCubit();
      });

      tearDownAll(() async {
        await appMasterKeyRecoverPageCubit.close();
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicSize: 24] after re-init', () async {
        // Arrange
        await appMasterKeyRecoverPageCubit.init(12);

        // Act
        await appMasterKeyRecoverPageCubit.init(24);

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList.length, 24);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [NEW textControllers instance] after re-init', () async {
        // Arrange
        await appMasterKeyRecoverPageCubit.init(12);
        List<TextEditingController> oldControllers = appMasterKeyRecoverPageCubit.state.textControllersList;

        // Act
        await appMasterKeyRecoverPageCubit.init(24);

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList, isNot(same(oldControllers)));
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [24 textControllers] after re-init', () async {
        // Arrange
        await appMasterKeyRecoverPageCubit.init(12);

        // Act
        await appMasterKeyRecoverPageCubit.init(24);

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.textControllersList.length, 24);
      });
    });

    group('Tests of [AppMasterKeyRecoverPageCubit] when [MNEMONIC VALIDATION]', () {
      late AppMasterKeyRecoverPageCubit appMasterKeyRecoverPageCubit;

      setUpAll(() async {
        appMasterKeyRecoverPageCubit = AppMasterKeyRecoverPageCubit();
      });

      setUp(() async {
        await appMasterKeyRecoverPageCubit.init(12);
      });

      tearDownAll(() async {
        await appMasterKeyRecoverPageCubit.close();
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicFilledBool: FALSE] if any word is empty', () async {
        // Act
        appMasterKeyRecoverPageCubit.state.textControllersList[0].text = 'abandon';

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicFilledBool, isFalse);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicValidBool: FALSE] if not all words are filled', () async {
        // Act
        appMasterKeyRecoverPageCubit.state.textControllersList[0].text = 'abandon';

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicValidBool, isFalse);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicFilledBool: TRUE] for [VALID mnemonic]', () async {
        // Act
        for (int i = 0; i < 12; i++) {
          appMasterKeyRecoverPageCubit.state.textControllersList[i].text = validMnemonicList[i];
        }

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicFilledBool, isTrue);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicValidBool: TRUE] for [VALID mnemonic]', () async {
        // Act
        for (int i = 0; i < 12; i++) {
          appMasterKeyRecoverPageCubit.state.textControllersList[i].text = validMnemonicList[i];
        }

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicValidBool, isTrue);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicFilledBool: TRUE] for [INVALID mnemonic] (all fields filled)', () async {
        // Act
        for (int i = 0; i < 12; i++) {
          appMasterKeyRecoverPageCubit.state.textControllersList[i].text = invalidMnemonicList[i];
        }

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicFilledBool, isTrue);
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [mnemonicValidBool: FALSE] for [INVALID mnemonic]', () async {
        // Act
        for (int i = 0; i < 12; i++) {
          appMasterKeyRecoverPageCubit.state.textControllersList[i].text = invalidMnemonicList[i];
        }

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicValidBool, isFalse);
      });
    });

    group('Tests of [AppMasterKeyRecoverPageCubit] saveMnemonic()', () {
      late AppMasterKeyRecoverPageCubit appMasterKeyRecoverPageCubit;

      setUpAll(() async {
        appMasterKeyRecoverPageCubit = AppMasterKeyRecoverPageCubit();
      });

      tearDownAll(() async {
        await appMasterKeyRecoverPageCubit.close();
      });

      test('Should [emit AppMasterKeyRecoverPageState] with [MnemonicModel] for [VALID mnemonic]', () async {
        // Arrange
        await appMasterKeyRecoverPageCubit.init(12);

        for (int i = 0; i < 12; i++) {
          appMasterKeyRecoverPageCubit.state.textControllersList[i].text = validMnemonicList[i];
        }

        // Act
        await appMasterKeyRecoverPageCubit.saveMnemonic();

        // Assert
        expect(appMasterKeyRecoverPageCubit.state.mnemonicFilledBool, isTrue);
        expect(appMasterKeyRecoverPageCubit.state.mnemonicValidBool, isTrue);
      });
    });
  });
}
