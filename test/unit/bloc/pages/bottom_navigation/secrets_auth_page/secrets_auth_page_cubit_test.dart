import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/secrets_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
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

  late SecretsAuthPageCubit actualSecretsAuthPageCubit;
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

  group('Tests of [SecretsAuthPageCubit] process when [pin CORRECT]', () {
    setUpAll(() {
      actualSecretsAuthPageCubit = SecretsAuthPageCubit(
        listItemModel: TestListItem(
          uuid: '92b43ace-5439-4269-8e27-e999907f4379',
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (PasswordModel passwordModel) => actualPasswordModel = passwordModel,
      );
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = SecretsAuthPageEnterPinState.empty();

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [FILLED pinNumbers]', () async {
      // Act
      actualSecretsAuthPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = const SecretsAuthPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [return PasswordModel] if provided [password VALID]', () async {
      // Act
      await actualSecretsAuthPageCubit.authenticate();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of [SecretsAuthPageCubit] when [pin INCORRECT]', () {
    setUpAll(() {
      actualSecretsAuthPageCubit = SecretsAuthPageCubit(
        listItemModel: TestListItem(
          uuid: '92b43ace-5439-4269-8e27-e999907f4379',
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (PasswordModel passwordModel) => actualPasswordModel = passwordModel,
      );
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = SecretsAuthPageEnterPinState.empty();

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [FILLED pinNumbers]', () async {
      // Act
      actualSecretsAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = const SecretsAuthPageEnterPinState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [emit SecretsAuthPageInvalidPinState] if provided [password INVALID]', () async {
      // Act
      await actualSecretsAuthPageCubit.authenticate();

      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = const SecretsAuthPageInvalidPinState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}

class TestListItem extends AListItemModel {
  TestListItem({
    required super.uuid,
    required super.encryptedBool,
    required super.pinnedBool,
  }) : super(filesystemPath: FilesystemPath.fromString(uuid));

  @override
  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool}) {
    return TestListItem(
      uuid: uuid,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
    );
  }

  @override
  String get name => 'Test List Item';
}
