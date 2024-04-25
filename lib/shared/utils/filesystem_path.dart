import 'package:equatable/equatable.dart';

class FilesystemPath extends Equatable {
  final List<String> pathSegments;

  const FilesystemPath(this.pathSegments);

  factory FilesystemPath.fromString(String path) {
    List<String> pathSegments = path.split('/');
    return FilesystemPath(pathSegments);
  }

  FilesystemPath deriveChildPath(String childUuid) {
    List<String> derivedPathSegments = <String>[...pathSegments, childUuid];
    return FilesystemPath(derivedPathSegments);
  }

  String get fullPath => pathSegments.join('/');

  String get parentPath => pathSegments.sublist(0, pathSegments.length - 1).join('/');

  @override
  List<Object?> get props => <Object>[pathSegments];
}
