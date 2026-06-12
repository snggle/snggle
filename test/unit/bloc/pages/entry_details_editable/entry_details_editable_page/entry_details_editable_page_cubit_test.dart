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

// ignore_for_file: cascade_invocations
void main() {
  final TestDatabase testDatabase = TestDatabase();

  group('Tests of EntryDetailsEditablePageCubit process (create mode)', () {
    late EntryDetailsEditablePageCubit actualEntryDetailsEditablePageCubit;

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.fullDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
    });

    test('Should [emit EntryDetailsEditablePageState] with [loadingBool == TRUE]', () {
      // Assert
      expect(actualEntryDetailsEditablePageCubit.state, const EntryDetailsEditablePageState.loading());
    });

    test('Should [initialize next available entry name] from seeded database', () async {
      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();

      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(
        <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsEditablePageCubit.nameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.emailTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
      );
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [initialize next entry name] if [database NOT EMPTY]', () async {
      // Arrange
      await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
        '',
      );

      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();

      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(
        <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsEditablePageCubit.nameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
      );
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [return NULL] and [emit EntryDetailsEditablePageState] with [entryNameEmptyBool == TRUE] if [name EMPTY]', () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text = '   ';

      // Act
      EntryModel? actualEntryModel = await actualEntryDetailsEditablePageCubit.save();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();
      expectedEntryDetailsEditablePageCubit.nameTextEditingController.text = '   ';

      expect(actualEntryModel, null);
      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text, expectedEntryDetailsEditablePageCubit.nameTextEditingController.text);
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [return EntryModel] while seeded [entries/entry1] secrets remain unchanged', () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text = 'ENTRY 0';
      actualEntryDetailsEditablePageCubit.websiteTextEditingController.text = 'https://snggle.com';
      actualEntryDetailsEditablePageCubit.emailTextEditingController.text = 'entry1@example.com';
      actualEntryDetailsEditablePageCubit.usernameTextEditingController.text = 'entry_user_1';
      actualEntryDetailsEditablePageCubit.passwordTextEditingController.text = 'entry_password_1';

      // Act
      EntryModel? actualEntryModel = await actualEntryDetailsEditablePageCubit.save();
      EntrySecretsModel actualEntrySecrets = await globalLocator<SecretsService>().get(
        FilesystemPath.fromString('entries/entry1'),
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();
      expectedEntryDetailsEditablePageCubit.nameTextEditingController.text = 'ENTRY 0';
      expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text = 'https://snggle.com';
      expectedEntryDetailsEditablePageCubit.emailTextEditingController.text = 'entry1@example.com';
      expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text = 'entry_user_1';
      expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text = 'entry_password_1';

      EntryModel expectedEntryModel = EntryModel(
        id: 4,
        encryptedBool: false,
        pinnedBool: false,
        index: 3,
        filesystemPath: FilesystemPath.fromString('entries/entry4'),
        name: 'ENTRY 0',
        website: 'https://snggle.com',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
        totpExistsBool: false,
      );
      EntrySecretsModel expectedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'entry1@example.com',
        username: 'entry_user_1',
        password: 'entry_password_1',
        totpSecret: 'wxx5vbewifu4m4hljgilbewm',
      );

      expect(actualEntryModel, expectedEntryModel);
      expect(actualEntrySecrets, expectedEntrySecrets);
      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(
        <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsEditablePageCubit.nameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.emailTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
      );
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [normalize TOTP secret] and [return EntryModel] with [totpExistsBool == TRUE]', () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text = 'ENTRY 0';
      actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXP';

      // Act
      EntryModel? actualEntryModel = await actualEntryDetailsEditablePageCubit.save();
      EntrySecretsModel actualEntrySecrets = await globalLocator<SecretsService>().get(
        FilesystemPath.fromString('entries/entry1'),
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();
      expectedEntryDetailsEditablePageCubit.nameTextEditingController.text = 'ENTRY 0';
      expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text = 'jbswy3dpehpk3pxp';

      EntryModel expectedEntryModel = EntryModel(
        id: 4,
        encryptedBool: false,
        pinnedBool: false,
        index: 3,
        filesystemPath: FilesystemPath.fromString('entries/entry4'),
        name: 'ENTRY 0',
        website: '',
        emailExistsBool: false,
        usernameExistsBool: false,
        passwordExistsBool: false,
        totpExistsBool: true,
      );
      EntrySecretsModel expectedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'entry1@example.com',
        username: 'entry_user_1',
        password: 'entry_password_1',
        totpSecret: 'wxx5vbewifu4m4hljgilbewm',
      );

      expect(actualEntryModel, expectedEntryModel);
      expect(actualEntrySecrets, expectedEntrySecrets);
      expect(
        actualEntryDetailsEditablePageCubit.state,
        const EntryDetailsEditablePageState(loadingBool: false, totpExistsBool: true),
      );
      expect(
        <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsEditablePageCubit.nameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.emailTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
      );
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    tearDown(testDatabase.close);
  });

  group('Tests of EntryDetailsEditablePageCubit process (edit mode)', () {
    late EntryDetailsEditablePageCubit actualEntryDetailsEditablePageCubit;
    late EntryModel actualEntryModel;

    Future<void> initializeEditableCubit({required bool withTotp}) async {
      actualEntryModel = await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
        withTotp ? 'jbswy3dpehpk3pxp' : '',
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
    }

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      await initializeEditableCubit(withTotp: false);
    });

    test('Should [emit EntryDetailsEditablePageState] with [loadingBool == TRUE]', () {
      // Assert
      expect(actualEntryDetailsEditablePageCubit.state, const EntryDetailsEditablePageState.loading());
    });

    test('Should [initialize controllers] with entry values', () async {
      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();

      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(
        <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsEditablePageCubit.nameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.emailTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
      );
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [return updated EntryModel] and update entry with secrets', () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.nameTextEditingController.text = 'UPDATED ENTRY 0';
      actualEntryDetailsEditablePageCubit.websiteTextEditingController.text = 'https://updated-entry1.example';
      actualEntryDetailsEditablePageCubit.emailTextEditingController.text = 'updated-entry1@example.com';
      actualEntryDetailsEditablePageCubit.usernameTextEditingController.text = '';
      actualEntryDetailsEditablePageCubit.passwordTextEditingController.text = '';

      // Act
      EntryModel? actualUpdatedEntryModel = await actualEntryDetailsEditablePageCubit.save();
      EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
      EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
        actualEntryModel.filesystemPath,
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();
      expectedEntryDetailsEditablePageCubit.nameTextEditingController.text = 'UPDATED ENTRY 0';
      expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text = 'https://updated-entry1.example';
      expectedEntryDetailsEditablePageCubit.emailTextEditingController.text = 'updated-entry1@example.com';
      expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text = '';
      expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text = '';

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
        totpExistsBool: false,
      );
      EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'updated-entry1@example.com',
        username: '',
        password: '',
        totpSecret: '',
      );

      expect(actualUpdatedEntryModel, expectedUpdatedEntryModel);
      expect(actualSavedEntryModel, expectedUpdatedEntryModel);
      expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(
        <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsEditablePageCubit.nameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.emailTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ],
      );
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [keep TOTP EMPTY] when [restorePreviousTotp()] has empty backup', () async {
      // Arrange
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit
        ..startTotpEditingSession()
        ..removeTotp();

      // Act
      actualEntryDetailsEditablePageCubit.restorePreviousTotp();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();
      expectedEntryDetailsEditablePageCubit
        ..startTotpEditingSession()
        ..removeTotp();
      expectedEntryDetailsEditablePageCubit.restorePreviousTotp();

      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text);
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [initialize TOTP controller] and mark [preexistingTotpBool == TRUE]', () async {
      // Arrange
      await initializeEditableCubit(withTotp: true);

      // Act
      await actualEntryDetailsEditablePageCubit.init();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();

      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text);
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [update saved TOTP secret] and [return EntryModel] with [totpExistsBool == TRUE]', () async {
      // Arrange
      await initializeEditableCubit(withTotp: true);
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXQ';

      // Act
      EntryModel? actualUpdatedEntryModel = await actualEntryDetailsEditablePageCubit.save();
      EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
      EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
        actualEntryModel.filesystemPath,
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();

      expect(actualUpdatedEntryModel?.totpExistsBool, true);
      expect(actualSavedEntryModel.totpExistsBool, true);
      expect(actualSavedEntrySecrets.totpSecret, 'jbswy3dpehpk3pxq');
      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text);
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    test('Should [restore previous TOTP] after temporary removal', () async {
      // Arrange
      await initializeEditableCubit(withTotp: true);
      await actualEntryDetailsEditablePageCubit.init();
      actualEntryDetailsEditablePageCubit
        ..startTotpEditingSession()
        ..removeTotp();

      // Act
      actualEntryDetailsEditablePageCubit.restorePreviousTotp();

      // Assert
      EntryDetailsEditablePageCubit expectedEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
      addTearDown(expectedEntryDetailsEditablePageCubit.close);
      await expectedEntryDetailsEditablePageCubit.init();
      expectedEntryDetailsEditablePageCubit
        ..startTotpEditingSession()
        ..removeTotp();
      expectedEntryDetailsEditablePageCubit.restorePreviousTotp();

      expect(actualEntryDetailsEditablePageCubit.state, expectedEntryDetailsEditablePageCubit.state);
      expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
          expectedEntryDetailsEditablePageCubit.totpSecretTextEditingController.text);
      expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, expectedEntryDetailsEditablePageCubit.preexistingTotpBool);
    });

    tearDown(testDatabase.close);
  });
}
