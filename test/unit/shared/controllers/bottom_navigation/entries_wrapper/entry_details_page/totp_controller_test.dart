import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/controllers/bottom_navigation/entries_wrapper/entry_details_page/totp_controller.dart';

void main() {
  const String totpSecret = 'wxx5vbewifu4m4hljgilbewm';
  final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(1779174562000, isUtc: true);

  group('Tests of TotpController.start()', () {
    late TotpController actualTotpController;
    late List<int?> actualUpdates;

    setUp(() {
      actualTotpController = TotpController();
      actualUpdates = <int?>[];
    });

    tearDown(() {
      actualTotpController.dispose();
    });

    test(
      'Should [format the code and report the remaining seconds] if [the secret is valid]',
      () {
        // Act
        actualTotpController.start(
          totpSecret: totpSecret,
          timestamp: timestamp,
          onUpdate: actualUpdates.add,
        );

        // Assert
        const List<int?> expectedUpdates = <int?>[8];

        expect(actualTotpController.totpCodeTextEditingController.text, '578 294');
        expect(actualUpdates, expectedUpdates);
      },
    );

    test(
      'Should [report 30 remaining seconds] if [a TOTP period has just started]',
      () {
        // Arrange
        DateTime actualPeriodStart = DateTime.fromMillisecondsSinceEpoch(
          1779174540000,
          isUtc: true,
        );

        // Act
        actualTotpController.start(
          totpSecret: totpSecret,
          timestamp: actualPeriodStart,
          onUpdate: actualUpdates.add,
        );

        // Assert
        const List<int?> expectedUpdates = <int?>[30];

        expect(
          actualTotpController.totpCodeTextEditingController.text,
          '578 294',
        );
        expect(actualUpdates, expectedUpdates);
      },
    );

    test(
      'Should [report NULL and leave the code empty] if [the secret is invalid]',
      () {
        // Act
        actualTotpController.start(
          totpSecret: '0000',
          timestamp: timestamp,
          onUpdate: actualUpdates.add,
        );

        // Assert
        const List<int?> expectedUpdates = <int?>[null];

        expect(
          actualTotpController.totpCodeTextEditingController.text,
          isEmpty,
        );
        expect(actualUpdates, expectedUpdates);
      },
    );

    test(
      'Should [clear the code and stop periodic updates] if [restarted with an empty secret]',
      () async {
        // Arrange
        List<int?> actualPreviousUpdates = <int?>[];
        actualTotpController.start(
          totpSecret: totpSecret,
          timestamp: timestamp,
          onUpdate: actualPreviousUpdates.add,
        );

        // Act
        // ignore: cascade_invocations
        actualTotpController.start(
          totpSecret: '',
          timestamp: timestamp,
          onUpdate: actualUpdates.add,
        );
        await Future<void>.delayed(const Duration(milliseconds: 1100));

        // Assert
        const List<int?> expectedPreviousUpdates = <int?>[8];
        const List<int?> expectedUpdates = <int?>[null];

        expect(
          actualTotpController.totpCodeTextEditingController.text,
          isEmpty,
        );
        expect(actualPreviousUpdates, expectedPreviousUpdates);
        expect(actualUpdates, expectedUpdates);
      },
    );
  });
}
