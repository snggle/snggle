import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class ScrollableLayout extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final bool bottomMarginVisibleBool;
  final bool tooltipVisibleBool;
  final List<Widget>? tooltipItems;
  final Widget? tooltip;

  const ScrollableLayout({
    required this.child,
    required this.scrollController,
    this.bottomMarginVisibleBool = true,
    this.tooltipVisibleBool = true,
    this.tooltipItems,
    this.tooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget formChild = Padding(
      padding: const EdgeInsets.only(left: 16, right: 3),
      child: GradientScrollbar(
        scrollController: scrollController,
        margin: EdgeInsets.only(bottom: bottomMarginVisibleBool ? 80 : 10),
        child: Padding(
          padding: const EdgeInsets.only(right: 13),
          child: child,
        ),
      ),
    );

    if (tooltip != null) {
      return BottomTooltipWrapper(
        tooltipVisibleBool: tooltipVisibleBool,
        tooltip: tooltip!,
        child: formChild,
      );
    }

    if (tooltipItems != null && tooltipItems!.isNotEmpty) {
      return BottomTooltipWrapper(
        blurBackgroundBool: false,
        tooltipVisibleBool: tooltipVisibleBool,
        tooltip: BottomTooltip(
          backgroundColor: AppColors.body2,
          actions: tooltipItems!,
        ),
        child: formChild,
      );
    } else {
      return formChild;
    }
  }
}
