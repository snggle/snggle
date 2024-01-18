import 'dart:async';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';

class EncryptedFilesystemStorageManager extends FilesystemStorageManager {
  final AuthSingletonCubit _authSingletonCubit;

  EncryptedFilesystemStorageManager({
    required super.databaseParentKey,
    super.rootDirectory,
    AuthSingletonCubit? authSingletonCubit,
  }) : _authSingletonCubit = authSingletonCubit ?? globalLocator<AuthSingletonCubit>();

  @override
  Future<String> read(String path) async {
    String encryptedFileContent = await super.read(path);
    Ciphertext ciphertext = Ciphertext.fromJsonString(encryptedFileContent);
    return _authSingletonCubit.decrypt(ciphertext);
  }

  @override
  Future<void> write(String path, String plaintextValue) async {
    Ciphertext ciphertext = await _authSingletonCubit.encrypt(plaintextValue);
    await super.write(path, ciphertext.toJsonString(prettyPrintBool: true));
  }
}
