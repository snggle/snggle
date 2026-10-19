import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_state.dart';

void main() {
  group('Tests of EntryCreateEditPageState.loading() constructor', () {
    test('Should [return EntryCreateEditPageState] with [loadingBool == TRUE]', () {
      // Act
      EntryCreateEditPageState actualEntryCreateEditPageState = const EntryCreateEditPageState.loading();

      // Assert
      EntryCreateEditPageState expectedEntryCreateEditPageState = const EntryCreateEditPageState(
        loadingBool: true,
      );

      expect(actualEntryCreateEditPageState, expectedEntryCreateEditPageState);
    });
  });
}
