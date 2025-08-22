import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p; // ✅ use path everywhere
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import 'database_mock.dart';

// TODO(Kamil): This file was temporarily modified by ChatGPT to fix tests on Windows
// TODO(Kamil): it will likely be reverted before merging and moved into a new branch

class TestDatabase {
  // Keep root deterministic for dumps/debugging
  static Directory testRootDirectory = Directory(p.join(Directory.systemTemp.path, 'snggle', 'test'));

  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  late PasswordModel? appPasswordModel;
  late String testSessionUUID;
  late MasterKeyVO? masterKeyVO;
  bool testInitializedBool = false;

  TestDatabase();

  Future<void> init({
    required PasswordModel appPasswordModel,
    DatabaseMock? databaseMock,
  }) async {
    await Isar.initializeIsarCore(download: true);

    testSessionUUID = const Uuid().v4();
    this.appPasswordModel = appPasswordModel;

    final Directory rootDirectory = Directory(p.join(testRootDirectory.path, testSessionUUID))
      ..createSync(recursive: true);

    // Build default DI graph and point RootDirectoryBuilder at this test root.
    initLocator();
    globalLocator.allowReassignment = true;
    // NOTE: RootDirectoryBuilder is typedef FutureOr<Directory> Function()
    globalLocator.registerLazySingleton<RootDirectoryBuilder>(() => () => rootDirectory);

    if (databaseMock != null) {
      await updateDatabaseMock(databaseMock);
    }
    globalLocator<MasterKeyController>().setPassword(appPasswordModel);

    testInitializedBool = true;
  }

  Future<void> updateDatabaseMock(DatabaseMock databaseMock) async {
    await _setupFilesystemStorage(databaseMock);
    await _setupIsarDatabase(databaseMock);
    _setupSecureStorage(databaseMock);
  }

  void updateSecureStorage(Map<String, dynamic> secureStorageContent) {
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(secureStorageContent));
    final String? encryptedMasterKey = secureStorageContent[SecureStorageKey.encryptedMasterKey.name] as String?;
    if (encryptedMasterKey != null) {
      masterKeyVO = MasterKeyVO(encryptedMasterKey: encryptedMasterKey);
    }
  }

  Future<void> close() async {
    await globalLocator<IsarDatabaseManager>().close();

    final Directory cacheDirectory = Directory(p.join(testRootDirectory.path, testSessionUUID));
    if (cacheDirectory.existsSync()) {
      cacheDirectory.deleteSync(recursive: true);
    }
  }

  Map<String, dynamic> readDecryptedFilesystem({String path = ''}) {
    final Map<String, dynamic> encryptedJson = readRawFilesystem(path: path);
    final Map<String, dynamic> decryptedJson = <String, dynamic>{};
    encryptedJson.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        decryptedJson[key] = readDecryptedFilesystem(path: p.join(path, key));
      } else if (value is String) {
        decryptedJson[key] = masterKeyVO!.decrypt(appPasswordModel: appPasswordModel!, encryptedData: value);
      }
    });
    return decryptedJson;
  }

  Map<String, dynamic> readRawFilesystem({String path = ''}) {
    final Directory tmpDirectory = Directory(p.join(testRootDirectory.path, testSessionUUID, path));

    final Map<String, dynamic> json = <String, dynamic>{};
    if (!tmpDirectory.existsSync()) {
      return json;
    }

    final List<FileSystemEntity> files = tmpDirectory.listSync();
    for (final FileSystemEntity entity in files) {
      final String name = p.basename(entity.path);

      if (name.endsWith('.snggle')) {
        json[name] = (entity as File).readAsStringSync();
      } else if (entity is Directory) {
        json[name] = readRawFilesystem(path: p.join(path, name));
      }
    }
    return json;
  }

  Future<Map<String, dynamic>> readEncryptedSecureStorage(SecureStorageKey secureStorageKey) async {
    final String? actualEncryptedVaultsKeyValue = await flutterSecureStorage.read(key: secureStorageKey.name);
    final String actualDecryptedVaultsKeyValue = masterKeyVO!.decrypt(
      appPasswordModel: appPasswordModel!,
      encryptedData: actualEncryptedVaultsKeyValue!,
    );
    final Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;
    return actualVaultsMap;
  }

  Future<void> _setupIsarDatabase(DatabaseMock databaseMock) async {
    if (testInitializedBool) {
      await globalLocator<IsarDatabaseManager>().close();
    }

    final Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();
    final File databaseMockFile = File(p.join('test', 'mocks', databaseMock.name, 'isar_mock.isar'));
    if (databaseMockFile.existsSync()) {
      await databaseMockFile.copy(p.join(rootDirectory.path, '$testSessionUUID.isar'));
    }
    await globalLocator<IsarDatabaseManager>().initDatabase(name: testSessionUUID);
  }

  void _setupSecureStorage(DatabaseMock databaseMock) {
    final File secureStorageMockFile = File(p.join('test', 'mocks', databaseMock.name, 'secure_storage_mock.json'));
    if (secureStorageMockFile.existsSync()) {
      final Map<String, dynamic> secureStorageContent = jsonDecode(secureStorageMockFile.readAsStringSync()) as Map<String, dynamic>;
      updateSecureStorage(secureStorageContent);
    }
  }

  Future<void> _setupFilesystemStorage(DatabaseMock databaseMock) async {
    final Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();
    final Directory filesystemMockDirectory = Directory(p.join('test', 'mocks', databaseMock.name, 'filesystem_mock'));
    if (filesystemMockDirectory.existsSync()) {
      _copyDirectory(filesystemMockDirectory, rootDirectory);
    }
  }

  /// Recursively copy [source] contents into [destination], preserving names,
  /// using cross-platform path ops (works on Windows).
  void _copyDirectory(Directory source, Directory destination) {
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }

    for (final FileSystemEntity entity in source.listSync(followLinks: false)) {
      final String newPath = p.join(destination.path, p.basename(entity.path));
      if (entity is Directory) {
        _copyDirectory(entity, Directory(newPath));
      } else if (entity is File) {
        final File newFile = File(newPath)..createSync(recursive: true)
          ..writeAsBytesSync(entity.readAsBytesSync());
      }
    }
  }
}
