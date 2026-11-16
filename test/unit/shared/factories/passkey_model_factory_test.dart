import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/passkey_entity/passkey_entity.dart';
import 'package:snggle/infra/services/passkeys_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/passkey_model_factory.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of PasskeyModelFactory.createNewPasskey()', () {
    test('Should [return PasskeyModel] with initial values and [SAVE private key] if [database EMPTY]', () async {
      // Arrange
      Uint8List privateKey = Uint8List.fromList(List<int>.generate(32, (int index) => index));

      // Act
      PasskeyModel actualPasskeyModel = await globalLocator<PasskeyModelFactory>().createNewPasskey(
        rpId: 'example.com',
        rpName: 'Example',
        userName: 'alice',
        userDisplayName: 'Alice',
        userId: Uint8List.fromList(<int>[1, 2, 3]),
        credentialId: Uint8List.fromList(<int>[10, 20, 30]),
        privateKey: privateKey,
      );

      // Assert
      expect(actualPasskeyModel.id, 1);
      expect(actualPasskeyModel.encryptedBool, false);
      expect(actualPasskeyModel.pinnedBool, false);
      expect(actualPasskeyModel.filesystemPath, FilesystemPath.fromString('passkeys/passkey1'));
      expect(actualPasskeyModel.name, 'Example');
      expect(actualPasskeyModel.rpId, 'example.com');
      expect(actualPasskeyModel.rpName, 'Example');
      expect(actualPasskeyModel.userName, 'alice');
      expect(actualPasskeyModel.userDisplayName, 'Alice');
      expect(actualPasskeyModel.userId, <int>[1, 2, 3]);
      expect(actualPasskeyModel.credentialId, <int>[10, 20, 30]);
      expect(actualPasskeyModel.algorithm, -7);
      expect(actualPasskeyModel.signCount, 0);
      expect(await globalLocator<PasskeysService>().getById(1), actualPasskeyModel);

      PasskeySecretsModel actualSecrets = await globalLocator<SecretsService>().get<PasskeySecretsModel>(
        actualPasskeyModel.filesystemPath,
        PasswordModel.defaultPassword(),
      );
      expect(actualSecrets.privateKey, privateKey);
    });

    test('Should [create separate passkeys] with [different IDs and paths]', () async {
      // Arrange
      PasskeyModelFactory factory = globalLocator<PasskeyModelFactory>();
      Uint8List privateKey = Uint8List(32);

      // Act
      PasskeyModel first = await factory.createNewPasskey(
        rpId: 'example.com',
        rpName: 'Example',
        userName: 'alice',
        userDisplayName: 'Alice',
        userId: Uint8List.fromList(<int>[1]),
        credentialId: Uint8List.fromList(<int>[10]),
        privateKey: privateKey,
      );
      PasskeyModel second = await factory.createNewPasskey(
        rpId: 'example.com',
        rpName: 'Example',
        userName: 'bob',
        userDisplayName: 'Bob',
        userId: Uint8List.fromList(<int>[2]),
        credentialId: Uint8List.fromList(<int>[20]),
        privateKey: privateKey,
      );

      // Assert
      expect(first.id, isNot(second.id));
      expect(first.filesystemPath, FilesystemPath.fromString('passkeys/passkey${first.id}'));
      expect(second.filesystemPath, FilesystemPath.fromString('passkeys/passkey${second.id}'));
      expect((await globalLocator<PasskeysService>().getAllByRpId('example.com')).length, 2);
    });
  });

  group('Tests of PasskeyModelFactory.createFromEntity()', () {
    test('Should [return PasskeyModel] from given PasskeyEntity', () {
      // Arrange
      const PasskeyEntity passkeyEntity = PasskeyEntity(
        id: 4,
        encryptedBool: true,
        pinnedBool: true,
        rpId: 'example.com',
        rpName: 'Example',
        userName: 'alice',
        userDisplayName: 'Alice',
        userId: <int>[1, 2, 3],
        credentialId: <int>[10, 20, 30],
        algorithm: -7,
        signCount: 2,
        filesystemPathString: 'passkeys/passkey4',
        name: 'EXAMPLE',
      );

      // Act
      PasskeyModel actualPasskeyModel = globalLocator<PasskeyModelFactory>().createFromEntity(passkeyEntity);

      // Assert
      expect(actualPasskeyModel.id, 4);
      expect(actualPasskeyModel.encryptedBool, true);
      expect(actualPasskeyModel.pinnedBool, true);
      expect(actualPasskeyModel.rpId, 'example.com');
      expect(actualPasskeyModel.rpName, 'Example');
      expect(actualPasskeyModel.userName, 'alice');
      expect(actualPasskeyModel.userDisplayName, 'Alice');
      expect(actualPasskeyModel.userId, <int>[1, 2, 3]);
      expect(actualPasskeyModel.credentialId, <int>[10, 20, 30]);
      expect(actualPasskeyModel.algorithm, -7);
      expect(actualPasskeyModel.signCount, 2);
      expect(actualPasskeyModel.filesystemPath, FilesystemPath.fromString('passkeys/passkey4'));
      expect(actualPasskeyModel.name, 'EXAMPLE');
    });
  });

  group('Tests of PasskeyModelFactory.createFromEntities()', () {
    test('Should [return List of PasskeyModel] from given List of PasskeyEntity', () {
      // Arrange
      const List<PasskeyEntity> entities = <PasskeyEntity>[
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
          name: 'EXAMPLE',
        ),
        PasskeyEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: true,
          rpId: 'other.com',
          rpName: 'Other',
          userName: 'bob',
          userDisplayName: 'Bob',
          userId: <int>[2],
          credentialId: <int>[22],
          algorithm: -7,
          signCount: 3,
          filesystemPathString: 'passkeys/passkey2',
          name: 'OTHER',
        ),
      ];

      // Act
      List<PasskeyModel> actualPasskeyModels = globalLocator<PasskeyModelFactory>().createFromEntities(entities);

      // Assert
      expect(actualPasskeyModels.length, 2);
      expect(actualPasskeyModels.map((PasskeyModel model) => model.id).toList(), <int>[1, 2]);
      expect(actualPasskeyModels.map((PasskeyModel model) => model.rpId).toList(), <String>['example.com', 'other.com']);
      expect(actualPasskeyModels.map((PasskeyModel model) => model.signCount).toList(), <int>[0, 3]);
    });
  });

  tearDown(testDatabase.close);
}
