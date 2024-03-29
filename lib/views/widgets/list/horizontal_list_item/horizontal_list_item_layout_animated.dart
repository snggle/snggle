import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';

class HorizontalListItemLayoutAnimated extends StatefulWidget {
  final Widget iconWidget;
  final AnimationController fadeAnimationController;
  final AnimationController slideAnimationController;
  final HorizontalListItemAnimationType horizontalListItemAnimationType;
  final bool lockedBool;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final Widget? trailingWidget;

  const HorizontalListItemLayoutAnimated({
    required this.iconWidget,
    required this.fadeAnimationController,
    required this.slideAnimationController,
    required this.horizontalListItemAnimationType,
    this.lockedBool = false,
    this.titleWidget,
    this.subtitleWidget,
    this.trailingWidget,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HorizontalListItemLayoutAnimatedState();
}

class _HorizontalListItemLayoutAnimatedState extends State<HorizontalListItemLayoutAnimated> {
  @override
  Widget build(BuildContext context) {
    Widget? animatedTitleWidget;
    Widget? animatedSubtitleWidget;

    if (widget.titleWidget != null) {
      animatedTitleWidget = ClipRect(
        child: FadeTransition(
          opacity: widget.fadeAnimationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: switch (widget.horizontalListItemAnimationType) {
                HorizontalListItemAnimationType.slideLeftToRight => const Offset(-0.5, 0),
                HorizontalListItemAnimationType.slideBottomToUp => const Offset(0, 0.5),
              },
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: widget.slideAnimationController,
              curve: Curves.fastLinearToSlowEaseIn,
            )),
            child: widget.titleWidget,
          ),
        ),
      );
    }

    if (widget.subtitleWidget != null) {
      animatedSubtitleWidget = ClipRect(
        child: FadeTransition(
          opacity: widget.fadeAnimationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: switch (widget.horizontalListItemAnimationType) {
                HorizontalListItemAnimationType.slideLeftToRight => const Offset(-0.5, 0),
                HorizontalListItemAnimationType.slideBottomToUp => const Offset(0, 0.5),
              },
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: widget.slideAnimationController,
              curve: Curves.fastLinearToSlowEaseIn,
            )),
            child: widget.subtitleWidget,
          ),
        ),
      );
    }

    return HorizontalListItemLayout(
      iconWidget: widget.iconWidget,
      lockedBool: widget.lockedBool,
      titleWidget: animatedTitleWidget,
      subtitleWidget: animatedSubtitleWidget,
      trailingWidget: widget.trailingWidget,
    );
  }
}
