import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  group('Tests of FilesystemPath.empty() constructor', () {
    test('Should [return FilesystemPath] with empty path segments', () {
      // Act
      FilesystemPath actualFilesystemPath = const FilesystemPath.empty();

      // Assert
      FilesystemPath expectedFilesystemPath = const FilesystemPath(<String>[]);

      expect(actualFilesystemPath, expectedFilesystemPath);
    });
  });

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

  group('Tests of FilesystemPath.replace()', () {
    test('Should [return FilesystemPath] with replaced path segments', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC');

      // Act
      FilesystemPath actualReplacedFilesystemPath = actualFilesystemPath.replace('directoryA/directoryB', 'directoryX/directoryY');

      // Assert
      FilesystemPath expectedReplacedFilesystemPath = FilesystemPath.fromString('directoryX/directoryY/directoryC');

      expect(actualReplacedFilesystemPath, expectedReplacedFilesystemPath);
    });
  });

  group('Tests of FilesystemPath.pop()', () {
    test('Should [return FilesystemPath] with removed last path segment', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC');

      // Act
      FilesystemPath actualNewFilesystemPath = actualFilesystemPath.pop();

      // Assert
      FilesystemPath expectedNewFilesystemPath = FilesystemPath.fromString('directoryA/directoryB');

      expect(actualNewFilesystemPath, expectedNewFilesystemPath);
    });

    test('Should [return FilesystemPath] with empty path segments if path has only one element', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA');

      // Act
      FilesystemPath actualNewFilesystemPath = actualFilesystemPath.pop();

      // Assert
      FilesystemPath expectedNewFilesystemPath = FilesystemPath.fromString('');

      expect(actualNewFilesystemPath, expectedNewFilesystemPath);
    });

    test('Should [return FilesystemPath] with empty path segments if path is already empty', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('');

      // Act
      FilesystemPath actualNewFilesystemPath = actualFilesystemPath.pop();

      // Assert
      FilesystemPath expectedNewFilesystemPath = FilesystemPath.fromString('');

      expect(actualNewFilesystemPath, expectedNewFilesystemPath);
    });
  });

  group('Tests of FilesystemPath.isSubPathOf()', () {
    test('Should [return TRUE] if [FilesystemPath is DIRECT child] of other FilesystemPath (singleLevelBool == false)', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC');
      FilesystemPath actualParentFilesystemPath = FilesystemPath.fromString('directoryA/directoryB');

      // Act
      bool actualSubPathBool = actualFilesystemPath.isSubPathOf(actualParentFilesystemPath, singleLevelBool: false);

      // Assert
      expect(actualSubPathBool, true);
    });

    test('Should [return TRUE] if [FilesystemPath is NESTED child] of other FilesystemPath (singleLevelBool == false)', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC/directoryD/directoryE');
      FilesystemPath actualParentFilesystemPath = FilesystemPath.fromString('directoryA/directoryB');

      // Act
      bool actualSubPathBool = actualFilesystemPath.isSubPathOf(actualParentFilesystemPath, singleLevelBool: false);

      // Assert
      expect(actualSubPathBool, true);
    });

    test('Should [return FALSE] if [FilesystemPath NOT BELONGS] to other FilesystemPath (singleLevelBool == false)', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/');
      FilesystemPath actualParentFilesystemPath = FilesystemPath.fromString('directoryC/directoryD');

      // Act
      bool actualSubPathBool = actualFilesystemPath.isSubPathOf(actualParentFilesystemPath, singleLevelBool: false);

      // Assert
      expect(actualSubPathBool, false);
    });

    test('Should [return TRUE] if [FilesystemPath is DIRECT child] of other FilesystemPath (singleLevelBool == true)', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC');
      FilesystemPath actualParentFilesystemPath = FilesystemPath.fromString('directoryA/directoryB');

      // Act
      bool actualSubPathBool = actualFilesystemPath.isSubPathOf(actualParentFilesystemPath, singleLevelBool: true);

      // Assert
      expect(actualSubPathBool, true);
    });

    test('Should [return FALSE] if [FilesystemPath is NESTED child] of other FilesystemPath (singleLevelBool == true)', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/directoryC/directoryD/directoryE');
      FilesystemPath actualParentFilesystemPath = FilesystemPath.fromString('directoryA/directoryB');

      // Act
      bool actualSubPathBool = actualFilesystemPath.isSubPathOf(actualParentFilesystemPath, singleLevelBool: true);

      // Assert
      expect(actualSubPathBool, false);
    });

    test('Should [return FALSE] if [FilesystemPath NOT BELONGS] to other FilesystemPath (singleLevelBool == true)', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('directoryA/directoryB/');
      FilesystemPath actualParentFilesystemPath = FilesystemPath.fromString('directoryC/directoryD');

      // Act
      bool actualSubPathBool = actualFilesystemPath.isSubPathOf(actualParentFilesystemPath, singleLevelBool: true);

      // Assert
      expect(actualSubPathBool, false);
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
