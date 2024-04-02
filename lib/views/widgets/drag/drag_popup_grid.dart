import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/drag/drag_config.dart';
import 'package:snggle/views/widgets/drag/drag_popup_cursor_controller.dart';
import 'package:snggle/views/widgets/drag/drag_popup_grid_background.dart';
import 'package:snggle/views/widgets/drag/drag_popup_scroll_controller.dart';
import 'package:snggle/views/widgets/drag/source/custom_draggable.dart';
import 'package:snggle/views/widgets/generic/sliver_grid_delegate_with_max_spacing_extend.dart';

typedef DragPopupItemBuilder = Widget Function(BuildContext context, int index);

class DragPopupGrid extends StatefulWidget {
  static const Size gridItemSize = Size(80, 144);

  final int itemsCount;
  final double minimalVerticalSpacing;
  final double minimalHorizontalSpacing;
  final EdgeInsets overlayPadding;
  final GlobalKey gridLayoutKey;
  final DragPopupCursorController dragPopupPositionController;
  final DragPopupItemBuilder itemBuilder;
  final ValueChanged<DragConfig> onAccept;
  final double bottomMargin;
  final double totalItemHeight;

  DragPopupGrid({
    required this.itemsCount,
    required this.minimalVerticalSpacing,
    required this.minimalHorizontalSpacing,
    required this.overlayPadding,
    required this.gridLayoutKey,
    required this.dragPopupPositionController,
    required this.itemBuilder,
    required this.onAccept,
    this.bottomMargin = 100,
    super.key,
  }) : totalItemHeight = gridItemSize.height + minimalVerticalSpacing;

  @override
  State<StatefulWidget> createState() => _DragPopupGridState();
}

class _DragPopupGridState extends State<DragPopupGrid> {
  late final DragPopupScrollController dragPopupScrollController = DragPopupScrollController(
    dragPopupCursorController: widget.dragPopupPositionController,
    scrollStep: widget.totalItemHeight,
  );

  Timer? scrollTimer;
  double widget1Opacity = 0.2;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _setupGridArea());
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => widget1Opacity = 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget1Opacity,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: widget.bottomMargin),
        child: SizedBox(
          key: widget.gridLayoutKey,
          child: CustomDragTarget<DragConfig>(
            onAccept: widget.onAccept,
            onMove: _handleGridHover,
            builder: (BuildContext context, List<DragConfig?> candidateData, List<dynamic> rejectedData) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 33, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.middleGrey, width: 1),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DragPopupGridBackground(
                        itemSize: DragPopupGrid.gridItemSize,
                        minimalVerticalSpacing: widget.minimalVerticalSpacing,
                        minimalHorizontalSpacing: widget.minimalHorizontalSpacing,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(top: widget.minimalVerticalSpacing),
                        child: GridView.builder(
                          controller: dragPopupScrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithMaxSpacingExtend(
                            minimalVerticalSpacing: widget.minimalVerticalSpacing,
                            minimalHorizontalSpacing: widget.minimalHorizontalSpacing,
                            itemSize: DragPopupGrid.gridItemSize,
                          ),
                          itemCount: widget.itemsCount + 6,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < widget.itemsCount) {
                              return widget.itemBuilder(context, index);
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleGridHover(DragTargetDetails<DragConfig> details) {
    widget.dragPopupPositionController.setCursorOffset(details.offset);
  }

  void _setupGridArea() {
    RenderBox? gridRenderBox = widget.gridLayoutKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridRenderBox == null) {
      throw StateError('Grid layout key is not attached to the widget');
    }

    Offset position = gridRenderBox.localToGlobal(Offset.zero);
    double gridYStart = position.dy - widget.overlayPadding.top;
    double gridYEnd = gridYStart + gridRenderBox.size.height;

    widget.dragPopupPositionController.setGridArea(gridYStart, gridYEnd);
  }
}
