import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';

void main() {
  group('Tests of EntryDetailsPageState.loading() constructor', () {
    test('Should [return EntryDetailsPageState] with [loadingBool == TRUE]',
        () {
      // Act
      EntryDetailsPageState actualEntryDetailsPageState =
          const EntryDetailsPageState.loading();

      // Assert
      EntryDetailsPageState expectedEntryDetailsPageState =
          const EntryDetailsPageState(
        loadingBool: true,
      );

      expect(actualEntryDetailsPageState, expectedEntryDetailsPageState);
    });
  });
}
