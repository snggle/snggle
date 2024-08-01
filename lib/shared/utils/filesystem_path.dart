import 'dart:math';

import 'package:equatable/equatable.dart';

class FilesystemPath extends Equatable {
  final List<String> pathSegments;

  const FilesystemPath(this.pathSegments);

  const FilesystemPath.empty() : pathSegments = const <String>[];

  factory FilesystemPath.fromString(String path) {
    List<String> pathSegments = path.split('/')..removeWhere((String segment) => segment.isEmpty);
    return FilesystemPath(pathSegments);
  }

  FilesystemPath replace(String from, String to) {
    String updatedPath = fullPath.replaceFirst(from, from.isNotEmpty ? to : '$to/');
    return FilesystemPath.fromString(updatedPath);
  }

  FilesystemPath pop() {
    return FilesystemPath(pathSegments.sublist(0, max(pathSegments.length - 1, 0)));
  }

  FilesystemPath add(String segment) {
    return FilesystemPath(<String>[...pathSegments, segment]);
  }

  bool isSubPathOf(FilesystemPath filesystemPath, {bool firstLevelBool = false}) {
    if (firstLevelBool) {
      // Check if the current path is a direct child of the given path
      return parentPath == filesystemPath.fullPath;
    } else {
      // Check if the current path is a any descendant of the given path
      return parentPath.startsWith(filesystemPath.fullPath);
    }
  }

  String get fullPath => pathSegments.join('/');

  String get parentPath => pathSegments.sublist(0, pathSegments.length - 1).join('/');

  @override
  List<Object?> get props => <Object>[pathSegments];
}
