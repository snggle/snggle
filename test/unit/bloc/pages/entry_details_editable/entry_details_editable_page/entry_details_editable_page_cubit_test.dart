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
        databaseMock: DatabaseMock.fullDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: FilesystemPath.fromString('entries'),
        entryModel: null,
        entryPageType: EntryPageType.entryPageCreate,
      );
    });

    group('Tests of EntryDetailsEditablePageCubit initialization', () {
      test('Should [emit EntryDetailsEditablePageState] with [loadingBool == TRUE]', () {
        // Act
        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState.loading();

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.init()', () {
      test('Should [emit EntryDetailsEditablePageState] with initialized values', () async {
        // Act
        await actualEntryDetailsEditablePageCubit.init();

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;
        List<String> actualControllerValues = <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ];

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState();
        List<String> expectedControllerValues = <String>[
          'Entry 3',
          '',
          '',
          '',
          '',
          '',
        ];

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualControllerValues, expectedControllerValues);
        expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, false);
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

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState();

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualEntryDetailsEditablePageCubit.nameTextEditingController.text, 'Entry 4');
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.save()', () {
      test('Should [return NULL] and [emit EntryDetailsEditablePageState] with [entryNameEmptyBool == TRUE] if [name EMPTY]', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit.nameTextEditingController.text = '   ';

        // Act
        EntryModel? actualEntryModel = await actualEntryDetailsEditablePageCubit.save();

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState(entryNameEmptyBool: true);

        expect(actualEntryModel, null);
        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
      });

      test('Should [return EntryModel] and [save entry secrets] without changing existing entries', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit
          ..nameTextEditingController.text = 'ENTRY 0'
          ..websiteTextEditingController.text = 'https://snggle.com'
          ..emailTextEditingController.text = 'entry1@example.com'
          ..usernameTextEditingController.text = 'entry_user_1'
          ..passwordTextEditingController.text = 'entry_password_1';

        // Act
        EntryModel? actualEntryModel = await actualEntryDetailsEditablePageCubit.save();
        EntrySecretsModel actualEntrySecrets = await globalLocator<SecretsService>().get(
          FilesystemPath.fromString('entries/entry1'),
          PasswordModel.defaultPassword(),
        );

        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel!.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
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

        EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry4'),
          email: 'entry1@example.com',
          username: 'entry_user_1',
          password: 'entry_password_1',
          totpSecret: '',
        );

        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState();

        expect(actualEntryModel, expectedEntryModel);
        expect(actualEntrySecrets, expectedEntrySecrets);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
      });

      test('Should [normalize TOTP secret] and [return EntryModel] with [totpExistsBool == TRUE]', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit
          ..nameTextEditingController.text = 'ENTRY 0'
          ..totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXP';

        // Act
        EntryModel? actualEntryModel = await actualEntryDetailsEditablePageCubit.save();
        EntrySecretsModel actualEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel!.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
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
          filesystemPath: FilesystemPath.fromString('entries/entry4'),
          email: '',
          username: '',
          password: '',
          totpSecret: 'jbswy3dpehpk3pxp',
        );

        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState(totpExistsBool: true);

        expect(actualEntryModel, expectedEntryModel);
        expect(actualEntrySecrets, expectedEntrySecrets);
        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text, 'jbswy3dpehpk3pxp');
      });
    });

    tearDown(() async {
      await actualEntryDetailsEditablePageCubit.close();
      await testDatabase.close();
    });
  });

  group('Tests of EntryDetailsEditablePageCubit process (edit mode without TOTP)', () {
    late EntryDetailsEditablePageCubit actualEntryDetailsEditablePageCubit;
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

      actualEntryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
        parentFilesystemPath: null,
        entryModel: actualEntryModel,
        entryPageType: EntryPageType.entryPageEdit,
      );
    });

    group('Tests of EntryDetailsEditablePageCubit initialization', () {
      test('Should [emit EntryDetailsEditablePageState] with [loadingBool == TRUE]', () {
        // Act
        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState.loading();

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.init()', () {
      test('Should [initialize controllers] with entry values', () async {
        // Act
        await actualEntryDetailsEditablePageCubit.init();

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;
        List<String> actualControllerValues = <String>[
          actualEntryDetailsEditablePageCubit.nameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.websiteTextEditingController.text,
          actualEntryDetailsEditablePageCubit.emailTextEditingController.text,
          actualEntryDetailsEditablePageCubit.usernameTextEditingController.text,
          actualEntryDetailsEditablePageCubit.passwordTextEditingController.text,
          actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text,
        ];

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState();
        List<String> expectedControllerValues = <String>[
          'ENTRY 0',
          'https://snggle.com',
          'entry1@example.com',
          'entry_user_1',
          'entry_password_1',
          '',
        ];

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualControllerValues, expectedControllerValues);
        expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, false);
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.save()', () {
      test('Should [return updated EntryModel] and update entry with secrets', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit
          ..nameTextEditingController.text = 'UPDATED ENTRY 0'
          ..websiteTextEditingController.text = 'https://updated-entry1.example'
          ..emailTextEditingController.text = 'updated-entry1@example.com'
          ..usernameTextEditingController.text = ''
          ..passwordTextEditingController.text = '';

        // Act
        EntryModel? actualUpdatedEntryModel = await actualEntryDetailsEditablePageCubit.save();
        EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

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
          totpExistsBool: false,
        );
        EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          email: 'updated-entry1@example.com',
          username: '',
          password: '',
          totpSecret: '',
        );

        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState();

        expect(actualUpdatedEntryModel, expectedUpdatedEntryModel);
        expect(actualSavedEntryModel, expectedUpdatedEntryModel);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.restorePreviousTotp()', () {
      test('Should [keep TOTP EMPTY] when [restorePreviousTotp()] has empty backup', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit
          ..startTotpEditingSession()
          ..removeTotp()
          // Act
          ..restorePreviousTotp();

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState();

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text, '');
      });
    });

    tearDown(() async {
      await actualEntryDetailsEditablePageCubit.close();
      await testDatabase.close();
    });
  });

  group('Tests of EntryDetailsEditablePageCubit process (edit mode with TOTP)', () {
    late EntryDetailsEditablePageCubit actualEntryDetailsEditablePageCubit;
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
        'jbswy3dpehpk3pxp',
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

    group('Tests of EntryDetailsEditablePageCubit.init()', () {
      test('Should [initialize TOTP controller] and mark [preexistingTotpBool == TRUE]', () async {
        // Act
        await actualEntryDetailsEditablePageCubit.init();

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState(totpExistsBool: true);

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text, 'jbswy3dpehpk3pxp');
        expect(actualEntryDetailsEditablePageCubit.preexistingTotpBool, true);
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.save()', () {
      test('Should [update saved TOTP secret] and [return EntryModel] with [totpExistsBool == TRUE]', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text = 'JBSW Y3DP EHPK3PXQ';

        // Act
        EntryModel? actualUpdatedEntryModel = await actualEntryDetailsEditablePageCubit.save();
        EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryModel expectedUpdatedEntryModel = EntryModel(
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
          totpExistsBool: true,
        );
        EntrySecretsModel expectedSavedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          email: 'entry1@example.com',
          username: 'entry_user_1',
          password: 'entry_password_1',
          totpSecret: 'jbswy3dpehpk3pxq',
        );
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState(totpExistsBool: true);

        expect(actualUpdatedEntryModel, expectedUpdatedEntryModel);
        expect(actualSavedEntryModel, expectedUpdatedEntryModel);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
      });
    });

    group('Tests of EntryDetailsEditablePageCubit.restorePreviousTotp()', () {
      test('Should [restore previous TOTP] after temporary removal', () async {
        // Arrange
        await actualEntryDetailsEditablePageCubit.init();
        actualEntryDetailsEditablePageCubit
          ..startTotpEditingSession()
          ..removeTotp()
          // Act
          ..restorePreviousTotp();

        EntryDetailsEditablePageState actualEntryDetailsEditablePageState = actualEntryDetailsEditablePageCubit.state;

        // Assert
        EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState(totpExistsBool: true);

        expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
        expect(actualEntryDetailsEditablePageCubit.totpSecretTextEditingController.text, 'jbswy3dpehpk3pxp');
      });
    });

    tearDown(() async {
      await actualEntryDetailsEditablePageCubit.close();
      await testDatabase.close();
    });
  });
}
