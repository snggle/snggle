import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class TxConfirmationScaffold extends StatelessWidget {
  final String title;
  final Future<void> Function() onSignPressed;
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
              onTap: () async {
                try {
                  await onSignPressed();
                } on InvalidMasterKeyException {
                  if (context.mounted == false) {
                    return;
                  }

                  await MasterKeyDialog.show(context);
                }
              },
            ),
          ],
        ),
        child: GradientScrollbar(
          scrollController: scrollController,
          margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.contentHeight),
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
