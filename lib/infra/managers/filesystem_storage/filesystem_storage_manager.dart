import 'dart:async';
import 'dart:io';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/exceptions/invalid_filesystem_path_exception.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_root_dir.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class FilesystemStorageManager {
  final RootDirectoryBuilder _rootDirectoryBuilder = globalLocator<RootDirectoryBuilder>();
  final FilesystemStorageRootDir _filesystemStorageRootDir;
  final Completer<Directory> _rootDirectoryCompleter;

  FilesystemStorageManager({
    required this._filesystemStorageRootDir,
  }) : _rootDirectoryCompleter = Completer<Directory>() {
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

    await _deleteEmptyParentDirectories(previousFilesystemPath);
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    File file = await _getFile(filesystemPath);
    if (await file.exists()) {
      await file.delete();
    } else {
      throw ChildKeyNotFoundException();
    }

    await _deleteEmptyParentDirectories(filesystemPath);
  }

  Future<bool> exists(FilesystemPath filesystemPath) async {
    File file = await _getFile(filesystemPath);
    return file.exists();
  }

  Future<void> _initStorage() async {
    Directory rootDirectory = await _rootDirectoryBuilder();
    _rootDirectoryCompleter.complete(rootDirectory);
  }

  Future<File> _getFile(FilesystemPath filesystemPath) async {
    if (filesystemPath.storageTabPathBool) {
      throw InvalidFilesystemPathException();
    }

    String absolutePath = await _buildAbsolutePath(
      relativePath: '${filesystemPath.fullPath}.snggle',
    );

    return File(absolutePath);
  }

  Future<void> _deleteEmptyParentDirectories(FilesystemPath filesystemPath) async {
    Directory parentDirectory = await _getParentDirectory(filesystemPath);

    bool parentDirectoryDeletedBool = await _deleteDirectoryIfEmpty(parentDirectory);
    bool tabDirectoryDeletedBool = parentDirectoryDeletedBool && filesystemPath.firstLevelItemBool;

    if (tabDirectoryDeletedBool) {
      Directory rootDirectory = parentDirectory.parent;
      await _deleteDirectoryIfEmpty(rootDirectory);
    }
  }

  Future<bool> _deleteDirectoryIfEmpty(Directory directory) async {
    bool directoryEmptyBool = directory.listSync().isEmpty;

    if (directoryEmptyBool) {
      await directory.delete();
    }

    return directoryEmptyBool;
  }

  Future<Directory> _getParentDirectory(FilesystemPath filesystemPath) async {
    String absolutePath = await _buildAbsolutePath(relativePath: filesystemPath.parentPath);
    return Directory(absolutePath);
  }

  Future<String> _buildAbsolutePath({required String relativePath}) async {
    Directory rootDirectory = await _rootDirectoryCompleter.future;
    return '${rootDirectory.path}/${_filesystemStorageRootDir.name}/$relativePath';
  }
}
