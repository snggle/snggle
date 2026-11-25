import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/two_factor_options_page/two_factor_options_page_cubit.dart';
import 'package:snggle/bloc/pages/two_factor_options_page/two_factor_options_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/database_mock.dart';
import '../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late EntryModel actualEntryModel;

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
    actualEntryModel = await globalLocator<EntriesService>().getById(1);
  });

  tearDown(() async {
    await testDatabase.close();
  });

  group('Tests of TwoFactorOptionsPageCubit.getTotpExportUri()', () {
    test(
      'Should [return NULL and disable export] if [the entry is missing]',
      () async {
        // Arrange
        TwoFactorOptionsPageCubit actualTwoFactorOptionsPageCubit = TwoFactorOptionsPageCubit(entryModel: null);
        addTearDown(actualTwoFactorOptionsPageCubit.close);

        // Act
        Uri? actualExportUri = await actualTwoFactorOptionsPageCubit.getTotpExportUri();

        // Assert
        const TwoFactorOptionsPageState expectedState = TwoFactorOptionsPageState(totpExportAvailableBool: false);

        expect(actualExportUri, isNull);
        expect(actualTwoFactorOptionsPageCubit.state, expectedState);
      },
    );

    test(
      'Should [return NULL and disable export] if [the entry has TOTP disabled]',
      () async {
        // Arrange
        TwoFactorOptionsPageCubit actualTwoFactorOptionsPageCubit = TwoFactorOptionsPageCubit(
          entryModel: actualEntryModel.copyWith(totpExistsBool: false),
        );
        addTearDown(actualTwoFactorOptionsPageCubit.close);

        // Act
        Uri? actualExportUri = await actualTwoFactorOptionsPageCubit.getTotpExportUri();

        // Assert
        const TwoFactorOptionsPageState expectedState = TwoFactorOptionsPageState(totpExportAvailableBool: false);

        expect(actualExportUri, isNull);
        expect(actualTwoFactorOptionsPageCubit.state, expectedState);
      },
    );

    test(
      'Should [return URI] if [the entry has a readable secret]',
      () async {
        // Arrange
        await globalLocator<SecretsService>().save(
          EntrySecretsModel(
            filesystemPath: actualEntryModel.filesystemPath,
            email: '',
            username: '',
            password: '',
            totpSecret: ' jbsw y3dp ee====== ',
          ),
          PasswordModel.defaultPassword(),
        );
        TwoFactorOptionsPageCubit actualTwoFactorOptionsPageCubit = TwoFactorOptionsPageCubit(
          entryModel: actualEntryModel.copyWith(name: 'test'),
        );
        addTearDown(actualTwoFactorOptionsPageCubit.close);

        // Act
        TwoFactorOptionsPageState actualInitialState = actualTwoFactorOptionsPageCubit.state;
        Uri? actualExportUri = await actualTwoFactorOptionsPageCubit.getTotpExportUri();
        TwoFactorOptionsPageState actualExportedState = actualTwoFactorOptionsPageCubit.state;
        Uri? actualSecondExportUri = await actualTwoFactorOptionsPageCubit.getTotpExportUri();

        // Assert
        const TwoFactorOptionsPageState expectedInitialState = TwoFactorOptionsPageState(totpExportAvailableBool: true);
        const TwoFactorOptionsPageState expectedExportedState = TwoFactorOptionsPageState(totpExportAvailableBool: false);
        Uri expectedExportUri = Uri.parse(
          'otpauth://totp/SNGGLE:test?secret=JBSWY3DPEE&issuer=SNGGLE',
        );

        expect(actualInitialState, expectedInitialState);
        expect(actualExportUri, expectedExportUri);
        expect(actualExportedState, expectedExportedState);
        expect(actualSecondExportUri, isNull);
      },
    );

    test(
      'Should [use Entry as the account name] if [the entry name is blank]',
      () async {
        // Arrange
        TwoFactorOptionsPageCubit actualTwoFactorOptionsPageCubit = TwoFactorOptionsPageCubit(
          entryModel: actualEntryModel.copyWith(name: '   '),
        );
        addTearDown(actualTwoFactorOptionsPageCubit.close);

        // Act
        Uri? actualExportUri = await actualTwoFactorOptionsPageCubit.getTotpExportUri();

        // Assert
        Uri expectedExportUri = Uri.parse(
          'otpauth://totp/SNGGLE:Entry?secret=WXX5VBEWIFU4M4HLJGILBEWM&issuer=SNGGLE',
        );

        expect(actualExportUri, expectedExportUri);
      },
    );

    test(
      'Should [return NULL] if [TOTP is enabled but the stored secret is empty]',
      () async {
        // Arrange
        await globalLocator<SecretsService>().save(
          EntrySecretsModel(
            filesystemPath: actualEntryModel.filesystemPath,
            email: '',
            username: '',
            password: '',
            totpSecret: '',
          ),
          PasswordModel.defaultPassword(),
        );
        TwoFactorOptionsPageCubit actualTwoFactorOptionsPageCubit = TwoFactorOptionsPageCubit(entryModel: actualEntryModel);
        addTearDown(actualTwoFactorOptionsPageCubit.close);

        // Act
        Uri? actualExportUri = await actualTwoFactorOptionsPageCubit.getTotpExportUri();

        // Assert
        expect(actualExportUri, isNull);
      },
    );
  });
}
