import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/selection_wrapper.dart';

class HorizontalListItem extends StatelessWidget {
  final Widget iconWidget;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final Widget? trailingWidget;
  final bool selectedBool;
  final bool selectionEnabledBool;
  final ValueChanged<bool>? onSelectValueChanged;

  const HorizontalListItem({
    required this.iconWidget,
    this.titleWidget,
    this.subtitleWidget,
    this.trailingWidget,
    this.selectedBool = false,
    this.selectionEnabledBool = false,
    this.onSelectValueChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget listItemWidget = Row(
      children: <Widget>[
        Container(
          width: 68,
          height: 68,
          padding: const EdgeInsets.all(8),
          child: iconWidget,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (titleWidget != null) ...<Widget>[
                titleWidget!,
                const SizedBox(height: 1),
              ],
              if (subtitleWidget != null) subtitleWidget!,
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (trailingWidget != null) trailingWidget!,
          ],
        )
      ],
    );

    if (selectionEnabledBool) {
      listItemWidget = SelectionWrapper(
        selectedBool: selectedBool,
        onSelectValueChanged: onSelectValueChanged ?? (_){},
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
