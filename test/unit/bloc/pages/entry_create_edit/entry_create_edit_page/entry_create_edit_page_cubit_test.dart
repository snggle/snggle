import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/entry_create_edit/entry_page_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  group('Tests of EntryCreateEditPageCubit process (create mode)', () {
    late EntryCreateEditPageCubit actualEntryCreateEditPageCubit;

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryCreateEditPageCubit = EntryCreateEditPageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.create,
      );
    });

    test('Should [emit EntryCreateEditPageState] with [loadingBool == TRUE]', () {
      // Assert
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState.loading());
    });

    test('Should [initialize default entry name] if [database EMPTY]', () async {
      // Act
      await actualEntryCreateEditPageCubit.init();

      // Assert
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
      expect(actualEntryCreateEditPageCubit.nameTextEditingController.text, 'Entry');
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
      await actualEntryCreateEditPageCubit.init();

      // Assert
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
      expect(actualEntryCreateEditPageCubit.nameTextEditingController.text, 'Entry 1');
    });

    test('Should [return NULL] and [emit EntryCreateEditPageState] with [entryNameEmptyBool == TRUE] if [name EMPTY]', () async {
      // Arrange
      await actualEntryCreateEditPageCubit.init();
      actualEntryCreateEditPageCubit.nameTextEditingController.text = '   ';

      // Act
      EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();

      // Assert
      expect(actualEntryModel, null);
      expect(
        actualEntryCreateEditPageCubit.state,
        const EntryCreateEditPageState(entryNameEmptyBool: true),
      );
    });

    group('Tests of email validation on save()', () {
      test('Should [emit EntryCreateEditPageState] with [emailInvalidBool == TRUE] if [EMAIL HAS NO @ CHARACTER]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.emailTextEditingController.text = 'user+tag#mail.example.co.uk';

        // Act
        EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();

        // Assert
        expect(actualEntryModel, null);
        expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState(emailInvalidBool: true));
      });

      test('Should [emit EntryCreateEditPageState] with [emailInvalidBool == TRUE] if [EMAIL ENDS WITH @ CHARACTER]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.emailTextEditingController.text = 'user+tag@mail.example.co.uk@';

        // Act
        EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();

        // Assert
        expect(actualEntryModel, null);
        expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState(emailInvalidBool: true));
      });

      test('Should [emit EntryCreateEditPageState] with [emailInvalidBool == FALSE] if [EMAIL IS CORRECT AND CONTAINS TAG AND SUBDOMAIN]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.emailTextEditingController.text = 'user+tag@mail.example.co.uk';

        // Act
        EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();

        // Assert
        expect(actualEntryModel, isNotNull);
        expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
      });

      test('Should [emit EntryCreateEditPageState] with [emailInvalidBool == FALSE] if [EMAIL EMPTY]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.emailTextEditingController.text = '';

        // Act
        EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();

        // Assert
        expect(actualEntryModel, isNotNull);
        expect(actualEntryModel!.emailExistsBool, false);
        expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
      });
    });

    test('Should [return EntryModel] and save entry with secrets', () async {
      // Arrange
      await actualEntryCreateEditPageCubit.init();
      actualEntryCreateEditPageCubit.nameTextEditingController.text = 'ENTRY 0';
      actualEntryCreateEditPageCubit.websiteTextEditingController.text = 'https://snggle.com';
      actualEntryCreateEditPageCubit.emailTextEditingController.text = 'entry1@example.com';
      actualEntryCreateEditPageCubit.usernameTextEditingController.text = 'entry_user_1';
      actualEntryCreateEditPageCubit.passwordTextEditingController.text = 'entry_password_1';

      // Act
      EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();
      EntrySecretsModel actualEntrySecrets = await globalLocator<SecretsService>().get(
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
        totpSecret: '',
      );

      expect(actualEntryModel, expectedEntryModel);
      expect(actualEntrySecrets, expectedEntrySecrets);
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
    });

    group('Tests of EntryCreateEditPageCubit.save() with TOTP', () {
      test('Should [normalize and persist TOTP secret] if [secret VALID]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXP';

        // Act
        EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();
        EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(1);
        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          FilesystemPath.fromString('entries/entry1'),
          PasswordModel.defaultPassword(),
        );

        // Assert
        EntryModel expectedEntryModel = EntryModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'Entry',
          index: 0,
          website: '',
          emailExistsBool: false,
          usernameExistsBool: false,
          passwordExistsBool: false,
          totpExistsBool: true,
        );
        EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          email: '',
          username: '',
          password: '',
          totpSecret: 'jbswy3dpehpk3pxp',
        );
        const EntryCreateEditPageState expectedEntryCreateEditPageState = EntryCreateEditPageState(totpExistsBool: true);

        expect(actualEntryModel, expectedEntryModel);
        expect(actualSavedEntryModel, expectedEntryModel);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryCreateEditPageCubit.state, expectedEntryCreateEditPageState);
        expect(actualEntryCreateEditPageCubit.totpSecretTextEditingController.text, 'jbswy3dpehpk3pxp');
      });

      test('Should [reject the save without creating an entry] if [TOTP secret INVALID]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.totpSecretTextEditingController.text = '0000';

        // Act
        EntryModel? actualEntryModel = await actualEntryCreateEditPageCubit.save();
        int actualLastEntryIndex = await globalLocator<EntriesService>().getLastIndex();

        // Assert
        const EntryCreateEditPageState expectedEntryCreateEditPageState = EntryCreateEditPageState(
          totpExistsBool: true,
          totpInvalidBool: true,
        );

        expect(actualEntryModel, isNull);
        expect(actualLastEntryIndex, -1);
        expect(actualEntryCreateEditPageCubit.state, expectedEntryCreateEditPageState);
      });
    });
    tearDown(() async {
      await actualEntryCreateEditPageCubit.close();
      await testDatabase.close();
    });
  });

  group('Tests of EntryCreateEditPageCubit process (edit mode)', () {
    late EntryCreateEditPageCubit actualEntryCreateEditPageCubit;
    late EntryModel actualEntryModel;

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryModel = await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
        '',
      );
      globalLocator<PasswordController>().addPassword(
        PasswordModel.defaultPassword(),
        actualEntryModel.filesystemPath,
      );

      actualEntryCreateEditPageCubit = EntryCreateEditPageCubit(
        parentFilesystemPath: actualEntryModel.filesystemPath,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.edit,
      );
    });

    test('Should [emit EntryCreateEditPageState] with [loadingBool == TRUE]', () {
      // Assert
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState.loading());
    });

    test('Should [initialize controllers] with entry values', () async {
      // Act
      await actualEntryCreateEditPageCubit.init();

      // Assert
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
      expect(actualEntryCreateEditPageCubit.nameTextEditingController.text, 'ENTRY 0');
      expect(actualEntryCreateEditPageCubit.websiteTextEditingController.text, 'https://snggle.com');
      expect(actualEntryCreateEditPageCubit.emailTextEditingController.text, 'entry1@example.com');
      expect(actualEntryCreateEditPageCubit.usernameTextEditingController.text, 'entry_user_1');
      expect(actualEntryCreateEditPageCubit.passwordTextEditingController.text, 'entry_password_1');
      expect(actualEntryCreateEditPageCubit.totpSecretTextEditingController.text, '');
    });

    test('Should [return updated EntryModel] and update entry with secrets', () async {
      // Arrange
      await actualEntryCreateEditPageCubit.init();
      actualEntryCreateEditPageCubit.nameTextEditingController.text = 'UPDATED ENTRY 0';
      actualEntryCreateEditPageCubit.websiteTextEditingController.text = 'https://updated-entry1.example';
      actualEntryCreateEditPageCubit.emailTextEditingController.text = 'updated-entry1@example.com';
      actualEntryCreateEditPageCubit.usernameTextEditingController.text = '';
      actualEntryCreateEditPageCubit.passwordTextEditingController.text = '';

      // Act
      EntryModel? actualUpdatedEntryModel = await actualEntryCreateEditPageCubit.save();
      EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
      EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
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
        totpSecret: '',
      );

      expect(actualUpdatedEntryModel, expectedUpdatedEntryModel);
      expect(actualSavedEntryModel, expectedUpdatedEntryModel);
      expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
      expect(actualEntryCreateEditPageCubit.state, const EntryCreateEditPageState());
    });

    test('Should [clear the draft TOTP secret] if [the editing session has an EMPTY backup]', () async {
      // Arrange
      await actualEntryCreateEditPageCubit.init();
      actualEntryCreateEditPageCubit
        ..startTotpEditingSession()
        ..totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXP';

      // Act
      // ignore: cascade_invocations
      actualEntryCreateEditPageCubit.restorePreviousTotp();

      // Assert
      const EntryCreateEditPageState expectedEntryCreateEditPageState = EntryCreateEditPageState();

      expect(actualEntryCreateEditPageCubit.state, expectedEntryCreateEditPageState);
      expect(actualEntryCreateEditPageCubit.totpSecretTextEditingController.text, '');
      expect(actualEntryCreateEditPageCubit.shouldConfirmTotpRemoval(), false);
    });

    tearDown(() async {
      await actualEntryCreateEditPageCubit.close();
      await testDatabase.close();
    });
  });

  group('Tests of EntryCreateEditPageCubit process (edit mode with TOTP)', () {
    late EntryCreateEditPageCubit actualEntryCreateEditPageCubit;
    late EntryModel actualEntryModel;

    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.fullDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryModel = await globalLocator<EntriesService>().getById(1);
      globalLocator<PasswordController>().addPassword(
        PasswordModel.defaultPassword(),
        actualEntryModel.filesystemPath,
      );

      actualEntryCreateEditPageCubit = EntryCreateEditPageCubit(
        parentFilesystemPath: actualEntryModel.filesystemPath,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.edit,
      );
    });

    tearDown(() async {
      await actualEntryCreateEditPageCubit.close();
      await testDatabase.close();
    });

    group('Tests of EntryCreateEditPageCubit.init()', () {
      test('Should [load the seeded TOTP secret] if [the entry has TOTP enabled]', () async {
        // Act
        await actualEntryCreateEditPageCubit.init();

        // Assert
        const EntryCreateEditPageState expectedEntryCreateEditPageState = EntryCreateEditPageState(totpExistsBool: true);

        expect(actualEntryCreateEditPageCubit.state, expectedEntryCreateEditPageState);
        expect(actualEntryCreateEditPageCubit.totpSecretTextEditingController.text, 'wxx5vbewifu4m4hljgilbewm');
        expect(actualEntryCreateEditPageCubit.shouldConfirmTotpRemoval(), false);
      });
    });

    group('Tests of EntryCreateEditPageCubit.save()', () {
      test('Should [overwrite the saved TOTP secret] if [the replacement secret is VALID]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXQ';

        // Act
        EntryModel? actualUpdatedEntryModel = await actualEntryCreateEditPageCubit.save();
        EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        // Assert
        EntryModel expectedEntryModel = EntryModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'ENTRY 0',
          index: 0,
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          totpExistsBool: true,
        );
        EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          email: 'entry1@example.com',
          username: 'entry_user_1',
          password: 'entry_password_1',
          totpSecret: 'jbswy3dpehpk3pxq',
        );
        const EntryCreateEditPageState expectedEntryCreateEditPageState = EntryCreateEditPageState(totpExistsBool: true);

        expect(actualUpdatedEntryModel, expectedEntryModel);
        expect(actualSavedEntryModel, expectedEntryModel);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryCreateEditPageCubit.state, expectedEntryCreateEditPageState);
      });

      test('Should [remove the saved TOTP secret] if [the replacement secret is EMPTY]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();
        actualEntryCreateEditPageCubit.totpSecretTextEditingController.text = '   ';

        // Act
        bool actualConfirmationRequiredBool = actualEntryCreateEditPageCubit.shouldConfirmTotpRemoval();
        EntryModel? actualUpdatedEntryModel = await actualEntryCreateEditPageCubit.save();
        EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        // Assert
        EntryModel expectedEntryModel = EntryModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'ENTRY 0',
          index: 0,
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          totpExistsBool: false,
        );
        EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          email: 'entry1@example.com',
          username: 'entry_user_1',
          password: 'entry_password_1',
          totpSecret: '',
        );
        const EntryCreateEditPageState expectedEntryCreateEditPageState = EntryCreateEditPageState();

        expect(actualConfirmationRequiredBool, true);
        expect(actualUpdatedEntryModel, expectedEntryModel);
        expect(actualSavedEntryModel, expectedEntryModel);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryCreateEditPageCubit.state, expectedEntryCreateEditPageState);
        expect(actualEntryCreateEditPageCubit.totpSecretTextEditingController.text, '');
      });
    });

    group('Tests of EntryCreateEditPageCubit.restorePreviousTotp()', () {
      test('Should [restore the seeded TOTP secret] if [the secret was removed during editing]', () async {
        // Arrange
        await actualEntryCreateEditPageCubit.init();

        // Act
        // ignore: cascade_invocations
        actualEntryCreateEditPageCubit
          ..startTotpEditingSession()
          ..removeTotp();
        EntryCreateEditPageState actualStateAfterRemoval = actualEntryCreateEditPageCubit.state;
        String actualSecretAfterRemoval = actualEntryCreateEditPageCubit.totpSecretTextEditingController.text;

        actualEntryCreateEditPageCubit
          ..restorePreviousTotp()
          ..finishTotpEditingSession();

        // Assert
        const EntryCreateEditPageState expectedStateAfterRemoval = EntryCreateEditPageState();
        const EntryCreateEditPageState expectedStateAfterRestore = EntryCreateEditPageState(totpExistsBool: true);

        expect(actualStateAfterRemoval, expectedStateAfterRemoval);
        expect(actualSecretAfterRemoval, '');
        expect(actualEntryCreateEditPageCubit.state, expectedStateAfterRestore);
        expect(actualEntryCreateEditPageCubit.totpSecretTextEditingController.text, 'wxx5vbewifu4m4hljgilbewm');
      });
    });
  });
}
