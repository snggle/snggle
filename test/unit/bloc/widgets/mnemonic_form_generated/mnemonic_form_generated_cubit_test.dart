import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/widgets/mnemonic_form_generated/mnemonic_form_generated_cubit.dart';
import 'package:snggle/bloc/widgets/mnemonic_form_generated/mnemonic_form_generated_state.dart';

Future<void> main() async {
  group('Tests of [MnemonicFormGeneratedCubit]', () {
    group('Tests of [MnemonicFormGeneratedCubit] when [CREATED]', () {
      late MnemonicFormGeneratedCubit mnemonicFormGeneratedCubit;

      setUp(() async {
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit();
      });

      tearDown(() async {
        await mnemonicFormGeneratedCubit.close();
      });

      test('Should [emit MnemonicFormGeneratedState] with [DEFAULT values] as initial state', () async {
        // Assert
        const MnemonicFormGeneratedState expectedState = MnemonicFormGeneratedState();

        expect(mnemonicFormGeneratedCubit.state, expectedState);
      });

      test('Should [emit MnemonicFormGeneratedState] with [DEFAULT finishPrerequisiteBool: TRUE]', () async {
        // Assert
        expect(mnemonicFormGeneratedCubit.state.finishPrerequisiteBool, isTrue);
      });

      test('Should [emit MnemonicFormGeneratedState] with [DEFAULT obscureTextBool: TRUE]', () async {
        // Assert
        expect(mnemonicFormGeneratedCubit.state.obscureTextBool, isTrue);
      });

      test('Should [emit MnemonicFormGeneratedState] with [DEFAULT scrolledBottomBool: FALSE]', () async {
        // Assert
        expect(mnemonicFormGeneratedCubit.state.scrolledBottomBool, isFalse);
      });

      test('Should [emit MnemonicFormGeneratedState] with [DEFAULT statementAcceptedBool: FALSE]', () async {
        // Assert
        expect(mnemonicFormGeneratedCubit.state.statementAcceptedBool, isFalse);
      });
    });

    group('Tests of [MnemonicFormGeneratedCubit] toggleObscureText()', () {
      late MnemonicFormGeneratedCubit mnemonicFormGeneratedCubit;

      setUp(() async {
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit();
      });

      tearDown(() async {
        await mnemonicFormGeneratedCubit.close();
      });

      test('Should [emit MnemonicFormGeneratedState] with [obscureTextBool: FALSE] after first toggle', () async {
        // Act
        mnemonicFormGeneratedCubit.toggleObscureText();

        // Assert
        expect(mnemonicFormGeneratedCubit.state.obscureTextBool, isFalse);
      });

      test('Should [emit MnemonicFormGeneratedState] with [obscureTextBool: TRUE] after second toggle', () async {
        // Act
        mnemonicFormGeneratedCubit
          ..toggleObscureText()
          ..toggleObscureText();

        // Assert
        expect(mnemonicFormGeneratedCubit.state.obscureTextBool, isTrue);
      });
    });

    group('Tests of [MnemonicFormGeneratedCubit] updateStatementAccepted()', () {
      late MnemonicFormGeneratedCubit mnemonicFormGeneratedCubit;

      setUp(() async {
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit();
      });

      tearDown(() async {
        await mnemonicFormGeneratedCubit.close();
      });

      test('Should [emit MnemonicFormGeneratedState] with [statementAcceptedBool: TRUE]', () async {
        // Act
        mnemonicFormGeneratedCubit.updateStatementAccepted(
          statementAcceptedBool: true,
        );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.statementAcceptedBool, isTrue);
      });

      test('Should [emit MnemonicFormGeneratedState] with [statementAcceptedBool: FALSE]', () async {
        // Arrange
        mnemonicFormGeneratedCubit
          ..updateStatementAccepted(
            statementAcceptedBool: true,
          )

          // Act
          ..updateStatementAccepted(
            statementAcceptedBool: false,
          );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.statementAcceptedBool, isFalse);
      });
    });

    group('Tests of [MnemonicFormGeneratedCubit] updateScrolledBottom()', () {
      late MnemonicFormGeneratedCubit mnemonicFormGeneratedCubit;

      setUp(() async {
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit();
      });

      tearDown(() async {
        await mnemonicFormGeneratedCubit.close();
      });

      test('Should [emit MnemonicFormGeneratedState] with [scrolledBottomBool: TRUE]', () async {
        // Act
        mnemonicFormGeneratedCubit.updateScrolledBottom(
          scrolledBottomBool: true,
        );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.scrolledBottomBool, isTrue);
      });

      test('Should [emit MnemonicFormGeneratedState] with [scrolledBottomBool: FALSE]', () async {
        // Arrange
        mnemonicFormGeneratedCubit
          ..updateScrolledBottom(
            scrolledBottomBool: true,
          )

          // Act
          ..updateScrolledBottom(
            scrolledBottomBool: false,
          );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.scrolledBottomBool, isFalse);
      });

      test('Should [NOT emit MnemonicFormGeneratedState] if [scrolledBottomBool] has the same value', () async {
        // Arrange
        List<MnemonicFormGeneratedState> emittedStatesList = <MnemonicFormGeneratedState>[];

        StreamSubscription<MnemonicFormGeneratedState> streamSubscription = mnemonicFormGeneratedCubit.stream.listen(emittedStatesList.add);

        // Act
        mnemonicFormGeneratedCubit.updateScrolledBottom(
          scrolledBottomBool: false,
        );

        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(emittedStatesList, isEmpty);

        await streamSubscription.cancel();
      });
    });

    group('Tests of [MnemonicFormGeneratedCubit] finishButtonEnabledBool', () {
      late MnemonicFormGeneratedCubit mnemonicFormGeneratedCubit;

      tearDown(() async {
        await mnemonicFormGeneratedCubit.close();
      });

      test('Should [return FALSE] by default', () async {
        // Arrange
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit();

        // Assert
        expect(mnemonicFormGeneratedCubit.state.finishButtonEnabledBool, isFalse);
      });

      test('Should [return TRUE] if [finishPrerequisiteBool: TRUE], [scrolledBottomBool: TRUE] and [statementAcceptedBool: TRUE]', () async {
        // Arrange
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit()

          // Act
          ..updateScrolledBottom(
            scrolledBottomBool: true,
          )
          ..updateStatementAccepted(
            statementAcceptedBool: true,
          );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.finishButtonEnabledBool, isTrue);
      });

      test('Should [return FALSE] if [scrolledBottomBool: FALSE]', () async {
        // Arrange
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit()

          // Act
          ..updateStatementAccepted(
            statementAcceptedBool: true,
          );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.finishButtonEnabledBool, isFalse);
      });

      test('Should [return FALSE] if [statementAcceptedBool: FALSE]', () async {
        // Arrange
        mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit()

          // Act
          ..updateScrolledBottom(
            scrolledBottomBool: true,
          );

        // Assert
        expect(mnemonicFormGeneratedCubit.state.finishButtonEnabledBool, isFalse);
      });
    });
  });
}
