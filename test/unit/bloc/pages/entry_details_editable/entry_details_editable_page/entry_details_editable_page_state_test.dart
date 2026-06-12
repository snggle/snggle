import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';

void main() {
  group('Tests of EntryDetailsEditablePageState.loading() constructor', () {
    test('Should [return EntryDetailsEditablePageState] with [loadingBool == TRUE]', () {
      // Act
      EntryDetailsEditablePageState actualEntryDetailsEditablePageState = const EntryDetailsEditablePageState.loading();

      // Assert
      EntryDetailsEditablePageState expectedEntryDetailsEditablePageState = const EntryDetailsEditablePageState(
        loadingBool: true,
      );

      expect(actualEntryDetailsEditablePageState, expectedEntryDetailsEditablePageState);
    });
  });
}
