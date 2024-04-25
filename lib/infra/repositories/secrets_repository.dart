import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class SecretsRepository {
  final FilesystemStorageManager _filesystemStorageManager;

  SecretsRepository({
    FilesystemStorageManager? filesystemStorageManager,
  }) : _filesystemStorageManager = filesystemStorageManager ?? EncryptedFilesystemStorageManager(databaseParentKey: DatabaseParentKey.secrets);

  Future<String> getEncrypted(FilesystemPath filesystemPath) async {
    return _filesystemStorageManager.read(filesystemPath.fullPath);
  }

  Future<void> saveEncrypted(FilesystemPath filesystemPath, String encryptedSecrets) async {
    await _filesystemStorageManager.write(filesystemPath.fullPath, encryptedSecrets);
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    await _filesystemStorageManager.delete(filesystemPath.fullPath);
  }
}
