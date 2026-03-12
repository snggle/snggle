import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class TxConfirmationScaffold extends StatelessWidget {
  final String title;
  final VoidCallback onSignPressed;
  final Widget transactionBodyWidget;

  const TxConfirmationScaffold({
    required this.title,
    required this.onSignPressed,
    required this.transactionBodyWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return CustomScaffold(
      title: title,
      body: BottomTooltipWrapper(
        tooltip: BottomTooltip(
          actions: <Widget>[
            BottomTooltipItem(
              assetIconData: AppIcons.menu_save,
              label: 'Sign',
              onTap: onSignPressed,
            ),
          ],
        ),
        child: GradientScrollbar(
          scrollController: scrollController,
          margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: transactionBodyWidget,
          ),
        ),
      ),
    );
  }
}
