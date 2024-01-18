import 'dart:io';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

const String kEmptyString = '';

class TestUtils {
  static Directory testRootDirectory = Directory('${Directory.systemTemp.path}/snggle/test');

  static void printInfo(String message) {
    // ignore: avoid_print
    print('\x1B[34m$message\x1B[0m');
  }

  static void printError(String message) {
    // ignore: avoid_print
    print('\x1B[31m$message\x1B[0m');
  }

  static void clearCache(String testSessionUUID) {
    Directory cacheDirectory = Directory('${testRootDirectory.path}/$testSessionUUID');
    if (cacheDirectory.existsSync()) {
      cacheDirectory.deleteSync(recursive: true);
    }
  }

  static void setupTmpFilesystemStructureFromJson(Map<String, dynamic> json, {String path = ''}) {
    json.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        setupTmpFilesystemStructureFromJson(value, path: '$path/$key');
      } else if (value is String) {
        File('${testRootDirectory.path}/$path/$key')
          ..createSync(recursive: true)
          ..writeAsStringSync(value);
      }
    });
  }

  static Map<String, dynamic> readDecryptedTmpFilesystemStructureAsJson(
    String path,
    MasterKeyVO masterKeyVO,
    PasswordModel passwordModel, {
    bool passwordBool = false,
  }) {
    Map<String, dynamic> encryptedJson = readTmpFilesystemStructureAsJson(path: path);
    Map<String, dynamic> decryptedJson = <String, dynamic>{};
    encryptedJson.forEach((String key, dynamic value) {
      String fileName = key;

      if (fileName.endsWith('.snggle')) {
        Ciphertext ciphertext = Ciphertext.fromJsonString(value as String);
        decryptedJson[key] = masterKeyVO.decrypt(appPasswordModel: passwordModel, ciphertext: ciphertext);
        if (passwordBool) {
          decryptedJson[key] = passwordModel.decrypt(ciphertext: Ciphertext.fromJsonString(decryptedJson[key] as String));
        }
      } else {
        decryptedJson[key] = readDecryptedTmpFilesystemStructureAsJson('$path/$key', masterKeyVO, passwordModel, passwordBool: passwordBool);
      }
    });
    return decryptedJson;
  }

  static Map<String, dynamic> readTmpFilesystemStructureAsJson({String path = ''}) {
    Directory tmpDirectory = Directory('${testRootDirectory.path}/$path');

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
        json[fileName] = readTmpFilesystemStructureAsJson(path: '$path/$fileName');
      }
    }
    return json;
  }
}
