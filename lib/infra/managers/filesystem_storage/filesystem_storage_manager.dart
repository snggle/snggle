import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';

typedef RootDirectoryBuilder = FutureOr<Directory> Function();

class FilesystemStorageManager {
  final Completer<Directory> _libraryDirectoryCompleter = Completer<Directory>();
  final DatabaseParentKey _databaseParentKey;
  final RootDirectoryBuilder _rootDirectoryBuilder;

  FilesystemStorageManager({
    required DatabaseParentKey databaseParentKey,
    Future<Directory> Function()? rootDirectory,
  })  : _databaseParentKey = databaseParentKey,
        _rootDirectoryBuilder = rootDirectory ?? getApplicationSupportDirectory {
    _initStorage();
  }

  Future<String> read(String path) async {
    File file = await _getFile(path);
    if (await file.exists()) {
      return file.readAsString();
    } else {
      throw ChildKeyNotFoundException();
    }
  }

  Future<void> write(String path, String plaintextValue) async {
    File file = await _getFile(path);
    await file.create(recursive: true);
    await file.writeAsString(plaintextValue);
  }

  Future<void> delete(String path) async {
    File file = await _getFile(path);
    Directory directory = await _getDirectory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    if (await file.exists()) {
      await file.delete();
    } else {
      throw ChildKeyNotFoundException();
    }
  }

  Future<void> _initStorage() async {
    Directory rootDirectory = await _rootDirectoryBuilder();
    _libraryDirectoryCompleter.complete(rootDirectory);
  }

  Future<Directory> _getDirectory(String path) async {
    String absolutePath = await _buildAbsolutePath(path, extension: '');
    return Directory(absolutePath);
  }

  Future<File> _getFile(String path) async {
    String absolutePath = await _buildAbsolutePath(path);
    return File(absolutePath);
  }

  Future<String> _buildAbsolutePath(String path, {String extension = '.snggle'}) async {
    Directory directory = await _libraryDirectoryCompleter.future;
    return '${directory.path}/${_databaseParentKey.name}/$path${extension}';
  }
}
