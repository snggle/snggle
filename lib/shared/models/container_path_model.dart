import 'package:equatable/equatable.dart';

class ContainerPathModel extends Equatable {
  final List<String> pathSegments;

  const ContainerPathModel(this.pathSegments);

  factory ContainerPathModel.fromString(String path) {
    List<String> pathSegments = path.split('/');
    return ContainerPathModel(pathSegments);
  }

  ContainerPathModel deriveChildPath(String childUuid) {
    List<String> derivedPathSegments = <String>[...pathSegments, childUuid];
    return ContainerPathModel(derivedPathSegments);
  }

  String get fullPath => pathSegments.join('/');

  String get parentPath => pathSegments.sublist(0, pathSegments.length - 1).join('/');

  @override
  List<Object?> get props => <Object>[pathSegments];
}
