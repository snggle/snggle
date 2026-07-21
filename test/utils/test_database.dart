import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/objectbox_database_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import 'database_mock.dart';

class TestDatabase {
  static Directory testRootDirectory = Directory('${Directory.systemTemp.path}/snggle/test');

  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  late PasswordModel? appPasswordModel;
  String? _testSessionUUID;

  String get testSessionUUID => _testSessionUUID!;
  late MasterKeyVO? masterKeyVO;
  bool testInitializedBool = false;

  TestDatabase();

  Future<void> init({required PasswordModel appPasswordModel, DatabaseMock? databaseMock}) async {
    _testSessionUUID = const Uuid().v4();
    this.appPasswordModel = appPasswordModel;

    Directory rootDirectory = Directory('${testRootDirectory.path}/$testSessionUUID')..createSync(recursive: true);

    initLocator();
    globalLocator.allowReassignment = true;
    globalLocator.registerLazySingleton<RootDirectoryBuilder>(
      () =>
          () => rootDirectory,
    );

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
    String? encryptedMasterKey = secureStorageContent[SecureStorageKey.encryptedMasterKey.name] as String?;
    if (encryptedMasterKey != null) {
      masterKeyVO = MasterKeyVO(encryptedMasterKey: encryptedMasterKey);
    }
  }

  Future<void> close() async {
    if (globalLocator.isRegistered<ObjectboxDatabaseManager>()) {
      await globalLocator<ObjectboxDatabaseManager>().close();
    }

    String? tmpTestSessionUUID = _testSessionUUID;
    Directory cacheDirectory = Directory('${testRootDirectory.path}/$tmpTestSessionUUID');
    if (cacheDirectory.existsSync()) {
      cacheDirectory.deleteSync(recursive: true);
    }
  }

  Map<String, dynamic> readDecryptedFilesystem({String path = ''}) {
    Map<String, dynamic> encryptedJson = readRawFilesystem(path: path);
    Map<String, dynamic> decryptedJson = <String, dynamic>{};
    encryptedJson.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        decryptedJson[key] = readDecryptedFilesystem(path: '$path/$key');
      } else if (value is String) {
        decryptedJson[key] = masterKeyVO!.decrypt(appPasswordModel: appPasswordModel!, encryptedData: value);
      }
    });
    return decryptedJson;
  }

  Map<String, dynamic> readRawFilesystem({String path = ''}) {
    Map<String, dynamic> jsonMap = <String, dynamic>{};

    Directory tmpDirectory = Directory(_joinPath(<String>[testRootDirectory.path, testSessionUUID, path]));

    if (!tmpDirectory.existsSync()) {
      return jsonMap;
    }

    for (FileSystemEntity fileSystemEntity in tmpDirectory.listSync(followLinks: false)) {
      String fileName = _getLastPathSegment(fileSystemEntity.path);

      String nextPath = path.isEmpty ? fileName : '$path/$fileName';

      if (fileSystemEntity is Directory) {
        jsonMap[fileName] = readRawFilesystem(path: nextPath);
      } else if (fileSystemEntity is File) {
        if (fileName.endsWith('.snggle')) {
          jsonMap[fileName] = fileSystemEntity.readAsStringSync();
        }
      }
    }

    return jsonMap;
  }

  Future<Map<String, dynamic>> readEncryptedSecureStorage(SecureStorageKey secureStorageKey) async {
    String? actualEncryptedVaultsKeyValue = await flutterSecureStorage.read(key: secureStorageKey.name);
    String actualDecryptedVaultsKeyValue = masterKeyVO!.decrypt(appPasswordModel: appPasswordModel!, encryptedData: actualEncryptedVaultsKeyValue!);
    Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;
    return actualVaultsMap;
  }

  Future<void> _setupIsarDatabase(DatabaseMock databaseMock) async {
    if (testInitializedBool) {
      await globalLocator<ObjectboxDatabaseManager>().close();
    }

    String tmpTestSessionUUID = testSessionUUID;

    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();
    Directory databaseDirectory = Directory(_joinPath(<String>[rootDirectory.path, tmpTestSessionUUID]));
    File databaseMockFile = File(_joinPath(<String>['test', 'mocks', databaseMock.name, 'objectbox_mock.mdb']));
    if (databaseMockFile.existsSync()) {
      databaseDirectory.createSync(recursive: true);
      await databaseMockFile.copy(_joinPath(<String>[databaseDirectory.path, 'data.mdb']));
    }
    await globalLocator<ObjectboxDatabaseManager>().initDatabase(name: tmpTestSessionUUID);
  }

  void _setupSecureStorage(DatabaseMock databaseMock) {
    File secureStorageMockFile = File('test/mocks/${databaseMock.name}/secure_storage_mock.json');
    if (secureStorageMockFile.existsSync()) {
      Map<String, dynamic> secureStorageContent = jsonDecode(secureStorageMockFile.readAsStringSync()) as Map<String, dynamic>;

      updateSecureStorage(secureStorageContent);
    }
  }

  Future<void> _setupFilesystemStorage(DatabaseMock databaseMock) async {
    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();
    Directory filesystemMockDirectory = Directory(_joinPath(<String>['test', 'mocks', databaseMock.name, 'filesystem_mock']));
    if (filesystemMockDirectory.existsSync()) {
      _copyDirectory(filesystemMockDirectory, rootDirectory);
    }
  }

  String _joinPath(List<String> segments) {
    return segments
        .where((String segment) => segment.isNotEmpty)
        .map((String segment) => segment.replaceAll(RegExp(r'[\\/]'), Platform.pathSeparator))
        .join(Platform.pathSeparator);
  }

  String _getLastPathSegment(String path) {
    return path.split(RegExp(r'[\\/]')).where((String segment) => segment.isNotEmpty).last;
  }

  void _copyDirectory(Directory source, Directory destination) {
    if (destination.existsSync() == false) {
      destination.createSync(recursive: true);
    }

    source.listSync().forEach((FileSystemEntity entity) {
      if (entity is Directory) {
        Directory newDirectory = Directory(_joinPath(<String>[destination.path, _getLastPathSegment(entity.path)]));
        _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        File newFile = File(_joinPath(<String>[destination.path, _getLastPathSegment(entity.path)]));
        entity.copySync(newFile.path);
      }
    });
  }
}
