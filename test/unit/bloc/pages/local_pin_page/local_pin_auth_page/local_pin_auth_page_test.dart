import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/a_local_pin_auth_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/local_pin_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/states/local_pin_auth_page_enter_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/states/local_pin_auth_page_invalid_state.dart';
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

  group('Tests of [LocalPinAuthPageCubit] process when [pin CORRECT]', () {
    late PasswordModel? actualEnteredPasswordModel;
    late LocalPinAuthPageCubit actualLocalPinAuthPageCubit;

    setUpAll(() {
      actualLocalPinAuthPageCubit = LocalPinAuthPageCubit(
        listItemModel: TestListItem(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (PasswordModel passwordModel) => actualEnteredPasswordModel = passwordModel,
      );
    });

    test('Should [emit LocalPinAuthPageEnterState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ALocalPinAuthPageState expectedLocalPinAuthPageState = LocalPinAuthPageEnterState.empty();

      expect(actualLocalPinAuthPageCubit.state, expectedLocalPinAuthPageState);
    });

    test('Should [emit LocalPinAuthPageEnterState] with [FILLED pinNumbers]', () async {
      // Act
      actualLocalPinAuthPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

      // Assert
      ALocalPinAuthPageState expectedLocalPinAuthPageState = const LocalPinAuthPageEnterState(pinNumbers: <int>[1, 1, 1, 1]);

      expect(actualLocalPinAuthPageCubit.state, expectedLocalPinAuthPageState);
    });

    test('Should [return PasswordModel] if provided [password VALID]', () async {
      // Act
      await actualLocalPinAuthPageCubit.authenticate();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualEnteredPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of [LocalPinAuthPageCubit] when [pin INCORRECT]', () {
    late LocalPinAuthPageCubit actualLocalPinAuthPageCubit;

    setUpAll(() {
      actualLocalPinAuthPageCubit = LocalPinAuthPageCubit(
        listItemModel: TestListItem(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (_) {},
      );
    });

    test('Should [emit LocalPinAuthPageEnterState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ALocalPinAuthPageState expectedLocalPinAuthPageState = LocalPinAuthPageEnterState.empty();

      expect(actualLocalPinAuthPageCubit.state, expectedLocalPinAuthPageState);
    });

    test('Should [emit LocalPinAuthPageEnterState] with [FILLED pinNumbers]', () async {
      // Act
      actualLocalPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

      // Assert
      ALocalPinAuthPageState expectedLocalPinAuthPageState = const LocalPinAuthPageEnterState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualLocalPinAuthPageCubit.state, expectedLocalPinAuthPageState);
    });

    test('Should [emit LocalPinAuthPageInvalidState] if provided [password INVALID]', () async {
      // Act
      await actualLocalPinAuthPageCubit.authenticate();

      // Assert
      ALocalPinAuthPageState expectedLocalPinAuthPageState = const LocalPinAuthPageInvalidState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualLocalPinAuthPageCubit.state, expectedLocalPinAuthPageState);
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
  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool, String? name}) {
    return TestListItem(
      id: id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
    );
  }

  @override
  String get name => 'Test List Item';

  @override
  String get defaultItemName => 'Default Test List Item';
}
