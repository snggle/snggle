import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_preview_item_type.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  group('Tests of EntryModel.name getter', () {
    test('Should [return entry name] if [name EXISTS]', () {
      // Arrange
      EntryModel actualEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'TEST ENTRY',
        website: '',
      );

      // Act
      String actualName = actualEntryModel.name;

      // Assert
      String expectedName = 'TEST ENTRY';

      expect(actualName, expectedName);
    });

    test('Should [return default entry name] if [name NOT EXISTS]', () {
      // Arrange
      EntryModel actualEntryModel = EntryModel(
        id: 3,
        encryptedBool: false,
        pinnedBool: false,
        index: 2,
        filesystemPath: FilesystemPath.fromString('entries/group1/entry3'),
        name: null,
        website: '',
      );

      // Act
      String actualName = actualEntryModel.name;

      // Assert
      String expectedName = 'ENTRY 2';

      expect(actualName, expectedName);
    });
  });

  group('Tests of EntryModel.previewItems getter', () {
    test('Should [return preview items] in email, username, password order', () {
      // Arrange
      EntryModel actualEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'ENTRY 0',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
        website: '',
      );

      // Act
      List<EntryPreviewItemType> actualPreviewItems = actualEntryModel.previewItems;

      // Assert
      List<EntryPreviewItemType> expectedPreviewItems = <EntryPreviewItemType>[
        EntryPreviewItemType.email,
        EntryPreviewItemType.username,
        EntryPreviewItemType.password,
      ];

      expect(actualPreviewItems, expectedPreviewItems);
    });

    test('Should [return EMPTY list] if [no preview items EXIST]', () {
      // Arrange
      EntryModel actualEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'ENTRY 0',
        website: '',
      );

      // Act
      List<EntryPreviewItemType> actualPreviewItems = actualEntryModel.previewItems;

      // Assert
      List<EntryPreviewItemType> expectedPreviewItems = <EntryPreviewItemType>[];

      expect(actualPreviewItems, expectedPreviewItems);
    });
  });
}
