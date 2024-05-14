import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

void main() {
  initLocator();

  // @formatter:off
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:off

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
  });

  group('Tests of MasterKeyController.encrypt()', () {
    MasterKeyController actualMasterKeyController = MasterKeyController();

    test('Should [throw Exception] if [password NOT SET]', () {
      // Arrange
      String actualValueToEncrypt = '';

      // Assert
      expect(() async => actualMasterKeyController.encrypt(actualValueToEncrypt), throwsException);
    });

    test('Should [throw FormatException] if [decrypted value EMPTY]', () {
      // Arrange
      // Since [masterKeyPasswordModel] is a private variable, the only way to verify if it works correctly, is to repeat two tests: with and without password
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualValueToEncrypt = '';

      // Assert
      expect(() async => actualMasterKeyController.encrypt(actualValueToEncrypt), throwsFormatException);
    });

    test('Should [return ciphertext] encrypted by master key', () async {
      // Arrange
      String actualValueToEncrypt = 'some_value';

      // Act
      String actualEncryptedValue = await actualMasterKeyController.encrypt(actualValueToEncrypt);

      // Master key encryption always returns random value. For that reason, we can't assert the result.
      // To check uf encryption works correctly, we need to decrypt the value.
      String actualDecryptedValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedValue);

      // Assert
      String expectedDecryptedValue = actualValueToEncrypt;

      expect(actualDecryptedValue, expectedDecryptedValue);
    });
  });

  group('Tests of MasterKeyController.decrypt()', () {
    MasterKeyController actualMasterKeyController = MasterKeyController();

    test('Should [throw Exception] if [password NOT SET]', () {
      // Arrange
      String actualValueToDecrypt = '';

      // Assert
      expect(() async => actualMasterKeyController.encrypt(actualValueToDecrypt), throwsException);
    });

    test('Should [throw FormatException] if [encrypted value EMPTY]', () {
      // Arrange
      // Since [masterKeyPasswordModel] is a private variable, the only way to verify if it works correctly, is to repeat two tests: with and without password
      actualMasterKeyController.setPassword(actualAppPasswordModel);
      String actualValueToDecrypt = '';

      // Assert
      expect(() async => actualMasterKeyController.decrypt(actualValueToDecrypt), throwsFormatException);
    });

    test('Should [return plaintext] decrypted using master key', () async {
      // Arrange
      String actualValueToDecrypt = 'ehxqO3FuQmNrrq1yr6afo0GlyewjxLrcC0EioYJ/wGPy19KJ';

      // Act
      String actualDecryptedValue = await actualMasterKeyController.decrypt(actualValueToDecrypt);

      // Assert
      String expectedDecryptedValue = 'some_value';

      expect(actualDecryptedValue, expectedDecryptedValue);
    });
  });
}