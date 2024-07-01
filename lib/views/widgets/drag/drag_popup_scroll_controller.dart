import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/drag/drag_popup_cursor_controller.dart';

class DragPopupScrollController extends ScrollController {
  final DragPopupCursorController _dragPopupCursorController;
  final double _scrollStep;

  Timer? _scrollTimer;

  DragPopupScrollController({
    required DragPopupCursorController dragPopupCursorController,
    required double scrollStep,
  })  : _scrollStep = scrollStep,
        _dragPopupCursorController = dragPopupCursorController {
    _dragPopupCursorController.addListener(_handleCursorMove);
  }

  @override
  void dispose() {
    _dragPopupCursorController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _handleCursorMove() {
    if (_dragPopupCursorController.isOverScrollArea) {
      _beginScrollTimer();
    } else {
      _disposeScrollTimer();
    }
  }

  void _beginScrollTimer() {
    _scrollTimer ??= Timer(const Duration(milliseconds: 500), _updateScrollPosition);
  }

  void _disposeScrollTimer() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  void _updateScrollPosition() {
    if (positions.isEmpty) {
      return;
    }
    if (_dragPopupCursorController.isOverTopScrollArea) {
      _scrollUp();
    } else if (_dragPopupCursorController.isOverBottomScrollArea) {
      _scrollDown();
    }
  }

  void _scrollUp() {
    double newOffset = offset - _scrollStep;
    if (newOffset > 0) {
      _scrollTo(newOffset);
    } else {
      _scrollTo(0);
    }
  }

  void _scrollDown() {
    double newOffset = offset + _scrollStep;
    double maxScrollExtent = position.maxScrollExtent;
    double strictMaxScrollExtent = maxScrollExtent - maxScrollExtent % _scrollStep;
    if (newOffset < strictMaxScrollExtent) {
      _scrollTo(newOffset);
    } else {
      return;
    }
  }

  void _scrollTo(double offset) {
    _scrollTimer?.cancel();
    _scrollTimer = null;

    animateTo(
      offset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );

    _beginScrollTimer();
  }
}
