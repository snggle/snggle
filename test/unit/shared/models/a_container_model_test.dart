import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/a_container_model.dart';

void main() {
  group('Tests of AContainerModel.derivePath()', () {
    test('Should [return path] with [childUuid] appended to [pathSegments]', () {
      // Arrange
      _TestContainerModel actualTestContainerModel = const _TestContainerModel(pathSegments: <String>[]);

      // Act
      String actualDerivedPath = actualTestContainerModel.derivePath('a');

      // Assert
      String expectedDerivedPath = 'a';
      expect(actualDerivedPath, expectedDerivedPath);
    });

    test('Should [return path] with [childUuid] appended to [pathSegments]', () {
      // Arrange
      _TestContainerModel actualTestContainerModel = const _TestContainerModel(pathSegments: <String>['a', 'b', 'c']);

      // Act
      String actualDerivedPath = actualTestContainerModel.derivePath('d');

      // Assert
      String expectedDerivedPath = 'a/b/c/d';
      expect(actualDerivedPath, expectedDerivedPath);
    });
  });

  group('Tests of AContainerModel.path getter', () {
    test('Should [return path] with [pathSegments] joined by "/"', () {
      // Arrange
      _TestContainerModel actualTestContainerModel = const _TestContainerModel(pathSegments: <String>[]);

      // Act
      String actualPath = actualTestContainerModel.path;

      // Assert
      String expectedPath = '';
      expect(actualPath, expectedPath);
    });

    test('Should [return path] with [pathSegments] joined by "/"', () {
      // Arrange
      _TestContainerModel actualTestContainerModel = const _TestContainerModel(pathSegments: <String>['a', 'b', 'c']);

      // Act
      String actualPath = actualTestContainerModel.path;

      // Assert
      String expectedPath = 'a/b/c';
      expect(actualPath, expectedPath);
    });
  });
}

class _TestContainerModel extends AContainerModel {
  const _TestContainerModel({required List<String> pathSegments}) : super(pathSegments: pathSegments);

  @override
  List<Object?> get props => <Object>[pathSegments];
}
