import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';

class SecretsRepository {
  final FilesystemStorageManager _filesystemStorageManager;

  SecretsRepository({
    FilesystemStorageManager? filesystemStorageManager,
  }) : _filesystemStorageManager = filesystemStorageManager ?? EncryptedFilesystemStorageManager(databaseParentKey: DatabaseParentKey.secrets);

  Future<Map<String, String>> getAllMapped(String path) async {
    return _filesystemStorageManager.readAllMapped(path);
  }

  Future<Ciphertext> getEncryptedSecrets(String path) async {
    String fileContent = await _filesystemStorageManager.read(path);
    return Ciphertext.fromJsonString(fileContent);
  }

  Future<void> saveEncryptedSecrets(String path, Ciphertext ciphertext) async {
    await _filesystemStorageManager.write(path, ciphertext.toJsonString(prettyPrintBool: true));
  }

  Future<void> deleteSecrets(String path) async {
    await _filesystemStorageManager.delete(path);
  }
}
