import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_master_key_removed_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_app_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

Future<void> main() async {
  final TestDatabase testDatabase = TestDatabase();
  late SplashPageCubit actualSplashPageCubit;

  group('Test of SplashPageCubit.init() when [SECURE STORAGE NOT INITIALIZED]', () {
    setUpAll(() async {
      await globalLocator.reset(dispose: true);

      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSplashPageCubit = SplashPageCubit();
    });

    test('Should [emit SplashPageLoadingState] as initial state', () async {
      // Assert
      ASplashPageState expectedSplashPageState = SplashPageLoadingState();

      expect(actualSplashPageCubit.state, expectedSplashPageState);
    });

    test('Should [emit SplashPageErrorState] when [SECURE STORAGE NOT INITIALIZED]', () async {
      // Act
      await actualSplashPageCubit.init();

      // Assert
      ASplashPageState expectedSplashPageState = SplashPageErrorState();

      expect(actualSplashPageCubit.state, expectedSplashPageState);
    });

    tearDownAll(() async {
      await actualSplashPageCubit.close();
      await testDatabase.close();
    });
  });

  group('Test of SplashPageCubit.init() when [INITIAL LAUNCH]', () {
    setUpAll(() async {
      await globalLocator.reset(dispose: true);

      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      FlutterSecureStorage.setMockInitialValues(<String, String>{});

      actualSplashPageCubit = SplashPageCubit();
    });

    test('Should [emit SplashPageSetupPinState] when [Database and MasterKey do not exists]', () async {
      // Act
      await actualSplashPageCubit.init();

      // Assert
      ASplashPageState expectedSplashPageState = SplashPageSetupAppState();

      expect(actualSplashPageCubit.state, expectedSplashPageState);
    });

    tearDownAll(() async {
      await actualSplashPageCubit.close();
      await testDatabase.close();
    });
  });

  group('Test of SplashPageCubit.init() when [database exists and MasterKey removed]', () {
    setUpAll(() async {
      // Arrange
      await globalLocator.reset(dispose: true);

      FlutterSecureStorage.setMockInitialValues(<String, String>{});

      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      await const FlutterSecureStorage().delete(
        key: SecureStorageKey.encryptedMasterKey.name,
      );

      actualSplashPageCubit = SplashPageCubit();
    });

    test('Should [emit SplashPageMasterKeyRemovedState] when [database exists and MasterKey removed]', () async {
      // Act
      await actualSplashPageCubit.init();

      // Assert
      ASplashPageState expectedSplashPageState = SplashPageMasterKeyRemovedState();

      expect(actualSplashPageCubit.state, expectedSplashPageState);
    });

    tearDownAll(() async {
      await actualSplashPageCubit.close();
      await testDatabase.close();
    });
  });

  group('Test of SplashPageCubit.init() when [MasterKey and dataBase exists]', () {
    setUpAll(() async {
      // Arrange
      await globalLocator.reset(dispose: true);

      FlutterSecureStorage.setMockInitialValues(<String, String>{});

      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      );

      actualSplashPageCubit = SplashPageCubit();
    });

    test('Should [emit SplashPageEnterPinState] when [MasterKey and dataBase exists]', () async {
      // Act
      await actualSplashPageCubit.init();

      // Assert
      ASplashPageState expectedSplashPageState = SplashPageEnterPinState();

      expect(actualSplashPageCubit.state, expectedSplashPageState);
    });

    tearDownAll(() async {
      await actualSplashPageCubit.close();
      await testDatabase.close();
    });
  });
}
