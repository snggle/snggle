import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
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
    );

    await globalLocator<EntriesService>().save(actualEntryModel.copyWith(
      name: 'UPDATED ENTRY 0',
      website: 'https://updated-entry1.example',
    ));

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
      await actualEntryDetailsPageCubit.init();

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
    });
  });

  group('Tests of EntryDetailsPageCubit.save()', () {
    test('Should [update entry secrets] and keep [loadingBool == FALSE] after save', () async {
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
      EntrySecretsModel expectedEntrySecrets = EntrySecretsModel(
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        email: 'updated-entry1@example.com',
        username: '',
        password: '',
      );

      expect(actualEntryDetailsPageCubit.state, const EntryDetailsPageState(loadingBool: false));
      expect(actualEntrySecrets, expectedEntrySecrets);
      expect(actualEntryDetailsPageCubit.emailTextEditingController.text, 'updated-entry1@example.com');
      expect(actualEntryDetailsPageCubit.usernameTextEditingController.text, '');
      expect(actualEntryDetailsPageCubit.passwordTextEditingController.text, '');
    });
  });

  tearDown(testDatabase.close);
}
