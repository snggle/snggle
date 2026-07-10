import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_database.dart';

void main() {
  TestDatabase testDatabase = TestDatabase();
  late MasterKeyController actualMasterKeyController;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
    encryptedMasterKey:
        '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  );

  setUpAll(() async {
    await testDatabase.init(appPasswordModel: actualAppPasswordModel);
  });

  setUp(() {
    actualMasterKeyController = MasterKeyController();
    testDatabase.updateSecureStorage(<String, String>{
      SecureStorageKey.encryptedMasterKey.name: actualMasterKeyVO.encryptedMasterKey,
    });
  });

  group('Tests of MasterKeyController.encrypt()', () {
    test('Should [throw Exception] if [password NOT SET]', () async {
      // Arrange
      String actualValueToEncrypt = 'some_value';

      // Assert
      await expectLater(actualMasterKeyController.encrypt(actualValueToEncrypt), throwsException);
    });

    test('Should [throw FormatException] if [plaintext EMPTY]', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualValueToEncrypt = '';

      // Assert
      await expectLater(actualMasterKeyController.encrypt(actualValueToEncrypt), throwsFormatException);
    });

    test('Should [return ciphertext] encrypted by master key', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualValueToEncrypt = 'some_value';

      // Act
      String actualEncryptedValue = await actualMasterKeyController.encrypt(actualValueToEncrypt);

      // Assert
      String actualDecryptedValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedValue,
      );
      String expectedDecryptedValue = actualValueToEncrypt;

      expect(actualDecryptedValue, expectedDecryptedValue);
    });
  });

  group('Tests of MasterKeyController.clearPassword()', () {
    test('Should [throw Exception when encrypting] if [password CLEARED]', () async {
      // Arrange
      actualMasterKeyController
        ..setPassword(actualAppPasswordModel)
        // Act
        ..clearPassword();

      // Assert
      await expectLater(actualMasterKeyController.encrypt('some_value'), throwsException);
    });

    test('Should [throw Exception when decrypting] if [password CLEARED]', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualEncryptedValue = await actualMasterKeyController.encrypt('some_value');

      // Act
      actualMasterKeyController.clearPassword();

      // Assert
      await expectLater(actualMasterKeyController.decrypt(actualEncryptedValue), throwsException);
    });

    test('Should [throw Exception when changing password] if [password CLEARED]', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      PasswordModel actualNewPasswordModel = PasswordModel.fromPlaintext('2222');

      // Act
      actualMasterKeyController.clearPassword();

      // Assert
      await expectLater(actualMasterKeyController.changePassword(actualNewPasswordModel), throwsException);
      MasterKeyVO actualStoredMasterKeyVO = await MasterKeyService().getMasterKey();
      expect(actualStoredMasterKeyVO.encryptedMasterKey, actualMasterKeyVO.encryptedMasterKey);
    });

    test('Should [encrypt and decrypt] if [password SET AGAIN after clearing]', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String expectedDecryptedValue = 'some_value';
      String actualEncryptedValue = await actualMasterKeyController.encrypt(expectedDecryptedValue);
      actualMasterKeyController
        ..clearPassword()
        // Act
        ..setPassword(actualAppPasswordModel);

      // Assert
      String actualDecryptedValue = await actualMasterKeyController.decrypt(actualEncryptedValue);
      expect(actualDecryptedValue, expectedDecryptedValue);

      String actualNewEncryptedValue = await actualMasterKeyController.encrypt(expectedDecryptedValue);
      String actualNewDecryptedValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualNewEncryptedValue,
      );
      expect(actualNewDecryptedValue, expectedDecryptedValue);
    });
  });

  group('Tests of MasterKeyController.decrypt()', () {
    test('Should [throw Exception] if [password NOT SET]', () async {
      // Arrange
      String actualValueToDecrypt = 'ehxqO3FuQmNrrq1yr6afo0GlyewjxLrcC0EioYJ/wGPy19KJ';

      // Assert
      await expectLater(actualMasterKeyController.decrypt(actualValueToDecrypt), throwsException);
    });

    test('Should [throw FormatException] if [encrypted value EMPTY]', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualValueToDecrypt = '';

      // Assert
      await expectLater(actualMasterKeyController.decrypt(actualValueToDecrypt), throwsFormatException);
    });

    test('Should [return plaintext] decrypted using master key', () async {
      // Arrange
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualValueToDecrypt = 'ehxqO3FuQmNrrq1yr6afo0GlyewjxLrcC0EioYJ/wGPy19KJ';

      // Act
      String actualDecryptedValue = await actualMasterKeyController.decrypt(actualValueToDecrypt);

      // Assert
      String expectedDecryptedValue = 'some_value';

      expect(actualDecryptedValue, expectedDecryptedValue);
    });
  });

  group('Tests of MasterKeyController.changePassword()', () {
    test('Should [encrypt and decrypt existing data] if [password CHANGED]', () async {
      // Arrange
      PasswordModel actualNewPasswordModel = PasswordModel.fromPlaintext('2222');
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String expectedDecryptedValue = 'another_value';
      String actualEncryptedValue = await actualMasterKeyController.encrypt(expectedDecryptedValue);

      // Act
      await actualMasterKeyController.changePassword(actualNewPasswordModel);

      // Assert
      String actualDecryptedValue = await actualMasterKeyController.decrypt(actualEncryptedValue);
      expect(actualDecryptedValue, expectedDecryptedValue);

      MasterKeyVO actualStoredMasterKeyVO = await MasterKeyService().getMasterKey();
      String actualNewEncryptedValue = await actualMasterKeyController.encrypt(expectedDecryptedValue);
      String actualNewDecryptedValue = actualStoredMasterKeyVO.decrypt(
        appPasswordModel: actualNewPasswordModel,
        encryptedData: actualNewEncryptedValue,
      );
      expect(actualNewDecryptedValue, expectedDecryptedValue);
    });

    test('Should [throw Exception] if [password NOT SET]', () async {
      // Arrange
      PasswordModel actualNewPasswordModel = PasswordModel.fromPlaintext('2222');

      // Assert
      await expectLater(actualMasterKeyController.changePassword(actualNewPasswordModel), throwsException);
    });
  });

  test('Should [throw Exception when decrypting] if [password CLEARED]', () async {
    // Arrange
    actualMasterKeyController.setPassword(actualAppPasswordModel);
    String actualEncryptedValue = await actualMasterKeyController.encrypt('some_value');

    // Act
    actualMasterKeyController.clearPassword();

    // Assert
    await expectLater(actualMasterKeyController.decrypt(actualEncryptedValue), throwsException);
  });

  test('Should [throw Exception when changing password] if [password CLEARED]', () async {
    // Arrange
    actualMasterKeyController.setPassword(actualAppPasswordModel);
    PasswordModel actualNewPasswordModel = PasswordModel.fromPlaintext('2222');

    // Act
    actualMasterKeyController.clearPassword();

    // Assert
    await expectLater(actualMasterKeyController.changePassword(actualNewPasswordModel), throwsException);
  });

  tearDownAll(testDatabase.close);
}
