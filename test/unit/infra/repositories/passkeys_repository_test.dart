import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/passkey_entity/passkey_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/passkeys_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  const PasskeyEntity firstPasskey = PasskeyEntity(
    id: 1,
    encryptedBool: false,
    pinnedBool: false,
    rpId: 'example.com',
    rpName: 'Example',
    userName: 'alice',
    userDisplayName: 'Alice',
    userId: <int>[1, 2, 3],
    credentialId: <int>[10, 20, 30],
    algorithm: -7,
    signCount: 0,
    filesystemPathString: 'passkeys/passkey1',
    name: 'EXAMPLE 1',
  );

  const PasskeyEntity secondPasskey = PasskeyEntity(
    id: 2,
    encryptedBool: false,
    pinnedBool: true,
    rpId: 'example.com',
    rpName: 'Example',
    userName: 'bob',
    userDisplayName: 'Bob',
    userId: <int>[4, 5, 6],
    credentialId: <int>[10, 20, 31],
    algorithm: -7,
    signCount: 2,
    filesystemPathString: 'passkeys/group1/passkey2',
    name: 'EXAMPLE 2',
  );

  const PasskeyEntity thirdPasskey = PasskeyEntity(
    id: 3,
    encryptedBool: true,
    pinnedBool: false,
    rpId: 'another.example',
    rpName: 'Another',
    userName: 'carol',
    userDisplayName: 'Carol',
    userId: <int>[7, 8, 9],
    credentialId: <int>[40, 50, 60],
    algorithm: -7,
    signCount: 1,
    filesystemPathString: 'passkeys/group1/passkey3',
    name: 'ANOTHER',
  );

  const List<PasskeyEntity> fullPasskeyList = <PasskeyEntity>[
    firstPasskey,
    secondPasskey,
    thirdPasskey,
  ];

  Future<void> populateDatabase() async {
    await globalLocator<PasskeysRepository>().saveAll(fullPasskeyList);
  }

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
    await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);
  });

  group('Tests of PasskeysRepository.getAll()', () {
    test('Should [return List of PasskeyEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await populateDatabase();

      // Act
      List<PasskeyEntity> actualPasskeyEntityList = await globalLocator<PasskeysRepository>().getAll();

      // Assert
      expect(actualPasskeyEntityList, fullPasskeyList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Act
      List<PasskeyEntity> actualPasskeyEntityList = await globalLocator<PasskeysRepository>().getAll();

      // Assert
      expect(actualPasskeyEntityList, <PasskeyEntity>[]);
    });
  });

  group('Tests of PasskeysRepository.getAllByParentPath()', () {
    test('Should [return List of PasskeyEntity] if [passkeys with specified path NOT EMPTY]', () async {
      // Arrange
      await populateDatabase();

      // Act
      List<PasskeyEntity> actualPasskeyEntityList = await globalLocator<PasskeysRepository>().getAllByParentPath(
        FilesystemPath.fromString('passkeys/group1'),
      );

      // Assert
      expect(actualPasskeyEntityList, <PasskeyEntity>[secondPasskey, thirdPasskey]);
    });

    test('Should [return EMPTY list] if [passkeys with specified path EMPTY]', () async {
      // Arrange
      await populateDatabase();

      // Act
      List<PasskeyEntity> actualPasskeyEntityList = await globalLocator<PasskeysRepository>().getAllByParentPath(
        FilesystemPath.fromString('passkeys/group2'),
      );

      // Assert
      expect(actualPasskeyEntityList, <PasskeyEntity>[]);
    });
  });

  group('Tests of PasskeysRepository.getAllByRpId()', () {
    test('Should [return List of PasskeyEntity] if [RP ID EXISTS] in database', () async {
      // Arrange
      await populateDatabase();

      // Act
      List<PasskeyEntity> actualPasskeyEntityList = await globalLocator<PasskeysRepository>().getAllByRpId('example.com');

      // Assert
      expect(actualPasskeyEntityList, <PasskeyEntity>[firstPasskey, secondPasskey]);
    });

    test('Should [return EMPTY list] if [RP ID NOT EXISTS] in database', () async {
      // Arrange
      await populateDatabase();

      // Act
      List<PasskeyEntity> actualPasskeyEntityList = await globalLocator<PasskeysRepository>().getAllByRpId('missing.example');

      // Assert
      expect(actualPasskeyEntityList, <PasskeyEntity>[]);
    });
  });

  group('Tests of PasskeysRepository.getByCredentialId()', () {
    test('Should [return PasskeyEntity] if [credential ID EXISTS] in database', () async {
      // Arrange
      await populateDatabase();

      // Act
      PasskeyEntity actualPasskeyEntity = await globalLocator<PasskeysRepository>().getByCredentialId(<int>[10, 20, 30]);

      // Assert
      expect(actualPasskeyEntity, firstPasskey);
    });

    test('Should [return correct PasskeyEntity] if [credential IDs differ by one byte]', () async {
      // Arrange
      await populateDatabase();

      // Act
      PasskeyEntity actualPasskeyEntity = await globalLocator<PasskeysRepository>().getByCredentialId(<int>[10, 20, 31]);

      // Assert
      expect(actualPasskeyEntity, secondPasskey);
    });

    test('Should [throw ChildKeyNotFoundException] if [credential ID NOT EXISTS] in database', () async {
      // Arrange
      await populateDatabase();

      // Assert
      expect(
        () => globalLocator<PasskeysRepository>().getByCredentialId(<int>[10, 20, 32]),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of PasskeysRepository.getById()', () {
    test('Should [return PasskeyEntity] if [passkey EXISTS] in database', () async {
      // Arrange
      await populateDatabase();

      // Act
      PasskeyEntity actualPasskeyEntity = await globalLocator<PasskeysRepository>().getById(1);

      // Assert
      expect(actualPasskeyEntity, firstPasskey);
    });

    test('Should [throw ChildKeyNotFoundException] if [passkey NOT EXISTS] in database', () async {
      // Assert
      expect(
        () => globalLocator<PasskeysRepository>().getById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of PasskeysRepository.save()', () {
    test('Should [UPDATE passkey] if [passkey EXISTS] in database', () async {
      // Arrange
      await populateDatabase();
      PasskeyEntity updatedPasskey = firstPasskey.copyWith(name: 'UPDATED PASSKEY', pinnedBool: true, signCount: 3);

      // Act
      await globalLocator<PasskeysRepository>().save(updatedPasskey);
      List<PasskeyEntity> actualPasskeysDatabaseValue = await globalLocator<IsarDatabaseManager>().perform(
        (Isar isar) => isar.passkeys.where().findAll(),
      );

      // Assert
      expect(actualPasskeysDatabaseValue, <PasskeyEntity>[updatedPasskey, secondPasskey, thirdPasskey]);
    });

    test('Should [SAVE passkey] if [passkey NOT EXISTS] in database', () async {
      // Arrange
      await populateDatabase();
      PasskeyEntity newPasskey = firstPasskey.copyWith(
        id: 4,
        credentialId: <int>[70, 80, 90],
        filesystemPathString: 'passkeys/passkey4',
        name: 'NEW PASSKEY',
      );

      // Act
      await globalLocator<PasskeysRepository>().save(newPasskey);
      List<PasskeyEntity> actualPasskeysDatabaseValue = await globalLocator<IsarDatabaseManager>().perform(
        (Isar isar) => isar.passkeys.where().findAll(),
      );

      // Assert
      expect(actualPasskeysDatabaseValue, <PasskeyEntity>[firstPasskey, secondPasskey, thirdPasskey, newPasskey]);
    });
  });

  group('Tests of PasskeysRepository.saveAll()', () {
    test('Should [UPDATE passkeys] if [passkeys EXIST] in database', () async {
      // Arrange
      await populateDatabase();
      PasskeyEntity updatedFirstPasskey = firstPasskey.copyWith(name: 'UPDATED FIRST');
      PasskeyEntity updatedSecondPasskey = secondPasskey.copyWith(name: 'UPDATED SECOND');

      // Act
      await globalLocator<PasskeysRepository>().saveAll(<PasskeyEntity>[updatedFirstPasskey, updatedSecondPasskey]);
      List<PasskeyEntity> actualPasskeysDatabaseValue = await globalLocator<IsarDatabaseManager>().perform(
        (Isar isar) => isar.passkeys.where().findAll(),
      );

      // Assert
      expect(actualPasskeysDatabaseValue, <PasskeyEntity>[updatedFirstPasskey, updatedSecondPasskey, thirdPasskey]);
    });

    test('Should [SAVE passkeys] if [passkeys NOT EXIST] in database', () async {
      // Arrange
      await populateDatabase();
      PasskeyEntity fourthPasskey = firstPasskey.copyWith(
        id: 4,
        credentialId: <int>[70, 80, 90],
        filesystemPathString: 'passkeys/passkey4',
      );
      PasskeyEntity fifthPasskey = secondPasskey.copyWith(
        id: 5,
        credentialId: <int>[70, 80, 91],
        filesystemPathString: 'passkeys/passkey5',
      );

      // Act
      await globalLocator<PasskeysRepository>().saveAll(<PasskeyEntity>[fourthPasskey, fifthPasskey]);
      List<PasskeyEntity> actualPasskeysDatabaseValue = await globalLocator<IsarDatabaseManager>().perform(
        (Isar isar) => isar.passkeys.where().findAll(),
      );

      // Assert
      expect(actualPasskeysDatabaseValue, <PasskeyEntity>[...fullPasskeyList, fourthPasskey, fifthPasskey]);
    });
  });

  group('Tests of PasskeysRepository.deleteById()', () {
    test('Should [REMOVE passkey] if [passkey EXISTS] in database', () async {
      // Arrange
      await populateDatabase();

      // Act
      await globalLocator<PasskeysRepository>().deleteById(1);
      List<PasskeyEntity> actualPasskeysDatabaseValue = await globalLocator<IsarDatabaseManager>().perform(
        (Isar isar) => isar.passkeys.where().findAll(),
      );

      // Assert
      expect(actualPasskeysDatabaseValue, <PasskeyEntity>[secondPasskey, thirdPasskey]);
    });

    test('Should [throw ChildKeyNotFoundException] if [passkey NOT EXISTS] in database', () async {
      // Assert
      expect(
        () => globalLocator<PasskeysRepository>().deleteById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(testDatabase.close);
}
