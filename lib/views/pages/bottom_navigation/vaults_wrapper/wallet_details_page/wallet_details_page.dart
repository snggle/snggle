import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_transaction_list.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_scan_icon.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/eth_address_preview.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';

@RoutePage<void>()
class WalletDetailsPage extends StatefulWidget {
  final PasswordModel vaultPasswordModel;
  final VaultModel vaultModel;
  final NetworkGroupModel networkGroupModel;
  final WalletModel walletModel;
  final WalletDetailsPageCubit walletDetailsPageCubit;

  const WalletDetailsPage({
    required this.vaultPasswordModel,
    required this.vaultModel,
    required this.networkGroupModel,
    required this.walletModel,
    required this.walletDetailsPageCubit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends State<WalletDetailsPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.walletDetailsPageCubit.refresh();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<WalletDetailsPageCubit, WalletDetailsPageState>(
      bloc: widget.walletDetailsPageCubit,
      builder: (BuildContext context, WalletDetailsPageState walletDetailsPageState) {
        return CustomScaffold(
          title: widget.walletModel.name,
          popAvailableBool: walletDetailsPageState.isSelectionEnabled == false,
          popButtonVisible: walletDetailsPageState.isSelectionEnabled,
          customPopCallback: walletDetailsPageState.isSelectionEnabled ? () => _handleCustomPop(walletDetailsPageState) : null,
          body: GradientScrollbar(
            scrollController: scrollController,
            visibleBool: walletDetailsPageState.isEmpty == false,
            margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
            child: CustomScrollView(
              controller: scrollController,
              shrinkWrap: walletDetailsPageState.isScrollDisabled,
              physics: walletDetailsPageState.isScrollDisabled ? const NeverScrollableScrollPhysics() : null,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Center(
                    child: CopyWrapper(
                      value: widget.walletModel.address,
                      onTap: _showQrPage,
                      child: Column(
                        children: <Widget>[
                          QrImageView(data: widget.walletModel.address, size: 136),
                          GradientText(
                            widget.walletModel.getShortAddress(8),
                            gradient: AppColors.primaryGradient,
                            textStyle: textTheme.bodyMedium?.copyWith(letterSpacing: 2.5, height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 6)),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      widget.walletModel.derivationPath,
                      style: textTheme.labelMedium?.copyWith(letterSpacing: 2.5, height: 1, color: AppColors.darkGrey),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: Center(
                    child: GradientOutlinedButton.small(
                      label: 'Connect Wallet',
                      onPressed: () {
                        AutoRouter.of(context).navigate(WalletConnectRoute(
                          walletModel: widget.walletModel,
                          vaultModel: widget.vaultModel,
                          vaultPasswordModel: widget.vaultPasswordModel,
                          networkTemplateModel: widget.networkGroupModel.networkTemplateModel,
                        ));
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Transaction History',
                      style: textTheme.bodyMedium?.copyWith(color: AppColors.body3, height: 1),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: WalletDetailsTransactionList(
                    emptyBool: walletDetailsPageState.isEmpty,
                    loadingBool: walletDetailsPageState.loadingBool,
                    selectionEnabledBool: walletDetailsPageState.isSelectionEnabled,
                    transactions: walletDetailsPageState.transactions,
                    selectionModel: walletDetailsPageState.selectionModel,
                    walletDetailsPageCubit: widget.walletDetailsPageCubit,
                    networkGroupModel: widget.networkGroupModel,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: CustomBottomNavigationBar.height)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCustomPop(WalletDetailsPageState walletDetailsPageState) {
    if (walletDetailsPageState.isSelectionEnabled) {
      _cancelSelection();
    }
  }

  void _cancelSelection() {
    widget.walletDetailsPageCubit.disableSelection();
    BottomNavigationWrapper.of(context).hideTooltip();
  }

  Future<void> _showQrPage() async {
    TextTheme textTheme = Theme.of(context).textTheme;

    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return QRResultScaffold.fromPlaintext(
          title: widget.walletModel.name,
          plaintext: widget.walletModel.address,
          qrCodeGap: 0,
          tooltip: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomBottomNavigationBarScanIcon(foregroundColor: AppColors.darkGrey),
            ],
          ),
          child: LabelWrapperVertical(
            label: '',
            bottomBorderVisibleBool: false,
            child: ETHAddressPreview(
              address: widget.walletModel.address,
              textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
            ),
          ),
        );
      },
    );
  }
}
