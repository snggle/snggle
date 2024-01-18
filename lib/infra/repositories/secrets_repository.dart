import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class SecretsRepository {
  final FilesystemStorageManager _filesystemStorageManager;

  SecretsRepository({
    FilesystemStorageManager? filesystemStorageManager,
  }) : _filesystemStorageManager = filesystemStorageManager ?? EncryptedFilesystemStorageManager(databaseParentKey: DatabaseParentKey.secrets);

  Future<Ciphertext> getEncrypted(FilesystemPath filesystemPath) async {
    String fileContent = await _filesystemStorageManager.read(filesystemPath);
    return Ciphertext.fromJsonString(fileContent);
  }

  Future<void> saveEncrypted(FilesystemPath filesystemPath, Ciphertext ciphertext) async {
    await _filesystemStorageManager.write(filesystemPath, ciphertext.toJsonString(prettyPrintBool: true));
  }

  Future<void> move(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    await _filesystemStorageManager.move(previousFilesystemPath, newFilesystemPath);
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    await _filesystemStorageManager.delete(filesystemPath);
  }
}
