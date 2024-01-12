import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  group('Tests of FilesystemPath.fromString() constructor', () {
    test('Should [return FilesystemPath] with parsed path segments', () {
      // Arrange
      String actualPath = 'directoryA/directoryB/directoryC';

      // Act
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString(actualPath);

      // Assert
      FilesystemPath expectedFilesystemPath = const FilesystemPath(<String>['directoryA', 'directoryB', 'directoryC']);

      expect(actualFilesystemPath, expectedFilesystemPath);
    });
  });

  group('Tests of FilesystemPath.deriveChildPath()', () {
    test('Should [return FilesystemPath] with added child path segment', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB');
      String childUuid = 'directoryC';

      // Act
      FilesystemPath actualChildFilesystemPath = actualFilesystemPath.deriveChildPath(childUuid);

      // Assert
      FilesystemPath expectedChildFilesystemPath = const FilesystemPath(<String>['directoryA', 'directoryB', 'directoryC']);

      expect(actualChildFilesystemPath, expectedChildFilesystemPath);
    });
  });

  group('Tests of FilesystemPath.fullPath getter', () {
    test('Should [return String] with joined path segments', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC');

      // Act
      String actualFullPath = actualFilesystemPath.fullPath;

      // Assert
      String expectedFullPath = 'directoryA/directoryB/directoryC';

      expect(actualFullPath, expectedFullPath);
    });
  });

  group('Tests of FilesystemPath.parentPath getter', () {
    test('Should [return String] with parent path segments', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC');

      // Act
      String actualParentPath = actualFilesystemPath.parentPath;

      // Assert
      String expectedParentPath = 'directoryA/directoryB';

      expect(actualParentPath, expectedParentPath);
    });
  });
}
