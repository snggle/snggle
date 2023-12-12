import 'package:equatable/equatable.dart';

abstract class AContainerModel extends Equatable {
  final List<String> pathSegments;

  const AContainerModel({required this.pathSegments});

  String derivePath(String childUuid) {
    List<String> derivedPathSegments = <String>[...pathSegments, childUuid];
    return derivedPathSegments.join('/');
  }

  String get path => pathSegments.join('/');
}
