import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vault1');
  PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

  setUp(() async {
    await testDatabase.init(appPasswordModel: actualPasswordModel);
  });

  group('Test of PasswordController.getByListItemModel() method', () {
    test('Should [return PasswordModel] if the [FilesystemPath EXISTS] in PasswordController', () async {
      // Arrange
      globalLocator<PasswordController>().addPassword(PasswordModel.defaultPassword(), actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      expect(actualPasswordModel, PasswordModel.defaultPassword());
    });

    test('Should [throw Exception] if the [FilesystemPath NOT EXISTS] in PasswordController', () {
      // Arrange
      FilesystemPath actualMissingFilesystemPath = FilesystemPath.fromString('vault2');

      // Assert
      expect(
        () => globalLocator<PasswordController>().getPasswordByFilesystemPath(actualMissingFilesystemPath),
        throwsA(isA<Exception>()),
      );
    });

    test('Should [throw Exception] if the [FilesystemPath NOT EXISTS] in PasswordController', () {
      // Arrange
      globalLocator<PasswordController>().removeByFilesystemPath(actualFilesystemPath);

      // Assert
      expect(
        () => globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Test of PasswordController.checkIfUnlocked() method', () {
    test('Should [return TRUE] if the given FilesystemPath does not have encrypted parents', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      FilesystemPath actualWalletFilesystemPath = FilesystemPath.fromString('vault1/network1/wallet1');
      bool actualPathUnlockedBool = await globalLocator<PasswordController>().checkIfUnlocked(actualWalletFilesystemPath);

      // Assert
      expect(actualPathUnlockedBool, true);
    });

    test('Should [return FALSE] if the given FilesystemPath does have encrypted parents', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      await globalLocator<SecretsService>().changePassword(FilesystemPath.fromString('vault1'), PasswordModel.defaultPassword(), actualPasswordModel);

      // Act
      FilesystemPath actualWalletFilesystemPath = FilesystemPath.fromString('vault1/network1/wallet1');
      bool actualPathUnlockedBool = await globalLocator<PasswordController>().checkIfUnlocked(actualWalletFilesystemPath);

      // Assert
      expect(actualPathUnlockedBool, false);
    });

    test('Should [return TRUE] if the given FilesystemPath does have encrypted parents, but password was entered', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      await globalLocator<SecretsService>().changePassword(FilesystemPath.fromString('vault1'), PasswordModel.defaultPassword(), actualPasswordModel);
      globalLocator<PasswordController>().addPassword(actualPasswordModel, actualFilesystemPath);

      // Act
      FilesystemPath actualWalletFilesystemPath = FilesystemPath.fromString('vault1/network1/wallet1');
      bool actualPathUnlockedBool = await globalLocator<PasswordController>().checkIfUnlocked(actualWalletFilesystemPath);

      // Assert
      expect(actualPathUnlockedBool, true);
    });

    test('Should [return FALSE] if the given FilesystemPath does have encrypted parents, but ', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      await globalLocator<SecretsService>().changePassword(FilesystemPath.fromString('vault1'), PasswordModel.defaultPassword(), actualPasswordModel);
      globalLocator<PasswordController>().removeByFilesystemPath(actualFilesystemPath);

      // Act
      FilesystemPath actualWalletFilesystemPath = FilesystemPath.fromString('vault1/network1/wallet1');
      bool actualPathUnlockedBool = await globalLocator<PasswordController>().checkIfUnlocked(actualWalletFilesystemPath);

      // Assert
      expect(actualPathUnlockedBool, false);
    });
  });
}
