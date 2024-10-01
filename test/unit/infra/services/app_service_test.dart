import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of AppService.isCustomPasswordSet()', () {
    test('Should [return TRUE] if [master key EXISTS] in database and [encrypted with CUSTOM PASSWORD]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.masterKeyOnlyDatabaseMock);

      // Act
      bool actualPasswordSetBool = await globalLocator<AppService>().isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, true);
    });

    test('Should [return FALSE] if [master key EXISTS] in database and [encrypted with DEFAULT PASSWORD]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.defaultMasterKeyOnlyDatabaseMock);

      // Act
      bool actualPasswordSetBool = await globalLocator<AppService>().isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, false);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      bool actualPasswordSetBool = await globalLocator<AppService>().isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, false);
    });
  });

  group('Tests of AppService.isPasswordValid()', () {
    test('Should [return TRUE] if [master key EXISTS] in database and given [password VALID]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool actualPasswordValidBool = await globalLocator<AppService>().isPasswordValid(PasswordModel.fromPlaintext('1111'));

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [master key EXISTS] in database and given [password INVALID]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool actualPasswordValidBool = await globalLocator<AppService>().isPasswordValid(PasswordModel.fromPlaintext('invalid_password'));

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<AppService>().isPasswordValid(PasswordModel.fromPlaintext('1111')),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of AppService.wipeAll()', () {
    test('Should [wipe application] including removing all data from Isar database, Filesystem storage and Flutter Secure Storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<AppService>().wipeAll();

      Map<String, dynamic> actualFilesystemStructure = testDatabase.readRawFilesystem();
      Map<String, dynamic> actualDatabaseValue = await const FlutterSecureStorage().readAll();
      int actualIsarSize = await globalLocator<IsarDatabaseManager>().perform((Isar isar) => isar.getSize());

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{};
      Map<String, dynamic> expectedDatabaseValue = <String, dynamic>{};
      int expectedIsarSize = 0;

      expect(actualFilesystemStructure, expectedFilesystemStructure);
      expect(actualDatabaseValue, expectedDatabaseValue);
      expect(actualIsarSize, expectedIsarSize);
    });
  });

  tearDownAll(testDatabase.close);
}
