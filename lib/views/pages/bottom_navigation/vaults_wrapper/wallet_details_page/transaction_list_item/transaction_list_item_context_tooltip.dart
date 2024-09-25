import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_content.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class TransactionListItemContextTooltip extends StatefulWidget {
  final TransactionModel transactionModel;
  final WalletDetailsPageCubit walletDetailsPageCubit;
  final Widget pageTooltip;
  final VoidCallback onCloseToolbar;

  const TransactionListItemContextTooltip({
    required this.transactionModel,
    required this.walletDetailsPageCubit,
    required this.pageTooltip,
    required this.onCloseToolbar,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemContextTooltipState();
}

class _ListItemContextTooltipState extends State<TransactionListItemContextTooltip> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ContextTooltipContent(
      titleWidget: RichText(
        text: TextSpan(
          text: DateFormat('yy/MM/dd HH:mm').format(widget.transactionModel.signDate ?? widget.transactionModel.creationDate),
          style: textTheme.bodyMedium?.copyWith(color: AppColors.middleGrey),
          children: <TextSpan>[
            const TextSpan(text: '  '),
            TextSpan(
              text: switch (widget.transactionModel.signDataType) {
                SignDataType.typedTransaction => 'TX',
                SignDataType.rawBytes => 'TEXT',
              },
              style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
            ),
          ],
        ),
      ),
      actions: <ContextTooltipItem>[
        ContextTooltipItem(
          assetIconData: AppIcons.menu_search,
          label: 'Details',
          onTap: _navigateToTransactionDetails,
        ),
        ContextTooltipItem(
          assetIconData: AppIcons.menu_select,
          label: 'Select',
          onTap: _selectTransaction,
        ),
      ],
    );
  }

  void _navigateToTransactionDetails() {
    widget.onCloseToolbar();
    AutoRouter.of(context).push(TransactionDetailsRoute(transactionModel: widget.transactionModel));
  }

  void _selectTransaction() {
    widget.walletDetailsPageCubit.select(widget.transactionModel);
    widget.onCloseToolbar();
    _showBottomNavigationTooltip();
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(widget.pageTooltip);
  }
}
