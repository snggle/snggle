import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

// ignore_for_file: avoid_dynamic_calls
void main() {
  final TestDatabase testDatabase = TestDatabase();

  // @formatter:off
  String encryptedSecrets1 = '3bqZheymtcYvUbKASR55Y2kxoD9iXYznIUTjpYxALM820UqAUAQvirWIk1sSTsXBoIX+qQzmrNgLvPkE8rYdnFrRnjl2py9Lql+Xw0NB5PTwPjBsdU+IwZAoPszHmWp/vddUwStzRfq6rFMkCCX8zJ46vm4=';
  String encryptedSecrets2 = 'OvNnlxduUz14vtjPlu+PYIwkItJSJ7TVpXGeCkwa84ZgeXGaoKLunDk39zNKeDLUD2W4Lz5ii5bARxPoIfYXF4j7eTqCWLqCNYdl64ooearXVU6KU5JLF0m9QtEsgwCKZ/uJJsgcXNlvQq4cTuOmbnNuiqs=';
  String encryptedSecrets3 = '9Kw28uVK7Hbvdh+58TPzfpDeApW3c91CMdZSMms24eV9S1TAmpobfoCboj/Tv9B+sLKj63ApHycABXM4YiyNXw+PG6PhlxfzMe6bV10XK5fQZh/3OD3Dx+QmijVFWce62WjeVkLVgKUNbd5dcawef7M9KME=';
  String encryptedSecrets4 = 'YSSiNeFbvtX6afWMus5YwDuHDcKZLQYM00sdkV5y90m/VpmMSqHTNVXIj6CR1sE906vigo17wyjp9tQq7yA9KnAvqL43GzwhMcUkGiUFvuMs0WPHgVLpBHrLF2Ej3HhkZmFAiv5Dny71DTM+oCzO3uk3P8s=';
  // @formatter:on

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.testSecretsMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of SecretsService.changePassword()', () {
    test('Should [UPDATE secrets password] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Act
      await globalLocator<SecretsService>().changePassword(
        FilesystemPath.fromString('id1'),
        PasswordModel.defaultPassword(),
        PasswordModel.fromPlaintext('1111'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      actualUpdatedFilesystemStructure['id1.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id1.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id1']['id2.snggle'] = PasswordModel.defaultPassword().decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id1']['id2.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id3.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id3.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id3']['id4.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id3']['id4.snggle'] as String,
      );

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': '{"mnemonic":"million transfer income satoshi save cross indoor text skirt share enough admit"}',
        'id1.snggle': '{"mnemonic":"siren toward skate busy kit behave antenna hazard attract demand earth fence"}',
        'id3': <String, String>{'id4.snggle': '{"mnemonic":"option pave flower ball mask burst hard cycle trigger dwarf apple pause"}'},
        'id1': <String, String>{'id2.snggle': '{"mnemonic":"nature crack detail sustain ready burden require people toilet hazard verb chunk"}'}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw InvalidPasswordException] if [secrets path EXISTS] in filesystem storage and [password INVALID]', () async {
      // Assert
      expect(
        () => globalLocator<SecretsService>().changePassword(
          FilesystemPath.fromString('id1'),
          PasswordModel.fromPlaintext('invalid_password'),
          PasswordModel.defaultPassword(),
        ),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in filesystem storage', () async {
      // Assert
      expect(
        () => globalLocator<SecretsService>().changePassword(
          FilesystemPath.fromString('invalid_path'),
          PasswordModel.fromPlaintext('1111'),
          PasswordModel.defaultPassword(),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.get()', () {
    test('Should [return ASecretsModel] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Arrange
      FilesystemPath filesystemPath = FilesystemPath.fromString('id1');

      // Act
      ASecretsModel actualSecretsModel = await globalLocator<SecretsService>().get<VaultSecretsModel>(
        filesystemPath,
        PasswordModel.defaultPassword(),
      );

      // Assert
      ASecretsModel expectedSecretsModel = VaultSecretsModel(
        filesystemPath: filesystemPath,
        mnemonicModel: MnemonicModel.fromString('siren toward skate busy kit behave antenna hazard attract demand earth fence'),
      );

      expect(actualSecretsModel, expectedSecretsModel);
    });

    test('Should [throw InvalidPasswordException] if [secrets path EXIST] in filesystem storage and [password INVALID]', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1');

      // Assert
      expect(
        () => globalLocator<SecretsService>().get(actualFilesystemPath, PasswordModel.fromPlaintext('invalid_password')),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsService>().get(actualFilesystemPath, PasswordModel.fromPlaintext('1111')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.hasEncryptedParent()', () {
    test('Should [return TRUE] if [secrets path has ENCRYPTED parents]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id3/id4');

      // Act
      bool encryptedParentExistsBool = await globalLocator<SecretsService>().hasEncryptedParent(actualFilesystemPath);

      // Assert
      expect(encryptedParentExistsBool, true);
    });

    test('Should [return FALSE] if [secrets path has DECRYPTED parents]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/id2');

      // Act
      bool encryptedParentExistsBool = await globalLocator<SecretsService>().hasEncryptedParent(actualFilesystemPath);

      // Assert
      expect(encryptedParentExistsBool, false);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsService>().get(actualFilesystemPath, PasswordModel.fromPlaintext('1111')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.save()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in collection', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('id1'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      await globalLocator<SecretsService>().save(actualUpdatedSecretsModel, PasswordModel.defaultPassword());

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      actualUpdatedFilesystemStructure['id1.snggle'] = PasswordModel.defaultPassword().decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id1.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id1']['id2.snggle'] = PasswordModel.defaultPassword().decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id1']['id2.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id3.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id3.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id3']['id4.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id3']['id4.snggle'] as String,
      );

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': '{"mnemonic":"million transfer income satoshi save cross indoor text skirt share enough admit"}',
        'id1.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
        'id3': <String, String>{'id4.snggle': '{"mnemonic":"option pave flower ball mask burst hard cycle trigger dwarf apple pause"}'},
        'id1': <String, String>{'id2.snggle': '{"mnemonic":"nature crack detail sustain ready burden require people toilet hazard verb chunk"}'}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXISTS] in collection', () async {
      // Arrange
      ASecretsModel actualNewSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('id99999'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      await globalLocator<SecretsService>().save(actualNewSecretsModel, PasswordModel.fromPlaintext('1111'));

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      actualUpdatedFilesystemStructure['id1.snggle'] = PasswordModel.defaultPassword().decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id1.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id1']['id2.snggle'] = PasswordModel.defaultPassword().decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id1']['id2.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id3.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id3.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id3']['id4.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id3']['id4.snggle'] as String,
      );

      actualUpdatedFilesystemStructure['id99999.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['id99999.snggle'] as String,
      );

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': '{"mnemonic":"million transfer income satoshi save cross indoor text skirt share enough admit"}',
        'id1.snggle': '{"mnemonic":"siren toward skate busy kit behave antenna hazard attract demand earth fence"}',
        'id3': <String, String>{'id4.snggle': '{"mnemonic":"option pave flower ball mask burst hard cycle trigger dwarf apple pause"}'},
        'id99999.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
        'id1': <String, String>{'id2.snggle': '{"mnemonic":"nature crack detail sustain ready burden require people toilet hazard verb chunk"}'}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });
  });

  group('Tests of SecretsService.move()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in filesystem storage', () async {
      // Act
      await globalLocator<SecretsService>().move(FilesystemPath.fromString('id1'), FilesystemPath.fromString('new/path/id1'));

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'new': <String, Map<String, String>>{
          'path': <String, String>{'id1.snggle': encryptedSecrets1}
        },
        'id3.snggle': encryptedSecrets3,
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id1': <String, String>{'id2.snggle': encryptedSecrets2}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Assert
      expect(
        () => globalLocator<SecretsService>().move(
          FilesystemPath.fromString('not_existing_path'),
          FilesystemPath.fromString('new/path/not_existing_path'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.delete()', () {
    test('Should [REMOVE secrets] if [secrets path EXISTS] in filesystem storage', () async {
      // Act
      await globalLocator<SecretsService>().delete(FilesystemPath.fromString('id1'));

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedSecrets3,
        'id3': <String, String>{
          'id4.snggle': encryptedSecrets4,
        },
        'id1': <String, String>{
          'id2.snggle': encryptedSecrets2,
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsService>().delete(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.isPasswordValid()', () {
    test('Should [return TRUE] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1');

      // Act
      bool actualPasswordValidBool = await globalLocator<SecretsService>().isPasswordValid(
        actualFilesystemPath,
        PasswordModel.defaultPassword(),
      );

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [secrets path EXISTS] in filesystem storage and [password INVALID]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1');

      // Act
      bool actualPasswordValidBool = await globalLocator<SecretsService>().isPasswordValid(
        actualFilesystemPath,
        PasswordModel.fromPlaintext('invalid_password'),
      );

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in collection', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsService>().isPasswordValid(actualFilesystemPath, PasswordModel.fromPlaintext('1111')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
