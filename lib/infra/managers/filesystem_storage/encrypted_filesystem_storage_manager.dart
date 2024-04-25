import 'dart:async';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';

class EncryptedFilesystemStorageManager extends FilesystemStorageManager {
  final MasterKeyController _masterKeyController;

  EncryptedFilesystemStorageManager({
    required super.databaseParentKey,
    super.rootDirectory,
    MasterKeyController? masterKeyController,
  }) : _masterKeyController = masterKeyController ?? globalLocator<MasterKeyController>();

  @override
  Future<String> read(String path) async {
    String encryptedFileContent = await super.read(path);
    return _masterKeyController.decrypt(encryptedFileContent);
  }

  @override
  Future<void> write(String path, String plaintextValue) async {
    String encryptedValue = await _masterKeyController.encrypt(plaintextValue);
    await super.write(path, encryptedValue);
  }
}
