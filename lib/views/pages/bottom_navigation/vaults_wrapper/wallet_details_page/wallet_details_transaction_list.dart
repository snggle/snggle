import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/transaction_list_item/transaction_list_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class WalletDetailsTransactionList extends StatelessWidget {
  static const int _loadingItemsCount = 24;

  final bool emptyBool;
  final bool loadingBool;
  final bool selectionEnabledBool;
  final List<TransactionModel> transactions;
  final SimpleSelectionModel<TransactionModel>? selectionModel;
  final WalletDetailsPageCubit walletDetailsPageCubit;
  final NetworkGroupModel networkGroupModel;

  const WalletDetailsTransactionList({
    required this.emptyBool,
    required this.loadingBool,
    required this.selectionEnabledBool,
    required this.transactions,
    required this.selectionModel,
    required this.walletDetailsPageCubit,
    required this.networkGroupModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: <Widget>[
        if (emptyBool && loadingBool == false) ...<Widget>[
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: <Widget>[
                Spacer(),
                Center(child: AssetIcon(AppIcons.page_no_data, size: 34)),
                Spacer(),
                SizedBox(height: CustomBottomNavigationBar.height),
              ],
            ),
          ),
        ] else ...<Widget>[
          SliverList.builder(
            itemCount: loadingBool ? _loadingItemsCount : transactions.length,
            itemBuilder: (BuildContext context, int index) {
              if (loadingBool) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: LoadingContainer(height: 30),
                );
              }
              TransactionModel transactionModel = transactions[index];
              return TransactionListItem(
                key: ValueKey<int>(transactionModel.id),
                selectedBool: selectionModel?.selectedItems.contains(transactionModel) ?? false,
                selectionEnabledBool: selectionEnabledBool,
                transactionModel: transactionModel,
                walletDetailsPageCubit: walletDetailsPageCubit,
                networkTemplateModel: networkGroupModel.networkTemplateModel,
              );
            },
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}
