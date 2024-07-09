import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

class TestDatabase {
  static Directory testRootDirectory = Directory('${Directory.systemTemp.path}/snggle/test');

  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  late PasswordModel? appPasswordModel;
  late String testSessionUUID;
  late MasterKeyVO? masterKeyVO;

  TestDatabase({
    this.appPasswordModel,
    Map<String, dynamic>? secureStorageContent,
    Map<String, dynamic>? filesystemStorageContent,
  }) {
    TestWidgetsFlutterBinding.ensureInitialized();

    globalLocator.allowReassignment = true;
    initLocator();
    globalLocator.registerLazySingleton<RootDirectoryBuilder>(() => () => Directory('${testRootDirectory.path}/$testSessionUUID'));

    testSessionUUID = const Uuid().v4();

    updateSecureStorage(secureStorageContent ?? <String, dynamic>{});

    _setupFilesystemStorage(filesystemStorageContent ?? <String, dynamic>{}, path: testSessionUUID);

    if (appPasswordModel != null) {
      globalLocator<MasterKeyController>().setPassword(appPasswordModel!);
    }
  }

  void updateSecureStorage(Map<String, dynamic> secureStorageContent) {
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(secureStorageContent));
    String? encryptedMasterKey = secureStorageContent[SecureStorageKey.encryptedMasterKey.name] as String?;
    if (encryptedMasterKey != null) {
      masterKeyVO = MasterKeyVO(encryptedMasterKey: encryptedMasterKey);
    }
  }

  void close() {
    Directory cacheDirectory = Directory('${testRootDirectory.path}/$testSessionUUID');
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
    Directory tmpDirectory = Directory('${testRootDirectory.path}/$testSessionUUID/$path');

    Map<String, dynamic> json = <String, dynamic>{};
    List<FileSystemEntity> files = tmpDirectory.listSync();
    for (FileSystemEntity file in files) {
      String fileName = file.path.replaceFirst(tmpDirectory.path, '');
      if (fileName.startsWith('/')) {
        fileName = fileName.replaceFirst('/', '');
      }

      if (fileName.endsWith('.snggle')) {
        json[fileName] = (file as File).readAsStringSync();
      } else {
        json[fileName] = readRawFilesystem(path: '$path/$fileName');
      }
    }
    return json;
  }

  Future<Map<String, dynamic>> readEncryptedSecureStorage(SecureStorageKey secureStorageKey) async {
    String? actualEncryptedVaultsKeyValue = await flutterSecureStorage.read(key: secureStorageKey.name);
    String actualDecryptedVaultsKeyValue = masterKeyVO!.decrypt(
      appPasswordModel: appPasswordModel!,
      encryptedData: actualEncryptedVaultsKeyValue!,
    );
    Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;
    return actualVaultsMap;
  }

  void _setupFilesystemStorage(Map<String, dynamic> json, {String path = ''}) {
    json.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        _setupFilesystemStorage(value, path: '$path/$key');
      } else if (value is String) {
        File('${testRootDirectory.path}/$path/$key')
          ..createSync(recursive: true)
          ..writeAsStringSync(value);
      }
    });
  }
}
