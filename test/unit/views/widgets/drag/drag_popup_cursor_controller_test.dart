import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/views/widgets/drag/drag_popup_cursor_controller.dart';

// ignore_for_file: cascade_invocations
void main() {
  group('Tests of DragPopupCursorController.setCursorOffset()', () {
    test('Should [update cursor offset] with given offset reduced by list item size', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController();

      // Act
      actualDragPopupCursorController.setCursorOffset(const Offset(100, 100));

      // Assert
      DragPopupCursorController expectedDragPopupCursorController = DragPopupCursorController(
        cursorOffset: const Offset(60, 60),
      );

      expect(actualDragPopupCursorController, expectedDragPopupCursorController);
    });
  });

  group('Tests of DragPopupCursorController.setGridArea()', () {
    test('Should [update grid area] with given start and end Y positions', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController();

      // Act
      actualDragPopupCursorController.setGridArea(100, 200);

      // Assert
      DragPopupCursorController expectedDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 200,
      );

      expect(actualDragPopupCursorController, expectedDragPopupCursorController);
    });
  });

  group('Tests of DragPopupCursorController.isOutsideGridArea getter', () {
    test('Should [return TRUE] if [cursor OUTSIDE] grid area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 200,
        cursorOffset: const Offset(50, 50),
      );

      // Act
      bool actualIsOutsideGridArea = actualDragPopupCursorController.isOutsideGridArea;

      // Assert
      expect(actualIsOutsideGridArea, true);
    });

    test('Should [return FALSE] if [cursor INSIDE] grid area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 200,
        cursorOffset: const Offset(150, 150),
      );

      // Act
      bool actualIsOutsideGridArea = actualDragPopupCursorController.isOutsideGridArea;

      // Assert
      expect(actualIsOutsideGridArea, false);
    });
  });

  group('Tests of DragPopupCursorController.isInsideGridArea getter', () {
    test('Should [return TRUE] if [cursor INSIDE] grid area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 200,
        cursorOffset: const Offset(150, 150),
      );

      // Act
      bool actualIsInsideGridArea = actualDragPopupCursorController.isInsideGridArea;

      // Assert
      expect(actualIsInsideGridArea, true);
    });

    test('Should [return FALSE] if [cursor OUTSIDE] grid area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 200,
        cursorOffset: const Offset(50, 50),
      );

      // Act
      bool actualIsInsideGridArea = actualDragPopupCursorController.isInsideGridArea;

      // Assert
      expect(actualIsInsideGridArea, false);
    });
  });

  group('Tests of DragPopupCursorController.isOverScrollArea getter', () {
    test('Should [return TRUE] if [cursor OVER TOP] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 110),
      );

      // Act
      bool actualIsOverScrollArea = actualDragPopupCursorController.isOverScrollArea;

      // Assert
      expect(actualIsOverScrollArea, true);
    });

    test('Should [return TRUE] if [cursor OVER BOTTOM] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 490),
      );

      // Act
      bool actualIsOverScrollArea = actualDragPopupCursorController.isOverScrollArea;

      // Assert
      expect(actualIsOverScrollArea, true);
    });

    test('Should [return FALSE] if [cursor OUTSIDE] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(300, 300),
      );

      // Act
      bool actualIsOverScrollArea = actualDragPopupCursorController.isOverScrollArea;

      // Assert
      expect(actualIsOverScrollArea, false);
    });
  });

  group('Tests of DragPopupCursorController.isOverBottomScrollArea getter', () {
    test('Should [return TRUE] if [cursor OVER BOTTOM] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 490),
      );

      // Act
      bool actualIsOverBottomScrollArea = actualDragPopupCursorController.isOverBottomScrollArea;

      // Assert
      expect(actualIsOverBottomScrollArea, true);
    });

    test('Should [return FALSE] if [cursor OVER TOP] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 110),
      );

      // Act
      bool actualIsOverBottomScrollArea = actualDragPopupCursorController.isOverBottomScrollArea;

      // Assert
      expect(actualIsOverBottomScrollArea, false);
    });

    test('Should [return FALSE] if [cursor OUTSIDE] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 300),
      );

      // Act
      bool actualIsOverBottomScrollArea = actualDragPopupCursorController.isOverBottomScrollArea;

      // Assert
      expect(actualIsOverBottomScrollArea, false);
    });
  });

  group('Tests of DragPopupCursorController.isOverTopScrollArea getter', () {
    test('Should [return TRUE] if [cursor OVER TOP] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 110),
      );

      // Act
      bool actualIsOverTopScrollArea = actualDragPopupCursorController.isOverTopScrollArea;

      // Assert
      expect(actualIsOverTopScrollArea, true);
    });

    test('Should [return FALSE] if [cursor OVER BOTTOM] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 490),
      );

      // Act
      bool actualIsOverTopScrollArea = actualDragPopupCursorController.isOverTopScrollArea;

      // Assert
      expect(actualIsOverTopScrollArea, false);
    });

    test('Should [return FALSE] if [cursor OUTSIDE] scroll area', () {
      // Arrange
      DragPopupCursorController actualDragPopupCursorController = DragPopupCursorController(
        gridStartYPosition: 100,
        gridEndYPosition: 500,
        cursorOffset: const Offset(150, 300),
      );

      // Act
      bool actualIsOverTopScrollArea = actualDragPopupCursorController.isOverTopScrollArea;

      // Assert
      expect(actualIsOverTopScrollArea, false);
    });
  });
}
