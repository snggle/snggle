import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/transaction_list_item/transaction_list_item_context_tooltip.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/transaction_list_item/transaction_list_item_expansion.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/transaction_list_item/transaction_list_item_layout.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/transaction_list_item/transaction_list_item_page_tooltip.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/transaction_list_item/transaction_list_item_title.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

class TransactionListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final TransactionModel transactionModel;
  final WalletDetailsPageCubit walletDetailsPageCubit;
  final NetworkTemplateModel networkTemplateModel;

  const TransactionListItem({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.transactionModel,
    required this.walletDetailsPageCubit,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> with SingleTickerProviderStateMixin {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();

  late AnimationController animationController;
  late Animation<double> opacityFactor;
  late Animation<double> heightFactor;
  late Timer refreshTimer;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    heightFactor = animationController.drive(CurveTween(curve: Curves.easeIn));
    opacityFactor = animationController.drive(Tween<double>(begin: 1, end: 0));

    refreshTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      _refreshView();
    });
  }

  @override
  void dispose() {
    actionsPopupController.dispose();
    animationController.dispose();
    refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedBuilder(
      animation: animationController.view,
      builder: (BuildContext context, _) {
        return TransactionListItemLayout(
          backgroundOpacity: 1 - opacityFactor.value,
          expansionHeight: heightFactor.value,
          animationController: animationController,
          titleWidget: Builder(
            builder: (BuildContext context) {
              Widget child = TransactionListItemTitle(
                selectedBool: widget.selectedBool,
                selectionEnabledBool: widget.selectionEnabledBool,
                detailsOpacity: opacityFactor.value,
                transactionModel: widget.transactionModel,
              );

              if (widget.selectionEnabledBool) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleSelection,
                  child: child,
                );
              } else {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleExpansion,
                  child: child,
                );
              }
            },
          ),
          expansionWidget: TransactionListItemExpansion(transactionModel: widget.transactionModel),
        );
      },
    );

    if (widget.selectionEnabledBool) {
      return child;
    } else {
      return ContextTooltipWrapper(
        pressType: PressType.longPress,
        controller: actionsPopupController,
        content: TransactionListItemContextTooltip(
          transactionModel: widget.transactionModel,
          walletDetailsPageCubit: widget.walletDetailsPageCubit,
          networkTemplateModel: widget.networkTemplateModel,
          pageTooltip: TransactionListItemPageTooltip(
            walletDetailsPageCubit: widget.walletDetailsPageCubit,
          ),
          onCloseToolbar: _closeToolbar,
        ),
        child: child,
      );
    }
  }

  Future<void> _refreshView() async {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleSelection() {
    widget.walletDetailsPageCubit.toggleSelection(widget.transactionModel);
  }

  void _toggleExpansion() {
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  void _closeToolbar() {
    actionsPopupController.hideMenu();
  }
}
