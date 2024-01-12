import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/container_path_model.dart';

void main() {
  group('Tests of ContainerPathModel.fromString() constructor', (){
    test('Should [return ContainerPathModel] with parsed path segments', (){
      // Arrange
      String actualPath = 'directoryA/directoryB/directoryC';

      // Act
      ContainerPathModel actualContainerPathModel = ContainerPathModel.fromString(actualPath);

      // Assert
      ContainerPathModel expectedContainerPathModel = const ContainerPathModel(<String>['directoryA', 'directoryB', 'directoryC']);

      expect(actualContainerPathModel, expectedContainerPathModel);
    });
  });

  group('Tests of ContainerPathModel.deriveChildPath()', (){
    test('Should [return ContainerPathModel] with added child path segment', (){
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('directoryA/directoryB');
      String childUuid = 'directoryC';

      // Act
      ContainerPathModel actualContainerPathModel = containerPathModel.deriveChildPath(childUuid);

      // Assert
      ContainerPathModel expectedContainerPathModel = const ContainerPathModel(<String>['directoryA', 'directoryB', 'directoryC']);

      expect(actualContainerPathModel, expectedContainerPathModel);
    });
  });

  group('Tests of ContainerPathModel.fullPath getter', (){
    test('Should [return String] with joined path segments', (){
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('directoryA/directoryB/directoryC');

      // Act
      String actualFullPath = containerPathModel.fullPath;

      // Assert
      String expectedFullPath = 'directoryA/directoryB/directoryC';

      expect(actualFullPath, expectedFullPath);
    });
  });

  group('Tests of ContainerPathModel.parentPath getter', (){
    test('Should [return String] with parent path segments', (){
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('directoryA/directoryB/directoryC');

      // Act
      String actualParentPath = containerPathModel.parentPath;

      // Assert
      String expectedParentPath = 'directoryA/directoryB';

      expect(actualParentPath, expectedParentPath);
    });
  });
}