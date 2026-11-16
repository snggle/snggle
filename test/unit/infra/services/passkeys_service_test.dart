import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/passkey_entity/passkey_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/repositories/passkeys_repository.dart';
import 'package:snggle/infra/services/passkeys_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  const List<PasskeyEntity> passkeys = <PasskeyEntity>[
    PasskeyEntity(
      id: 1,
      encryptedBool: false,
      pinnedBool: false,
      rpId: 'example.com',
      rpName: 'Example',
      userName: 'alice',
      userDisplayName: 'Alice',
      userId: <int>[1],
      credentialId: <int>[11],
      algorithm: -7,
      signCount: 0,
      filesystemPathString: 'passkeys/passkey1',
      name: 'EXAMPLE 1',
    ),
    PasskeyEntity(
      id: 2,
      encryptedBool: false,
      pinnedBool: true,
      rpId: 'example.com',
      rpName: 'Example',
      userName: 'bob',
      userDisplayName: 'Bob',
      userId: <int>[2],
      credentialId: <int>[22],
      algorithm: -7,
      signCount: 2,
      filesystemPathString: 'passkeys/group1/passkey2',
      name: 'EXAMPLE 2',
    ),
    PasskeyEntity(
      id: 3,
      encryptedBool: true,
      pinnedBool: false,
      rpId: 'other.example',
      rpName: 'Other',
      userName: 'carol',
      userDisplayName: 'Carol',
      userId: <int>[3],
      credentialId: <int>[33],
      algorithm: -7,
      signCount: 0,
      filesystemPathString: 'passkeys/group1/subgroup/passkey3',
      name: 'OTHER',
    ),
  ];

  Future<void> seedPasskeys({bool withSecrets = false}) async {
    await globalLocator<PasskeysRepository>().saveAll(passkeys);
    if (withSecrets) {
      for (PasskeyEntity entity in passkeys) {
        await globalLocator<SecretsService>().save(
          PasskeySecretsModel(
            filesystemPath: entity.filesystemPath,
            privateKey: Uint8List.fromList(<int>[entity.id, 0, 255]),
          ),
          PasswordModel.defaultPassword(),
        );
      }
    }
  }

  Future<void> expectSecretAt(FilesystemPath path, int id) async {
    PasskeySecretsModel secret = await globalLocator<SecretsService>().get<PasskeySecretsModel>(
      path,
      PasswordModel.defaultPassword(),
    );
    expect(secret.privateKey, <int>[id, 0, 255]);
  }

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of PasskeysService.getAllByParentPath()', () {
    test('Should [return direct children] if [firstLevelBool TRUE]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      List<PasskeyModel> actualPasskeyModels = await globalLocator<PasskeysService>().getAllByParentPath(
        FilesystemPath.fromString('passkeys/group1'),
        firstLevelBool: true,
      );

      // Assert
      expect(actualPasskeyModels.map((PasskeyModel model) => model.id).toList(), <int>[2]);
    });

    test('Should [return all descendants] if [firstLevelBool FALSE]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      List<PasskeyModel> actualPasskeyModels = await globalLocator<PasskeysService>().getAllByParentPath(
        FilesystemPath.fromString('passkeys/group1'),
      );

      // Assert
      expect(actualPasskeyModels.map((PasskeyModel model) => model.id).toSet(), <int>{2, 3});
    });

    test('Should [return EMPTY list] if [given path has NO passkeys]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      List<PasskeyModel> actualPasskeyModels = await globalLocator<PasskeysService>().getAllByParentPath(
        FilesystemPath.fromString('passkeys/missing'),
      );

      // Assert
      expect(actualPasskeyModels, <PasskeyModel>[]);
    });
  });

  group('Tests of PasskeysService.getAllByRpId()', () {
    test('Should [return matching PasskeyModel list] if [RP ID EXISTS]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      List<PasskeyModel> actualPasskeyModels = await globalLocator<PasskeysService>().getAllByRpId('example.com');

      // Assert
      expect(actualPasskeyModels.map((PasskeyModel model) => model.id).toSet(), <int>{1, 2});
    });

    test('Should [return EMPTY list] if [RP ID NOT EXISTS]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      List<PasskeyModel> actualPasskeyModels = await globalLocator<PasskeysService>().getAllByRpId('missing.example');

      // Assert
      expect(actualPasskeyModels, <PasskeyModel>[]);
    });
  });

  group('Tests of PasskeysService.getByCredentialId()', () {
    test('Should [return PasskeyModel] if [credential ID EXISTS]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      PasskeyModel actualPasskeyModel = await globalLocator<PasskeysService>().getByCredentialId(<int>[22]);

      // Assert
      expect(actualPasskeyModel.id, 2);
      expect(actualPasskeyModel.userName, 'bob');
    });

    test('Should [throw ChildKeyNotFoundException] if [credential ID NOT EXISTS]', () async {
      // Arrange
      await seedPasskeys();

      // Assert
      expect(
        () => globalLocator<PasskeysService>().getByCredentialId(<int>[99]),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of PasskeysService.getById()', () {
    test('Should [return PasskeyModel] if [passkey EXISTS]', () async {
      // Arrange
      await seedPasskeys();

      // Act
      PasskeyModel actualPasskeyModel = await globalLocator<PasskeysService>().getById(1);

      // Assert
      expect(actualPasskeyModel.rpId, 'example.com');
      expect(actualPasskeyModel.filesystemPath, FilesystemPath.fromString('passkeys/passkey1'));
    });

    test('Should [throw ChildKeyNotFoundException] if [passkey NOT EXISTS]', () async {
      // Assert
      expect(
        () => globalLocator<PasskeysService>().getById(999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of PasskeysService.save()', () {
    test('Should [SAVE passkey metadata] if [passkey NOT EXISTS]', () async {
      // Arrange
      PasskeyModel newPasskey = PasskeyModel(
        id: 10,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPath: FilesystemPath.fromString('passkeys/passkey10'),
        name: 'NEW',
        rpId: 'new.example',
        rpName: 'New',
        userName: 'dave',
        userDisplayName: 'Dave',
        userId: Uint8List.fromList(<int>[10]),
        credentialId: Uint8List.fromList(<int>[100]),
        algorithm: -7,
        signCount: 0,
      );

      // Act
      await globalLocator<PasskeysService>().save(newPasskey);

      // Assert
      expect(await globalLocator<PasskeysService>().getById(10), newPasskey);
    });

    test('Should [UPDATE passkey metadata] if [passkey EXISTS]', () async {
      // Arrange
      await seedPasskeys();
      PasskeyModel original = await globalLocator<PasskeysService>().getById(1);
      PasskeyModel updated = original.copyWith(pinnedBool: true, name: 'UPDATED', signCount: 5);

      // Act
      await globalLocator<PasskeysService>().save(updated);

      // Assert
      expect(await globalLocator<PasskeysService>().getById(1), updated);
    });
  });

  group('Tests of PasskeysService.saveAll()', () {
    test('Should [SAVE all passkeys] if [list NOT EMPTY]', () async {
      // Arrange
      List<PasskeyModel> newPasskeys = passkeys
          .map(
            (PasskeyEntity entity) => PasskeyModel(
              id: entity.id,
              encryptedBool: entity.encryptedBool,
              pinnedBool: entity.pinnedBool,
              filesystemPath: entity.filesystemPath,
              name: entity.name,
              rpId: entity.rpId,
              rpName: entity.rpName,
              userName: entity.userName,
              userDisplayName: entity.userDisplayName,
              userId: Uint8List.fromList(entity.userId),
              credentialId: Uint8List.fromList(entity.credentialId),
              algorithm: entity.algorithm,
              signCount: entity.signCount,
            ),
          )
          .toList();

      // Act
      List<int> actualIds = await globalLocator<PasskeysService>().saveAll(newPasskeys);

      // Assert
      expect(actualIds.toSet(), <int>{1, 2, 3});
      expect((await globalLocator<PasskeysService>().getAllByRpId('example.com')).length, 2);
    });
  });

  group('Tests of PasskeysService.updateFilesystemPath()', () {
    test('Should [UPDATE filesystem path] if [passkey EXISTS]', () async {
      // Arrange
      await globalLocator<PasskeysRepository>().save(passkeys.first.copyWith(filesystemPathString: ''));

      // Act
      PasskeyModel actualPasskeyModel = await globalLocator<PasskeysService>().updateFilesystemPath(1);

      // Assert
      expect(actualPasskeyModel.filesystemPath, FilesystemPath.fromString('passkeys/passkey1'));
      expect((await globalLocator<PasskeysRepository>().getById(1)).filesystemPathString, 'passkeys/passkey1');
    });
  });

  group('Tests of PasskeysService.move()', () {
    test('Should [MOVE passkey metadata and private key] if [passkey EXISTS]', () async {
      // Arrange
      await seedPasskeys(withSecrets: true);
      PasskeyModel passkey = await globalLocator<PasskeysService>().getById(1);
      FilesystemPath newPath = FilesystemPath.fromString('passkeys/group2/passkey1');

      // Act
      await globalLocator<PasskeysService>().move(passkey, newPath);

      // Assert
      expect((await globalLocator<PasskeysService>().getById(1)).filesystemPath, newPath);
      await expectSecretAt(newPath, 1);
      expect(
        () => globalLocator<SecretsService>().get<PasskeySecretsModel>(passkey.filesystemPath, PasswordModel.defaultPassword()),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of PasskeysService.moveAllByParentPath()', () {
    test('Should [MOVE all descendants and their private keys] under given path', () async {
      // Arrange
      await seedPasskeys(withSecrets: true);
      FilesystemPath previous = FilesystemPath.fromString('passkeys/group1');
      FilesystemPath destination = FilesystemPath.fromString('passkeys/group2');

      // Act
      await globalLocator<PasskeysService>().moveAllByParentPath(previous, destination);

      // Assert
      expect((await globalLocator<PasskeysService>().getById(1)).filesystemPath, FilesystemPath.fromString('passkeys/passkey1'));
      expect((await globalLocator<PasskeysService>().getById(2)).filesystemPath, FilesystemPath.fromString('passkeys/group2/passkey2'));
      expect((await globalLocator<PasskeysService>().getById(3)).filesystemPath, FilesystemPath.fromString('passkeys/group2/subgroup/passkey3'));
      await expectSecretAt(FilesystemPath.fromString('passkeys/group2/passkey2'), 2);
      await expectSecretAt(FilesystemPath.fromString('passkeys/group2/subgroup/passkey3'), 3);
    });
  });

  group('Tests of PasskeysService.deleteById()', () {
    test('Should [REMOVE passkey metadata and private key] if [passkey EXISTS]', () async {
      // Arrange
      await seedPasskeys(withSecrets: true);
      FilesystemPath deletedPath = passkeys.first.filesystemPath;

      // Act
      await globalLocator<PasskeysService>().deleteById(1);

      // Assert
      expect(
        () => globalLocator<PasskeysService>().getById(1),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
      expect(
        () => globalLocator<SecretsService>().get<PasskeySecretsModel>(deletedPath, PasswordModel.defaultPassword()),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [passkey NOT EXISTS]', () async {
      // Assert
      expect(
        () => globalLocator<PasskeysService>().deleteById(999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of PasskeysService.deleteAllByParentPath()', () {
    test('Should [REMOVE descendant passkeys and secrets] and [preserve others]', () async {
      // Arrange
      await seedPasskeys(withSecrets: true);

      // Act
      await globalLocator<PasskeysService>().deleteAllByParentPath(FilesystemPath.fromString('passkeys/group1'));

      // Assert
      expect((await globalLocator<PasskeysService>().getById(1)).id, 1);
      await expectSecretAt(passkeys.first.filesystemPath, 1);
      for (int id in <int>[2, 3]) {
        expect(
          () => globalLocator<PasskeysService>().getById(id),
          throwsA(isA<ChildKeyNotFoundException>()),
        );
      }
    });
  });

  tearDown(testDatabase.close);
}
