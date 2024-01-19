import 'package:equatable/equatable.dart';

class ContainerPathModel extends Equatable {
  final List<String> pathSegments;

  const ContainerPathModel(this.pathSegments);

  factory ContainerPathModel.fromString(String path) {
    List<String> pathSegments = path.split('/');
    return ContainerPathModel(pathSegments);
  }

  String deriveChildPath(String childUuid) {
    List<String> derivedPathSegments = <String>[...pathSegments, childUuid];
    return derivedPathSegments.join('/');
  }

  String get path => pathSegments.join('/');

  String get parentPath {
    List<String> parentPathSegments = <String>[...pathSegments]..removeLast();
    return parentPathSegments.join('/');
  }

  @override
  List<Object?> get props => <Object>[pathSegments];
}
