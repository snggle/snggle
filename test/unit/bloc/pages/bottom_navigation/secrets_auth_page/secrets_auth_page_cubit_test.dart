import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/secrets_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

Future<void> main() async {
  final TestDatabase testDatabase = TestDatabase();

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.testSecretsMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of [SecretsAuthPageCubit] process when [pin CORRECT]', () {
    late PasswordModel? actualEnteredPasswordModel;
    late SecretsAuthPageCubit actualSecretsAuthPageCubit;

    setUpAll(() {
      actualSecretsAuthPageCubit = SecretsAuthPageCubit(
        listItemModel: TestListItem(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (PasswordModel passwordModel) => actualEnteredPasswordModel = passwordModel,
      );
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = SecretsAuthPageEnterPinState.empty();

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [FILLED pinNumbers]', () async {
      // Act
      actualSecretsAuthPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = const SecretsAuthPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [return PasswordModel] if provided [password VALID]', () async {
      // Act
      await actualSecretsAuthPageCubit.authenticate();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualEnteredPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of [SecretsAuthPageCubit] when [pin INCORRECT]', () {
    late SecretsAuthPageCubit actualSecretsAuthPageCubit;

    setUpAll(() {
      actualSecretsAuthPageCubit = SecretsAuthPageCubit(
        listItemModel: TestListItem(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (_) {},
      );
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = SecretsAuthPageEnterPinState.empty();

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [emit SecretsAuthPageEnterPinState] with [FILLED pinNumbers]', () async {
      // Act
      actualSecretsAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = const SecretsAuthPageEnterPinState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });

    test('Should [emit SecretsAuthPageInvalidPinState] if provided [password INVALID]', () async {
      // Act
      await actualSecretsAuthPageCubit.authenticate();

      // Assert
      ASecretsAuthPageState expectedSecretsAuthPageState = const SecretsAuthPageInvalidPinState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualSecretsAuthPageCubit.state, expectedSecretsAuthPageState);
    });
  });

  tearDownAll(testDatabase.close);
}

class TestListItem extends AListItemModel {
  TestListItem({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
  }) : super(filesystemPath: FilesystemPath.fromString('id$id'));

  @override
  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool}) {
    return TestListItem(
      id: id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
    );
  }

  @override
  String get name => 'Test List Item';
}
