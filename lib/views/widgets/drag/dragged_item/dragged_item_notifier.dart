import 'package:flutter/material.dart';

class DraggedItemNotifier extends ValueNotifier<double> {
  DraggedItemNotifier() : super(1.0);

  void notifyTargetHovered() {
    value = 0.6;
  }

  void notifyBoundaryCrossed() {
    value = 0.6;
  }

  void notifyTargetLeft() {
    value = 1.0;
  }
}
