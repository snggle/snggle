import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EncryptedFilesystemStorageManager extends FilesystemStorageManager {
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  EncryptedFilesystemStorageManager({
    required super.databaseParentKey,
    super.rootDirectoryBuilder,
  });

  @override
  Future<String> read(FilesystemPath filesystemPath) async {
    String encryptedFileContent = await super.read(filesystemPath);
    Ciphertext ciphertext = Ciphertext.fromJsonString(encryptedFileContent);
    return _masterKeyController.decrypt(ciphertext);
  }

  @override
  Future<void> write(FilesystemPath filesystemPath, String plainTextValue) async {
    Ciphertext ciphertext = await _masterKeyController.encrypt(plainTextValue);
    await super.write(filesystemPath, ciphertext.toJsonString(prettyPrintBool: true));
  }
}
