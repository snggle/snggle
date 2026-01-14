import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  group('Tests of EntryDetailsEditablePageCubit process (create mode)', () {
    late EntryDetailsEditablePageCubit actualEntryDetailsEditablePageCubit;

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
    });

    test(
        'Should [emit EntryDetailsEditablePageState] with [loadingBool == TRUE]',
        () {
      // Assert
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState.loading());
    });

    test('Should [initialize default entry name] if [database EMPTY]',
        () async {
      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState());
      expect(actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          'Entry');
    });

    test('Should [initialize next entry name] if [database NOT EMPTY]',
        () async {
      // Arrange
      await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
      );

      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState());
      expect(actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          'Entry 1');
    });

    test(
        'Should [return NULL] and [emit EntryDetailsEditablePageState] with [entryNameEmptyBool == TRUE] if [name EMPTY]',
        () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text =
          '   ';

      // Act
      EntryModel? actualEntryModel =
          await actualEntryDetailsEditablePageCubit.save();

      // Assert
      expect(actualEntryModel, null);
      expect(
        actualEntryDetailsEditablePageCubit.state,
        const EntryDetailsEditablePageState(entryNameEmptyBool: true),
      );
    });

    test('Should [return EntryModel] and save entry with secrets', () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text =
          'ENTRY 0';
      actualEntryDetailsEditablePageCubit.websiteTextEditingController.text =
          'https://snggle.com';
      actualEntryDetailsEditablePageCubit.emailTextEditingController.text =
          'entry1@example.com';
      actualEntryDetailsEditablePageCubit.usernameTextEditingController.text =
          'entry_user_1';
      actualEntryDetailsEditablePageCubit.passwordTextEditingController.text =
          'entry_password_1';

      // Act
      EntryModel? actualEntryModel =
          await actualEntryDetailsEditablePageCubit.save();
      EntrySecretsModel actualEntrySecrets =
          await globalLocator<SecretsService>().get(
        FilesystemPath.fromString('entries/entry1'),
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryModel expectedEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'ENTRY 0',
        website: 'https://snggle.com',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
      );
      EntrySecretsModel expectedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'entry1@example.com',
        username: 'entry_user_1',
        password: 'entry_password_1',
      );

      expect(actualEntryModel, expectedEntryModel);
      expect(actualEntrySecrets, expectedEntrySecrets);
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState());
    });

    tearDown(testDatabase.close);
  });

  group('Tests of EntryDetailsEditablePageCubit process (edit mode)', () {
    late EntryDetailsEditablePageCubit actualEntryDetailsEditablePageCubit;
    late EntryModel actualEntryModel;

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryModel =
          await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
      );
      globalLocator<PasswordController>().addPassword(
        PasswordModel.defaultPassword(),
        actualEntryModel.filesystemPath,
      );

      actualEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
    });

    test(
        'Should [emit EntryDetailsEditablePageState] with [loadingBool == TRUE]',
        () {
      // Assert
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState.loading());
    });

    test('Should [initialize controllers] with entry values', () async {
      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState());
      expect(actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          'ENTRY 0');
      expect(
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          'https://snggle.com');
      expect(
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          'entry1@example.com');
      expect(
          actualEntryDetailsEditablePageCubit
              .usernameTextEditingController.text,
          'entry_user_1');
      expect(
          actualEntryDetailsEditablePageCubit
              .passwordTextEditingController.text,
          'entry_password_1');
    });

    test('Should [return updated EntryModel] and update entry with secrets',
        () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text =
          'UPDATED ENTRY 0';
      actualEntryDetailsEditablePageCubit.websiteTextEditingController.text =
          'https://updated-entry1.example';
      actualEntryDetailsEditablePageCubit.emailTextEditingController.text =
          'updated-entry1@example.com';
      actualEntryDetailsEditablePageCubit.usernameTextEditingController.text =
          '';
      actualEntryDetailsEditablePageCubit.passwordTextEditingController.text =
          '';

      // Act
      EntryModel? actualUpdatedEntryModel =
          await actualEntryDetailsEditablePageCubit.save();
      EntryModel actualSavedEntryModel =
          await globalLocator<EntriesService>().getById(actualEntryModel.id);
      EntrySecretsModel actualSavedEntrySecrets =
          await globalLocator<SecretsService>().get(
        actualEntryModel.filesystemPath,
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryModel expectedUpdatedEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'UPDATED ENTRY 0',
        website: 'https://updated-entry1.example',
        emailExistsBool: true,
        usernameExistsBool: false,
        passwordExistsBool: false,
      );
      EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'updated-entry1@example.com',
        username: '',
        password: '',
      );

      expect(actualUpdatedEntryModel, expectedUpdatedEntryModel);
      expect(actualSavedEntryModel, expectedUpdatedEntryModel);
      expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
      expect(actualEntryDetailsEditablePageCubit.state,
          const EntryDetailsEditablePageState());
    });

    tearDown(testDatabase.close);
  });
}
