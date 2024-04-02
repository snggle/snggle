import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';

class DraggedItemWrapper extends StatefulWidget {
  static const double size = 80;

  final DraggedItemNotifier draggedItemNotifier;
  final Widget child;

  const DraggedItemWrapper({
    required this.draggedItemNotifier,
    required this.child,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DraggedItemWrapperState();
}

class _DraggedItemWrapperState extends State<DraggedItemWrapper> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.draggedItemNotifier,
      builder: (BuildContext context, double scale, Widget? child) {
        return AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: SizedBox(width: DraggedItemWrapper.size, height: DraggedItemWrapper.size, child: widget.child),
    );
  }
}
