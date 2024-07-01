import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_wrapper.dart';

class DragPopupCursorController extends ChangeNotifier with EquatableMixin {
  static const double _scrollDetectorHeight = 100;

  late double _gridStartYPosition;
  late double _gridEndYPosition;
  late Offset _cursorOffset;

  DragPopupCursorController({
    double? gridStartYPosition,
    double? gridEndYPosition,
    Offset? cursorOffset,
  }) {
    _gridStartYPosition = gridStartYPosition ?? 0;
    _gridEndYPosition = gridEndYPosition ?? 0;
    _cursorOffset = cursorOffset ?? Offset.zero;
  }

  void setCursorOffset(Offset offset) {
    double dragItemSize = DraggedItemWrapper.size;

    _cursorOffset = Offset(offset.dx - dragItemSize / 2, offset.dy - dragItemSize / 2);
    notifyListeners();
  }

  void setGridArea(double startYPosition, double endYPosition) {
    _gridStartYPosition = startYPosition;
    _gridEndYPosition = endYPosition;
  }

  bool get isOutsideGridArea {
    return isInsideGridArea == false;
  }

  bool get isInsideGridArea {
    return _cursorOffset.dy > _gridStartYPosition && _cursorOffset.dy < _gridEndYPosition;
  }

  bool get isOverScrollArea {
    return isOverBottomScrollArea || isOverTopScrollArea;
  }

  bool get isOverBottomScrollArea {
    return _cursorOffset.dy < _gridEndYPosition && _cursorOffset.dy > (_gridEndYPosition - _scrollDetectorHeight);
  }

  bool get isOverTopScrollArea {
    return _cursorOffset.dy > _gridStartYPosition && _cursorOffset.dy < (_gridStartYPosition + _scrollDetectorHeight);
  }

  @override
  List<Object?> get props => <Object>[_gridStartYPosition, _gridEndYPosition, _cursorOffset];
}
