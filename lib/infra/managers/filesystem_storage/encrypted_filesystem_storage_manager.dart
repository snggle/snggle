import 'dart:async';

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
    return _authSingletonCubit.decrypt(encryptedFileContent);
  }

  @override
  Future<void> write(String path, String plaintextValue) async {
    String encryptedValue = await _authSingletonCubit.encrypt(plaintextValue);
    await super.write(path, encryptedValue);
  }
}
