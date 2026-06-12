import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  final DateTime totpTimestamp = DateTime.fromMicrosecondsSinceEpoch(1779174562796584);
  late EntryDetailsPageCubit actualEntryDetailsPageCubit;
  late EntryModel actualEntryModel;

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
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

    actualEntryDetailsPageCubit = EntryDetailsPageCubit(entryModel: actualEntryModel);
  });

  group('Tests of EntryDetailsPageCubit initialization', () {
    test('Should [emit EntryDetailsPageState] with [loadingBool == TRUE]', () {
      // Assert
      expect(actualEntryDetailsPageCubit.state, const EntryDetailsPageState.loading());
    });
  });

  group('Tests of EntryDetailsPageCubit.init()', () {
    test('Should [load entry data and secrets into controllers]', () async {
      // Act
      await actualEntryDetailsPageCubit.init(timestamp: totpTimestamp);

      // Assert
      EntryDetailsPageCubit expectedEntryDetailsPageCubit = EntryDetailsPageCubit(
        entryModel: EntryModel(
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
        ),
      );
      addTearDown(expectedEntryDetailsPageCubit.close);
      await expectedEntryDetailsPageCubit.init(timestamp: totpTimestamp);

      expect(actualEntryDetailsPageCubit.state, expectedEntryDetailsPageCubit.state);
      expect(actualEntryDetailsPageCubit.entryModel, expectedEntryDetailsPageCubit.entryModel);
      expect(
        <String>[
          actualEntryDetailsPageCubit.nameTextEditingController.text,
          actualEntryDetailsPageCubit.websiteTextEditingController.text,
          actualEntryDetailsPageCubit.emailTextEditingController.text,
          actualEntryDetailsPageCubit.usernameTextEditingController.text,
          actualEntryDetailsPageCubit.passwordTextEditingController.text,
          actualEntryDetailsPageCubit.totpTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsPageCubit.nameTextEditingController.text,
          expectedEntryDetailsPageCubit.websiteTextEditingController.text,
          expectedEntryDetailsPageCubit.emailTextEditingController.text,
          expectedEntryDetailsPageCubit.usernameTextEditingController.text,
          expectedEntryDetailsPageCubit.passwordTextEditingController.text,
          expectedEntryDetailsPageCubit.totpTextEditingController.text,
        ],
      );
    });

    test('Should [load TOTP code] and [emit state] with [totpExistsBool == TRUE]', () async {
      // Arrange
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

      actualEntryDetailsPageCubit = EntryDetailsPageCubit(entryModel: actualEntryModel);

      // Act
      await actualEntryDetailsPageCubit.init(timestamp: totpTimestamp);

      // Assert
      EntryDetailsPageCubit expectedEntryDetailsPageCubit = EntryDetailsPageCubit(
        entryModel: EntryModel(
          id: 5,
          encryptedBool: false,
          pinnedBool: false,
          index: 4,
          filesystemPath: FilesystemPath.fromString('entries/entry5'),
          name: 'ENTRY 0',
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          totpExistsBool: true,
        ),
      );
      addTearDown(expectedEntryDetailsPageCubit.close);
      await expectedEntryDetailsPageCubit.init(timestamp: totpTimestamp);

      expect(actualEntryDetailsPageCubit.state, expectedEntryDetailsPageCubit.state);
      expect(actualEntryDetailsPageCubit.state, const EntryDetailsPageState(loadingBool: false, totpExistsBool: true, totpRemainingSeconds: 8));
      expect(actualEntryDetailsPageCubit.entryModel, expectedEntryDetailsPageCubit.entryModel);
      expect(actualEntryDetailsPageCubit.totpTextEditingController.text, '541 411');
      expect(
        <String>[
          actualEntryDetailsPageCubit.nameTextEditingController.text,
          actualEntryDetailsPageCubit.websiteTextEditingController.text,
          actualEntryDetailsPageCubit.emailTextEditingController.text,
          actualEntryDetailsPageCubit.usernameTextEditingController.text,
          actualEntryDetailsPageCubit.passwordTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsPageCubit.nameTextEditingController.text,
          expectedEntryDetailsPageCubit.websiteTextEditingController.text,
          expectedEntryDetailsPageCubit.emailTextEditingController.text,
          expectedEntryDetailsPageCubit.usernameTextEditingController.text,
          expectedEntryDetailsPageCubit.passwordTextEditingController.text,
        ],
      );
    });
  });

  group('Tests of EntryDetailsPageCubit.save()', () {
    test('Should keep seeded [entries/entry1] secrets unchanged and keep [loadingBool == FALSE] after save', () async {
      // Arrange
      await actualEntryDetailsPageCubit.init();
      actualEntryDetailsPageCubit.emailTextEditingController.text = 'updated-entry1@example.com';
      actualEntryDetailsPageCubit.usernameTextEditingController.text = '';
      actualEntryDetailsPageCubit.passwordTextEditingController.text = '';

      // Act
      await actualEntryDetailsPageCubit.save();
      EntrySecretsModel actualEntrySecrets = await globalLocator<SecretsService>().get(
        FilesystemPath.fromString('entries/entry1'),
        PasswordModel.defaultPassword(),
      );

      // Assert
      EntryDetailsPageCubit expectedEntryDetailsPageCubit = EntryDetailsPageCubit(
        entryModel: EntryModel(
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
        ),
      );
      addTearDown(expectedEntryDetailsPageCubit.close);
      await expectedEntryDetailsPageCubit.init();
      expectedEntryDetailsPageCubit.emailTextEditingController.text = 'updated-entry1@example.com';
      expectedEntryDetailsPageCubit.usernameTextEditingController.text = '';
      expectedEntryDetailsPageCubit.passwordTextEditingController.text = '';

      EntrySecretsModel expectedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'entry1@example.com',
        username: 'entry_user_1',
        password: 'entry_password_1',
        totpSecret: 'wxx5vbewifu4m4hljgilbewm',
      );

      expect(actualEntryDetailsPageCubit.state, expectedEntryDetailsPageCubit.state);
      expect(actualEntryDetailsPageCubit.entryModel, expectedEntryDetailsPageCubit.entryModel);
      expect(
        <String>[
          actualEntryDetailsPageCubit.nameTextEditingController.text,
          actualEntryDetailsPageCubit.websiteTextEditingController.text,
          actualEntryDetailsPageCubit.emailTextEditingController.text,
          actualEntryDetailsPageCubit.usernameTextEditingController.text,
          actualEntryDetailsPageCubit.passwordTextEditingController.text,
          actualEntryDetailsPageCubit.totpTextEditingController.text,
        ],
        <String>[
          expectedEntryDetailsPageCubit.nameTextEditingController.text,
          expectedEntryDetailsPageCubit.websiteTextEditingController.text,
          expectedEntryDetailsPageCubit.emailTextEditingController.text,
          expectedEntryDetailsPageCubit.usernameTextEditingController.text,
          expectedEntryDetailsPageCubit.passwordTextEditingController.text,
          expectedEntryDetailsPageCubit.totpTextEditingController.text,
        ],
      );
      expect(actualEntrySecrets, expectedEntrySecrets);
    });
  });

  tearDown(testDatabase.close);
}
