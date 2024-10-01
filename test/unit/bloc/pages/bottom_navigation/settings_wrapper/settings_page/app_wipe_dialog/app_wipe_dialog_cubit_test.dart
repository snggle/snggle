import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/app_wipe_dialog/app_wipe_dialog_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/app_wipe_dialog/app_wipe_dialog_state.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../../../../utils/database_mock.dart';
import '../../../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late AppWipeDialogCubit actualAppWipeDialogCubit;

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.transactionsDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

    actualAppWipeDialogCubit = AppWipeDialogCubit(applicationWipedCallback: () {});
  });

  group('Tests of AppWipeDialogCubit process', () {
    test('Should [emit AppWipeDialogState] with [confirmationsCount == 0] as initial state', () async {
      // Act
      AppWipeDialogState actualAppWipeDialogState = actualAppWipeDialogCubit.state;

      // Assert
      AppWipeDialogState expectedAppWipeDialogState = const AppWipeDialogState(confirmationsCount: 0);

      expect(actualAppWipeDialogState, expectedAppWipeDialogState);
    });

    test('Should [emit AppWipeDialogState] with [confirmationsCount == 1]', () async {
      // Act
      await actualAppWipeDialogCubit.confirm();
      AppWipeDialogState actualAppWipeDialogState = actualAppWipeDialogCubit.state;

      // Assert
      AppWipeDialogState expectedAppWipeDialogState = const AppWipeDialogState(confirmationsCount: 1);

      expect(actualAppWipeDialogState, expectedAppWipeDialogState);
    });

    test('Should [emit AppWipeDialogState] with [confirmationsCount == 2]', () async {
      // Act
      await actualAppWipeDialogCubit.confirm();
      AppWipeDialogState actualAppWipeDialogState = actualAppWipeDialogCubit.state;

      // Assert
      AppWipeDialogState expectedAppWipeDialogState = const AppWipeDialogState(confirmationsCount: 2);

      expect(actualAppWipeDialogState, expectedAppWipeDialogState);
    });

    test('Should [emit AppWipeDialogState] with [confirmationsCount == 3]', () async {
      // Act
      await actualAppWipeDialogCubit.confirm();
      AppWipeDialogState actualAppWipeDialogState = actualAppWipeDialogCubit.state;

      // Assert
      AppWipeDialogState expectedAppWipeDialogState = const AppWipeDialogState(confirmationsCount: 3);

      expect(actualAppWipeDialogState, expectedAppWipeDialogState);
    });

    test('Should [emit AppWipeDialogState] with [confirmationsCount == 3], [wipeInProgressBool == TRUE] and wipe application', () async {
      // Act
      await actualAppWipeDialogCubit.confirm();
      AppWipeDialogState actualAppWipeDialogState = actualAppWipeDialogCubit.state;

      Map<String, dynamic> actualFilesystemStructure = testDatabase.readRawFilesystem();
      Map<String, dynamic> actualDatabaseValue = await const FlutterSecureStorage().readAll();

      // Assert
      AppWipeDialogState expectedAppWipeDialogState = const AppWipeDialogState(confirmationsCount: 3, wipeInProgressBool: true);

      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{};
      Map<String, dynamic> expectedDatabaseValue = <String, dynamic>{};

      expect(actualAppWipeDialogState, expectedAppWipeDialogState);

      expect(actualFilesystemStructure, expectedFilesystemStructure);
      expect(actualDatabaseValue, expectedDatabaseValue);
    });
  });

  tearDownAll(testDatabase.close);
}
