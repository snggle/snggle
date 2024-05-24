import 'package:equatable/equatable.dart';

class FilesystemPath extends Equatable {
  final List<String> pathSegments;

  const FilesystemPath(this.pathSegments);

  const FilesystemPath.empty() : pathSegments = const <String>[];

  factory FilesystemPath.fromString(String path) {
    List<String> pathSegments = path.split('/')..removeWhere((String segment) => segment.isEmpty);
    return FilesystemPath(pathSegments);
  }

  bool isSubPathOf(FilesystemPath filesystemPath, {bool singleLevelBool = false}) {
    if (singleLevelBool) {
      // Check if the current path is a direct child of the given path
      return filesystemPath.fullPath == parentPath;
    } else {
      // Check if the current path is a any descendant of the given path
      return fullPath.startsWith(filesystemPath.fullPath);
    }
  }

  String get fullPath => pathSegments.join('/');

  String get parentPath => pathSegments.sublist(0, pathSegments.length - 1).join('/');

  @override
  List<Object?> get props => <Object>[pathSegments];
}
