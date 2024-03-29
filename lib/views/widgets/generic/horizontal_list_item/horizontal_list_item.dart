import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/generic/selection_wrapper.dart';

class HorizontalListItem extends StatefulWidget {
  final Widget iconWidget;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final Widget? trailingWidget;
  final bool selectedBool;
  final bool selectionEnabledBool;
  final ValueChanged<bool>? onSelectValueChanged;
  final AnimationController? fadeAnimationController;
  final AnimationController? slideAnimationController;
  final HorizontalListItemAnimationType horizontalListItemAnimationType;

  const HorizontalListItem({
    required this.iconWidget,
    this.titleWidget,
    this.subtitleWidget,
    this.trailingWidget,
    this.selectedBool = false,
    this.selectionEnabledBool = false,
    this.onSelectValueChanged,
    this.fadeAnimationController,
    this.slideAnimationController,
    this.horizontalListItemAnimationType = HorizontalListItemAnimationType.none,
    super.key,
  });

  bool get hasAnimationControllers => fadeAnimationController != null && slideAnimationController != null;

  @override
  _HorizontalListItemState createState() => _HorizontalListItemState();
}

class _HorizontalListItemState extends State<HorizontalListItem> {
  @override
  Widget build(BuildContext context) {
    Widget? titleWidget = widget.titleWidget;
    Widget? subtitleWidget = widget.subtitleWidget;
    Widget iconWidget = Container(
      width: 68,
      height: 68,
      padding: const EdgeInsets.all(8),
      child: widget.iconWidget,
    );

    bool animationEnabledBool = widget.horizontalListItemAnimationType != HorizontalListItemAnimationType.none && widget.hasAnimationControllers;

    if (titleWidget != null && animationEnabledBool) {
      titleWidget = ClipRect(
        child: FadeTransition(
          opacity: widget.fadeAnimationController!,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: switch (widget.horizontalListItemAnimationType) {
                HorizontalListItemAnimationType.slideLeftToRight => const Offset(-0.5, 0),
                HorizontalListItemAnimationType.slideBottomToUp => const Offset(0, 0.5),
                (_) => Offset.zero,
              },
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: widget.slideAnimationController!,
              curve: Curves.fastLinearToSlowEaseIn,
            )),
            child: titleWidget,
          ),
        ),
      );
    }

    if (subtitleWidget != null && animationEnabledBool) {
      subtitleWidget = ClipRect(
        child: FadeTransition(
          opacity: widget.fadeAnimationController!,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: switch (widget.horizontalListItemAnimationType) {
                HorizontalListItemAnimationType.slideLeftToRight => const Offset(-0.5, 0),
                HorizontalListItemAnimationType.slideBottomToUp => const Offset(0, 0.5),
                (_) => Offset.zero,
              },
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: widget.slideAnimationController!,
              curve: Curves.fastLinearToSlowEaseIn,
            )),
            child: subtitleWidget,
          ),
        ),
      );
    }

    Widget listItemWidget = Row(
      children: <Widget>[
        iconWidget,
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (titleWidget != null) ...<Widget>[
                titleWidget,
                const SizedBox(height: 1),
              ],
              if (subtitleWidget != null) subtitleWidget,
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.trailingWidget != null) widget.trailingWidget!,
          ],
        )
      ],
    );

    if (widget.selectionEnabledBool) {
      listItemWidget = SelectionWrapper(
        selectedBool: widget.selectedBool,
        onSelectValueChanged: widget.onSelectValueChanged ?? (_) {},
        child: listItemWidget,
      );
    }

    listItemWidget = Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6, right: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey1),
        ),
      ),
      child: listItemWidget,
    );

    return listItemWidget;
  }
}
