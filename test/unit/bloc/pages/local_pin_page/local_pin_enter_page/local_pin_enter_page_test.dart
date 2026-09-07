import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/a_local_pin_enter_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/local_pin_enter_page_cubit.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/states/local_pin_enter_page_enter_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/states/local_pin_enter_page_invalid_state.dart';
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

  group('Tests of [LocalPinEnterPageCubit] process when [pin CORRECT]', () {
    late PasswordModel? actualEnteredPasswordModel;
    late LocalPinEnterPageCubit actualLocalPinEnterPageCubit;

    setUpAll(() {
      actualLocalPinEnterPageCubit = LocalPinEnterPageCubit(
        listItemModel: TestListItem(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (PasswordModel passwordModel) => actualEnteredPasswordModel = passwordModel,
      );
    });

    test('Should [emit LocalPinEnterPageEnterState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ALocalPinEnterPageState expectedLocalPinEnterPageState = LocalPinEnterPageEnterState.empty();

      expect(actualLocalPinEnterPageCubit.state, expectedLocalPinEnterPageState);
    });

    test('Should [emit LocalPinEnterPageEnterState] with [FILLED pinNumbers]', () async {
      // Act
      actualLocalPinEnterPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

      // Assert
      ALocalPinEnterPageState expectedLocalPinEnterPageState = const LocalPinEnterPageEnterState(pinNumbers: <int>[1, 1, 1, 1]);

      expect(actualLocalPinEnterPageCubit.state, expectedLocalPinEnterPageState);
    });

    test('Should [return PasswordModel] if provided [password VALID]', () async {
      // Act
      await actualLocalPinEnterPageCubit.authenticate();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualEnteredPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of [LocalPinEnterPageCubit] when [pin INCORRECT]', () {
    late LocalPinEnterPageCubit actualLocalPinEnterPageCubit;

    setUpAll(() {
      actualLocalPinEnterPageCubit = LocalPinEnterPageCubit(
        listItemModel: TestListItem(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
        ),
        passwordValidCallback: (_) {},
      );
    });

    test('Should [emit LocalPinEnterPageEnterState] with [EMPTY pinNumbers] as initial state', () async {
      // Assert
      ALocalPinEnterPageState expectedLocalPinEnterPageState = LocalPinEnterPageEnterState.empty();

      expect(actualLocalPinEnterPageCubit.state, expectedLocalPinEnterPageState);
    });

    test('Should [emit LocalPinEnterPageEnterState] with [FILLED pinNumbers]', () async {
      // Act
      actualLocalPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

      // Assert
      ALocalPinEnterPageState expectedLocalPinEnterPageState = const LocalPinEnterPageEnterState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualLocalPinEnterPageCubit.state, expectedLocalPinEnterPageState);
    });

    test('Should [emit LocalPinEnterPageInvalidState] if provided [password INVALID]', () async {
      // Act
      await actualLocalPinEnterPageCubit.authenticate();

      // Assert
      ALocalPinEnterPageState expectedLocalPinEnterPageState = const LocalPinEnterPageInvalidState(pinNumbers: <int>[9, 9, 9, 9]);

      expect(actualLocalPinEnterPageCubit.state, expectedLocalPinEnterPageState);
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
