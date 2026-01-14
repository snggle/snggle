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

  setUpAll(() async {
    PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
    await testDatabase.init(appPasswordModel: actualPasswordModel);
    await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
  });

  group('Test of PasswordController.getPasswordByFilesystemPath() method', () {
    // navigated to Vault1
    test('Should [return default PasswordModel] if the [FilesystemPath EXISTS] in PasswordController and [has DEFAULT password]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1');
      globalLocator<PasswordController>().addPassword(PasswordModel.defaultPassword(), actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.defaultPassword();

      expect(actualPasswordModel, expectedPasswordModel);
    });

    // navigated to Network1
    test('Should [return PasswordModel] if [all PasswordModels EXIST] in PasswordController and [has NOT ENCRYPTED parents]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1/network1');
      globalLocator<PasswordController>().addPassword(PasswordModel.fromPlaintext('1111'), actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });

    // navigated back from Network1
    test('Should [return default PasswordModel] if [PasswordModel NOT EXISTS] in PasswordController and [has NOT ENCRYPTED parents]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1/network1');
      globalLocator<PasswordController>().removeByFilesystemPath(actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.defaultPassword();

      expect(actualPasswordModel, expectedPasswordModel);
    });

    // navigated back from Vault1
    test('Should [return default PasswordModel] if [PasswordModel NOT EXISTS] in PasswordController and [has DEFAULT password]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1');
      globalLocator<PasswordController>().removeByFilesystemPath(actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.defaultPassword();

      expect(actualPasswordModel, expectedPasswordModel);
    });

    // set password on Vault1
    test('Should [throw Exception] if [PasswordModel NOT EXISTS] in PasswordController and [has CUSTOM password]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1');
      await globalLocator<SecretsService>().changePassword(actualFilesystemPath, PasswordModel.defaultPassword(), PasswordModel.fromPlaintext('1111'));

      expect(
        () => globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath),
        throwsA(isA<Exception>()),
      );
    });

    test('Should [throw Exception] if [all PasswordModel NOT EXISTS] in PasswordController and [has parents with CUSTOM password]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1/network1');

      expect(
        () => globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath),
        throwsA(isA<Exception>()),
      );
    });

    // navigated to Vault1 again
    test('Should [return default PasswordModel] if the [FilesystemPath EXISTS] in PasswordController and [has CUSTOM password]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1');
      globalLocator<PasswordController>().addPassword(PasswordModel.fromPlaintext('1111'), actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });

    // navigated to Network1 again
    test('Should [return PasswordModel] if [all PasswordModels EXIST] in PasswordController and [has ENCRYPTED parents]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vaults/vault1/network1');
      globalLocator<PasswordController>().addPassword(PasswordModel.fromPlaintext('1111'), actualFilesystemPath);

      // Act
      PasswordModel actualPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(actualFilesystemPath);

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });
  });
}
