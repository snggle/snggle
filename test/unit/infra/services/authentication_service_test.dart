import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/database_manager.dart';
import 'package:snuggle/infra/services/authentication_service.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  AuthenticationService authenticationService = AuthenticationService();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of AuthenticationService.setupPrivateKey()', () {
    test('Should return value for [privateKey] database key', () async {
      // Act
      String? actualEncryptedPrivateKey = await flutterSecureStorage.read(key: DatabaseEntryKey.privateKey.name);

      // Assert
      TestUtils.printInfo('Should return null, [privateKey] does not exist before it is setup up');
      expect(actualEncryptedPrivateKey, isNull);

      // ************************************************************************************************
      
      // Arrange
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString('brave pair belt judge visual tunnel dinner siren dentist craft effort decrease');
      String actualPin = '0000';
      
      // Act
      await authenticationService.setupPrivateKey(mnemonicModel: actualMnemonicModel, pin: actualPin);
      actualEncryptedPrivateKey = await flutterSecureStorage.read(key: DatabaseEntryKey.privateKey.name);
      
      // Encrypted [privateKey] is always random String because AES256 method changes initialization vector using Random Secure
      // For this reason we cannot match the hardcoded expected result, so we just check if we can decrypt actual encrypted [privateKey]
      String actualDecryptedPrivateKey = Aes256.decrypt(actualPin, actualEncryptedPrivateKey!);
      
      // Assert
      String expectedDecryptedPrivateKey = '0be7db2c1b9449601eaf078d9a215ec94b159326ae7bb164dc3747a8101b9439';
      
      TestUtils.printInfo('Should return decrypted [privateKey]');
      expect(actualDecryptedPrivateKey, expectedDecryptedPrivateKey);
    });
  });
}
