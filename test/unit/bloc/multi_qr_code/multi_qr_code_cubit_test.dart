import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/multi_qr_code/multi_qr_code_cubit.dart';

void main() {
  late MultiQrCodeCubit actualMultiQrCodeCubit;

  setUp(() {
    actualMultiQrCodeCubit = MultiQrCodeCubit(maxCharacters: 200, qrAnimationDuration: const Duration(milliseconds: 200));
  });

  group('Tests of MultiQrCodeCubit States:', () {
    test('Should return state of that matches the initial MultiQrCodeState', () {
      // Arrange
      MultiQrCodeState expectedMultiQrCodeState = const MultiQrCodeState(maxCharacters: 200, qrAnimationDuration: Duration(milliseconds: 200));

      //  Assert
      expect(actualMultiQrCodeCubit.state, expectedMultiQrCodeState);
    });

    blocTest<MultiQrCodeCubit, MultiQrCodeState>(
      'Should emit a new state with a updated Max QR Characters value',
      // Arrange
      build: () {
        return actualMultiQrCodeCubit;
      },

      // Act
      act: (_) => actualMultiQrCodeCubit.toggleMaxCharacters(500),

      // Assert
      expect: () => <MultiQrCodeState>[const MultiQrCodeState(maxCharacters: 500, qrAnimationDuration: Duration(milliseconds: 200))],
    );
    blocTest<MultiQrCodeCubit, MultiQrCodeState>(
      'Should emit a new state with a updated QR animation duration value',
      // Arrange
      build: () {
        return actualMultiQrCodeCubit;
      },

      // Act
      act: (_) => actualMultiQrCodeCubit.toggleQrAnimationDuration(const Duration(milliseconds: 1000)),

      // Assert
      expect: () => <MultiQrCodeState>[const MultiQrCodeState(maxCharacters: 200, qrAnimationDuration: Duration(milliseconds: 1000))],
    );
  });
}
