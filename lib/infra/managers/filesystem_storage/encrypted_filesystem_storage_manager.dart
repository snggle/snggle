import 'dart:async';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EncryptedFilesystemStorageManager extends FilesystemStorageManager {
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  EncryptedFilesystemStorageManager({
    required super.filesystemStorageKey,
  });

  @override
  Future<String> read(FilesystemPath filesystemPath) async {
    String encryptedFileContent = await super.read(filesystemPath);
    return _masterKeyController.decrypt(encryptedFileContent);
  }

  @override
  Future<void> write(FilesystemPath filesystemPath, String plainTextValue) async {
    String encryptedValue = await _masterKeyController.encrypt(plainTextValue);
    await super.write(filesystemPath, encryptedValue);
  }
}
