import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';

class SecretsRepository {
  final FilesystemStorageManager _filesystemStorageManager;

  SecretsRepository({
    FilesystemStorageManager? filesystemStorageManager,
  }) : _filesystemStorageManager = filesystemStorageManager ?? EncryptedFilesystemStorageManager(databaseParentKey: DatabaseParentKey.secrets);

  Future<String> getEncryptedSecrets(String path) async {
    return _filesystemStorageManager.read(path);
  }

  Future<void> saveEncryptedSecrets(String path, String encryptedSecrets) async {
    await _filesystemStorageManager.write(path, encryptedSecrets);
  }

  Future<void> deleteSecrets(String path) async {
    await _filesystemStorageManager.delete(path);
  }
}
