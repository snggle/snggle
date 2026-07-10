import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_root_dir.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  tearDown(() async {
    await testDatabase.close();
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

  group('Tests of AppService.logout()', () {
    test('Should [throws Exception] if [masterKey cleared]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      MasterKeyController actualMasterKeyController = globalLocator<MasterKeyController>()..setPassword(PasswordModel.fromPlaintext('1111'));

      // Act
      globalLocator<AppService>().logout();

      // Assert
      expect(
        () async => actualMasterKeyController.encrypt('some_value'),
        throwsException,
      );
    });

    test('Should [clear active wallet]', () {
      // Arrange
      ActiveWalletController actualActiveWalletController = globalLocator<ActiveWalletController>();

      WalletModel actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString(
          'vault1/network1/wallet1',
        ),
        name: 'WALLET 0',
      );

      actualActiveWalletController.setActiveWallet(
        walletModel: actualWalletModel,
      );

      // Act
      globalLocator<AppService>().logout();

      // Assert
      expect(actualActiveWalletController.hasActiveWallet, false);
      expect(actualActiveWalletController.walletModel, null);
    });
  });

  group('Tests of AppService.wipeAll()', () {
    setUp(() async {
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
    });

    test('Should [wipe filesystem storage] if [filesystem NOT EMPTY]', () async {
      // Act
      await globalLocator<AppService>().wipeAll();

      // Assert
      Map<String, dynamic> actualFilesystemStructure = testDatabase.readRawFilesystem();
      expect(actualFilesystemStructure, <String, dynamic>{});
    });

    test('Should [wipe FlutterSecureStorage] if [FlutterSecureStorage NOT EMPTY]', () async {
      // Act
      await globalLocator<AppService>().wipeAll();

      // Assert
      Map<String, String> actualDatabaseValue = await const FlutterSecureStorage().readAll();
      expect(actualDatabaseValue, <String, String>{});
    });

    test('Should [close Isar] and [prevent further DB operations] if [Isar OPEN]', () async {
      // Act
      await globalLocator<AppService>().wipeAll();

      // Assert
      expect(Isar.getInstance(testDatabase.testSessionUUID), isNull);

      expect(
        () => globalLocator<IsarDatabaseManager>().perform((Isar isar) => isar.getSize()),
        throwsA(isA<IsarError>()),
      );
    });

    test('Should [wipe data] and [clear session data]', () async {
      // Arrange
      MasterKeyController actualMasterKeyController = globalLocator<MasterKeyController>()..setPassword(PasswordModel.fromPlaintext('1111'));

      ActiveWalletController actualActiveWalletController = globalLocator<ActiveWalletController>();

      WalletModel actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString(
          'vault1/network1/wallet1',
        ),
        name: 'WALLET 0',
      );

      actualActiveWalletController.setActiveWallet(
        walletModel: actualWalletModel,
      );

      // Act
      await globalLocator<AppService>().wipeAll();

      // Assert
      expect(
        () async => actualMasterKeyController.encrypt('some_value'),
        throwsA(
          isA<Exception>().having(
            (Exception exception) => exception.toString(),
            'message',
            contains('does not contain password'),
          ),
        ),
      );
      expect(actualActiveWalletController.hasActiveWallet, false);
      expect(actualActiveWalletController.walletModel, null);
    });
  });

  group('Tests of AppService.isDataBaseExist()', () {
    setUp(() async {
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
    });

    test('Should [return FALSE] if [filesystem_storage directory NOT EXISTS]', () async {
      // Arrange
      RootDirectoryBuilder rootDirectoryBuilder = globalLocator<RootDirectoryBuilder>();
      Directory rootDirectory = await rootDirectoryBuilder.call();
      Directory filesystemStorageDir = Directory('${rootDirectory.path}/${FilesystemStorageRootDir.filesystem_storage.name}');

      if (await filesystemStorageDir.exists()) {
        await filesystemStorageDir.delete(recursive: true);
      }

      // Act
      bool actualDatabaseExistBool = await globalLocator<AppService>().isDataBaseExist();

      // Assert
      expect(actualDatabaseExistBool, false);
    });

    test('Should [return FALSE] if [vaults directory EXISTS] but contains [NO snggle files]', () async {
      // Arrange
      RootDirectoryBuilder rootDirectoryBuilder = globalLocator<RootDirectoryBuilder>();
      Directory rootDirectory = await rootDirectoryBuilder.call();
      Directory filesystemStorageDir = Directory('${rootDirectory.path}/${FilesystemStorageRootDir.filesystem_storage.name}');
      Directory vaultsDir = Directory('${rootDirectory.path}/${FilesystemStorageRootDir.filesystem_storage.name}/vaults');

      if (await filesystemStorageDir.exists()) {
        await filesystemStorageDir.delete(recursive: true);
      }

      await vaultsDir.create(recursive: true);
      await File('${filesystemStorageDir.path}/not_a_vault_file.txt').writeAsString('some_data');

      // Act
      bool actualDatabaseExistBool = await globalLocator<AppService>().isDataBaseExist();

      // Assert
      expect(actualDatabaseExistBool, false);
    });

    test('Should [return TRUE] if [snggle file EXISTS in vaults directory] and has [size > 0]', () async {
      // Arrange
      RootDirectoryBuilder rootDirectoryBuilder = globalLocator<RootDirectoryBuilder>();
      Directory rootDirectory = await rootDirectoryBuilder.call();
      Directory filesystemStorageDir = Directory('${rootDirectory.path}/${FilesystemStorageRootDir.filesystem_storage.name}');

      if (await filesystemStorageDir.exists()) {
        await filesystemStorageDir.delete(recursive: true);
      }

      Directory nestedDir = Directory('${filesystemStorageDir.path}/vaults');
      await nestedDir.create(recursive: true);
      await File('${nestedDir.path}/vault.snggle').writeAsBytes(<int>[1, 2, 3]);

      // Act
      bool actualDatabaseExistBool = await globalLocator<AppService>().isDataBaseExist();

      // Assert
      expect(actualDatabaseExistBool, true);
    });
  });
}
