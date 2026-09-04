import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_key.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

class AppService {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();
  final RootDirectoryBuilder _rootDirectoryBuilder = globalLocator<RootDirectoryBuilder>();
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();

  Future<bool> isDataBaseExist() async {
    Directory rootDirectory = await _rootDirectoryBuilder.call();
    Directory filesystemStorageDirectory = Directory('${rootDirectory.path}/${FilesystemStorageKey.filesystem_storage.name}');

    if (await filesystemStorageDirectory.exists() == false) {
      return false;
    }

    await for (FileSystemEntity fileSystemEntity in filesystemStorageDirectory.list(recursive: true, followLinks: false)) {
      if (fileSystemEntity is! File) {
        continue;
      }

      String path = fileSystemEntity.path;
      bool snggleFileBool = path.endsWith('.snggle');

      if (snggleFileBool == false) {
        continue;
      }

      int size = await fileSystemEntity.length();
      if (size > 0) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isPasswordValid(PasswordModel appPasswordModel) async {
    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
    return appPasswordModel.isValidForData(masterKeyVO.encryptedMasterKey);
  }

  Future<void> wipeAll() async {
    await wipeSecureStorage();
    await _wipeFilesystemStorage();
    await _wipeIsarDatabase();

    globalLocator<ActiveWalletController>().clearActiveWallet();
  }

  Future<void> wipeSecureStorage() async {
    await _flutterSecureStorage.deleteAll();
  }

  Future<void> _wipeFilesystemStorage() async {
    Directory rootDirectory = await _rootDirectoryBuilder();
    rootDirectory.listSync().forEach((FileSystemEntity e) => e.deleteSync(recursive: true));
  }

  Future<void> _wipeIsarDatabase() async {
    await globalLocator<IsarDatabaseManager>().close();
  }
}
