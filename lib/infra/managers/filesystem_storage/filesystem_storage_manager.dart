import 'dart:async';
import 'dart:io';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_key.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class FilesystemStorageManager {
  final RootDirectoryBuilder _rootDirectoryBuilder = globalLocator<RootDirectoryBuilder>();
  final FilesystemStorageKey _filesystemStorageKey;
  final Completer<Directory> _rootDirectoryCompleter;

  FilesystemStorageManager({
    required FilesystemStorageKey filesystemStorageKey,
  })  : _filesystemStorageKey = filesystemStorageKey,
        _rootDirectoryCompleter = Completer<Directory>() {
    _initStorage();
  }

  Future<String> read(FilesystemPath filesystemPath) async {
    File file = await _getFile(filesystemPath);
    if (await file.exists()) {
      return file.readAsString();
    } else {
      throw ChildKeyNotFoundException();
    }
  }

  Future<void> write(FilesystemPath filesystemPath, String plainTextValue) async {
    File file = await _getFile(filesystemPath);
    await file.create(recursive: true);
    await file.writeAsString(plainTextValue);
  }

  Future<void> move(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    File previousFile = await _getFile(previousFilesystemPath);
    File newFile = await _getFile(newFilesystemPath);
    if (await previousFile.exists() == false) {
      throw ChildKeyNotFoundException();
    }
    if (await newFile.exists() == false) {
      await newFile.create(recursive: true);
    }
    await previousFile.rename(newFile.path);

    Directory parentDirectory = await _getParentDirectory(previousFilesystemPath);
    bool parentDirectoryEmptyBool = parentDirectory.listSync().isEmpty;
    if (parentDirectoryEmptyBool) {
      await parentDirectory.delete();
    }
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    File file = await _getFile(filesystemPath);
    if (await file.exists()) {
      await file.delete();
    } else {
      throw ChildKeyNotFoundException();
    }

    Directory parentDirectory = await _getParentDirectory(filesystemPath);
    bool parentDirectoryEmptyBool = parentDirectory.listSync().isEmpty;
    if (parentDirectoryEmptyBool) {
      await parentDirectory.delete();
    }
  }

  Future<void> _initStorage() async {
    Directory rootDirectory = await _rootDirectoryBuilder();
    _rootDirectoryCompleter.complete(rootDirectory);
  }

  Future<File> _getFile(FilesystemPath filesystemPath) async {
    String absolutePath = await _buildAbsolutePath(relativePath: '${filesystemPath.fullPath}.snggle');
    return File(absolutePath);
  }

  Future<Directory> _getParentDirectory(FilesystemPath filesystemPath) async {
    String absolutePath = await _buildAbsolutePath(relativePath: filesystemPath.parentPath);
    return Directory(absolutePath);
  }

  Future<String> _buildAbsolutePath({required String relativePath}) async {
    Directory rootDirectory = await _rootDirectoryCompleter.future;
    return '${rootDirectory.path}/${_filesystemStorageKey.name}/$relativePath';
  }
}
