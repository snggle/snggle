import 'dart:io';

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

  static Map<String, dynamic> readDecryptedTmpFilesystemStructureAsJson(String path, MasterKeyVO masterKeyVO, PasswordModel passwordModel) {
    Map<String, dynamic> encryptedJson = readTmpFilesystemStructureAsJson(path: path);
    Map<String, dynamic> decryptedJson = <String, dynamic>{};
    encryptedJson.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        decryptedJson[key] = readDecryptedTmpFilesystemStructureAsJson('$path/$key', masterKeyVO, passwordModel);
      } else if (value is String) {
        decryptedJson[key] = masterKeyVO.decrypt(appPasswordModel: passwordModel, encryptedData: value);
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
