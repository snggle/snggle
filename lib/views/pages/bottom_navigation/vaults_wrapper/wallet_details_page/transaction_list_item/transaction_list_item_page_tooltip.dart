import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class TransactionListItemPageTooltip extends StatefulWidget {
  final WalletDetailsPageCubit walletDetailsPageCubit;

  const TransactionListItemPageTooltip({
    required this.walletDetailsPageCubit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TransactionListItemPageTooltipState();
}

class _TransactionListItemPageTooltipState extends State<TransactionListItemPageTooltip> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletDetailsPageCubit, WalletDetailsPageState>(
      bloc: widget.walletDetailsPageCubit,
      builder: (BuildContext buildContext, WalletDetailsPageState walletDetailsPageState) {
        SimpleSelectionModel<TransactionModel> selectionModel = walletDetailsPageState.selectionModel!;

        return BottomTooltip(
          backgroundColor: AppColors.body2,
          actions: <BottomTooltipItem>[
            BottomTooltipItem(
              assetIconData: selectionModel.areAllItemsSelected ? AppIcons.menu_unselect_all : AppIcons.menu_select_all,
              label: selectionModel.areAllItemsSelected ? 'Clear' : 'All',
              onTap: selectionModel.areAllItemsSelected ? widget.walletDetailsPageCubit.unselectAll : widget.walletDetailsPageCubit.selectAll,
            ),
            BottomTooltipItem(
              assetIconData: AppIcons.menu_delete,
              label: 'Delete',
              onTap: selectionModel.selectedItems.isEmpty ? null : _pressDeleteButton,
            ),
          ],
        );
      },
    );
  }

  void _pressDeleteButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Delete',
        content: 'Are you sure you want to delete selected items?',
        onConfirm: () {
          widget.walletDetailsPageCubit.deleteSelected();
          _closeTooltip();
        },
      ),
    );
  }

  void _closeTooltip() {
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
