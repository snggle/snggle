import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/secrets_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../utils/test_utils.dart';

Future<void> main() async {
  String testSessionUUID = const Uuid().v4();

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');

  // @formatter:off
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'trIhhcjCFuRe6bYP/8O8sHQVDg9a5X4O7Jc4zGEh/zVPxPqhh1VKAxwuOsluzW7+DmNBKpl5oHQm9qGjOXqTEC5o/ByjNAAotxKjCiK0XRfCcejg',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'ZI4URXu2x6DJHccD2W3er/EcW2NbGVEcJvp9haKjMpjONXqF34UX1C6gDZKmEYnZRZzep4Kxwc2ZbXnOnCJ7RN4Vt/ROgmpLI+O83N1Y1hMhV2EC',
      '438791a4-b537-4589-af4f-f56b6449a0bb.snggle': 'vjOKvL7uwX1SammTmlYtx4QxyAsmsby2spiiKyGcI0DnVdHrlhpdLCrQxHlx6rTDCe0KP0yNp0cEbCbn3/v2+JEAaxLTkY4NmuZwK9UvIESJne26',
    },
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  late SecretsSetupPinPageCubit actualSecretsSetupPinPageCubit;
  PasswordModel? actualPasswordModel;

  setUpAll(() {
    globalLocator.allowReassignment = true;
    initLocator();

    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

    globalLocator.registerLazySingleton(() => actualSecretsRepository);
    globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);
  });

  group('Tests of a successful password setting process', () {
    setUpAll(() {
      actualSecretsSetupPinPageCubit = SecretsSetupPinPageCubit(passwordValidCallback: (PasswordModel passwordModel) => actualPasswordModel = passwordModel);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [FILLED firstPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.setupFirstPin();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[1, 1, 1, 1],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [return PasswordModel] if [passwords EQUAL]', () async {
      // Act
      await actualSecretsSetupPinPageCubit.setupConfirmPin();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of a password setting process with wrong confirm password provided', () {
    setUpAll(() {
      actualSecretsSetupPinPageCubit = SecretsSetupPinPageCubit(passwordValidCallback: (PasswordModel passwordModel) => actualPasswordModel = passwordModel);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [FILLED firstPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.setupFirstPin();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[9, 9, 9, 9],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageInvalidPinState] if [passwords NOT EQUAL]', () async {
      // Act
      await actualSecretsSetupPinPageCubit.setupConfirmPin();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageInvalidPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[9, 9, 9, 9],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] after resetting', () async {
      // Act
      actualSecretsSetupPinPageCubit.resetAllPins();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}
