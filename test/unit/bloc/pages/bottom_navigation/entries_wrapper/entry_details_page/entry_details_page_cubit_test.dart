import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
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
  
  group('Tests of EntryDetailsPageCubit without TOTP', () {
    late EntryDetailsPageCubit actualEntryDetailsPageCubit;
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

      await globalLocator<EntriesService>().save(
        actualEntryModel.copyWith(
          name: 'UPDATED ENTRY 0',
          website: 'https://updated-entry1.example',
        ),
      );

      globalLocator<PasswordController>().addPassword(
        PasswordModel.defaultPassword(),
        actualEntryModel.filesystemPath,
      );

      actualEntryDetailsPageCubit = EntryDetailsPageCubit(entryModel: actualEntryModel);
    });

    tearDown(() async {
      await actualEntryDetailsPageCubit.close();
      await testDatabase.close();
    });

    group('Tests of EntryDetailsPageCubit initialization', () {
      test('Should [emit EntryDetailsPageState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualEntryDetailsPageCubit.state, const EntryDetailsPageState.loading());
      });
    });

    group('Tests of EntryDetailsPageCubit.refresh()', () {
      test('Should [load entry data and secrets into controllers]', () async {
        // Act
        await actualEntryDetailsPageCubit.refresh();

        // Assert
        EntryModel expectedEntryModel = EntryModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          index: 0,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'UPDATED ENTRY 0',
          website: 'https://updated-entry1.example',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
        );

        expect(actualEntryDetailsPageCubit.state, const EntryDetailsPageState(loadingBool: false));
        expect(actualEntryDetailsPageCubit.entryModel, expectedEntryModel);
        expect(actualEntryDetailsPageCubit.nameTextEditingController.text, 'UPDATED ENTRY 0');
        expect(actualEntryDetailsPageCubit.websiteTextEditingController.text, 'https://updated-entry1.example');
        expect(actualEntryDetailsPageCubit.emailTextEditingController.text, 'entry1@example.com');
        expect(actualEntryDetailsPageCubit.usernameTextEditingController.text, 'entry_user_1');
        expect(actualEntryDetailsPageCubit.passwordTextEditingController.text, 'entry_password_1');
        expect(actualEntryDetailsPageCubit.totpCodeTextEditingController.text, '');
      });
    });

    group('Tests of EntryDetailsPageCubit.save()', () {
      test('Should [update entry secrets] and keep [loadingBool == FALSE] after save', () async {
        // Arrange
        await actualEntryDetailsPageCubit.refresh();
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
        EntrySecretsModel expectedEntrySecrets = EntrySecretsModel(
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          email: 'updated-entry1@example.com',
          username: '',
          password: '',
          totpSecret: '',
        );

        expect(actualEntryDetailsPageCubit.state, const EntryDetailsPageState(loadingBool: false));
        expect(actualEntrySecrets, expectedEntrySecrets);
        expect(actualEntryDetailsPageCubit.emailTextEditingController.text, 'updated-entry1@example.com');
        expect(actualEntryDetailsPageCubit.usernameTextEditingController.text, '');
        expect(actualEntryDetailsPageCubit.passwordTextEditingController.text, '');
      });
    });
  });

  group('Tests of EntryDetailsPageCubit with TOTP enabled', () {
    final DateTime totpTimestamp = DateTime.fromMicrosecondsSinceEpoch(1779174562796584);
    late EntryDetailsPageCubit actualEntryDetailsPageCubit;
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

      actualEntryDetailsPageCubit = EntryDetailsPageCubit(entryModel: actualEntryModel);
    });

    tearDown(() async {
      await actualEntryDetailsPageCubit.close();
      await testDatabase.close();
    });

    group('Tests of EntryDetailsPageCubit.refresh()', () {
      test('Should [load the one-time code and remaining seconds] if [the entry has TOTP enabled]', () async {
        // Act
        await actualEntryDetailsPageCubit.refresh(timestamp: totpTimestamp);

        // Assert
        const EntryDetailsPageState expectedEntryDetailsPageState = EntryDetailsPageState(
          loadingBool: false,
          totpExistsBool: true,
          totpRemainingSeconds: 8,
        );

        expect(actualEntryDetailsPageCubit.state, expectedEntryDetailsPageState);
        expect(actualEntryDetailsPageCubit.totpCodeTextEditingController.text, '578 294');
      });
    });

    group('Tests of EntryDetailsPageCubit.save()', () {
      test('Should [preserve the seeded TOTP secret and code] if [only the email changes]', () async {
        // Arrange
        await actualEntryDetailsPageCubit.refresh(timestamp: totpTimestamp);
        actualEntryDetailsPageCubit.emailTextEditingController.text = 'updated-entry1@example.com';

        // Act
        await actualEntryDetailsPageCubit.save();
        EntryModel actualSavedEntryModel = await globalLocator<EntriesService>().getById(actualEntryModel.id);
        EntrySecretsModel actualSavedEntrySecrets = await globalLocator<SecretsService>().get(
          actualEntryModel.filesystemPath,
          PasswordModel.defaultPassword(),
        );

        // Assert
        EntryModel expectedSavedEntryModel = EntryModel(
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
          email: 'updated-entry1@example.com',
          username: 'entry_user_1',
          password: 'entry_password_1',
          totpSecret: 'wxx5vbewifu4m4hljgilbewm',
        );
        const EntryDetailsPageState expectedEntryDetailsPageState = EntryDetailsPageState(
          loadingBool: false,
          totpExistsBool: true,
          totpRemainingSeconds: 8,
        );

        expect(actualSavedEntryModel, expectedSavedEntryModel);
        expect(actualSavedEntrySecrets, expectedSavedEntrySecrets);
        expect(actualEntryDetailsPageCubit.state, expectedEntryDetailsPageState);
        expect(actualEntryDetailsPageCubit.totpCodeTextEditingController.text, '578 294');
      });
    });
  });
}
