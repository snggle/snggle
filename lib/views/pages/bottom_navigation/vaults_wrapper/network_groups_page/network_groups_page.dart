import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/network_groups_page/network_groups_page_cubit.dart';
import 'package:snggle/bloc/network_groups_page/network_groups_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/wallets_preview_icon.dart';

@RoutePage()
class NetworkGroupsPage extends StatefulWidget {
  final VaultListItemModel vaultListItemModel;
  final PasswordModel vaultPasswordModel;

  const NetworkGroupsPage({
    required this.vaultListItemModel,
    required this.vaultPasswordModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupsPageState();
}

class _NetworkGroupsPageState extends State<NetworkGroupsPage> {
  static const int loadingItemsCount = 24;

  late final NetworkGroupsPageCubit networkGroupsPageCubit = NetworkGroupsPageCubit(
    vaultModel: widget.vaultListItemModel.vaultModel,
    vaultPasswordModel: widget.vaultPasswordModel,
  );

  @override
  void initState() {
    networkGroupsPageCubit.refreshAll();
    super.initState();
  }

  @override
  void dispose() {
    networkGroupsPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<NetworkGroupsPageCubit, NetworkGroupsPageState>(
      bloc: networkGroupsPageCubit,
      builder: (BuildContext context, NetworkGroupsPageState networkGroupsPageState) {
        return Scaffold(
          appBar: CustomAppBar(
            title: widget.vaultListItemModel.name,
            popButtonVisible: true,
          ),
          body: CustomScrollView(
            shrinkWrap: networkGroupsPageState.isScrollDisabled,
            physics: networkGroupsPageState.isScrollDisabled ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.builder(
                  itemCount: networkGroupsPageState.loadingBool
                      ? loadingItemsCount
                      : (networkGroupsPageState.allNetworks.length + (networkGroupsPageState.searchPattern == null ? 1 : 0)),
                  itemBuilder: (BuildContext context, int index) {
                    if( networkGroupsPageState.loadingBool ) {
                      return const SizedBox(height: 100);
                    }

                    bool buttonItemBool = index == networkGroupsPageState.allNetworks.length;
                    if (buttonItemBool) {
                      return HorizontalListItem(
                        iconWidget: SquareOutlinedButton(
                          icon: Icon(AppIcons.add, size: 35, color: AppColors.middleGrey),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    child: Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text('Add wallet'),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () => networkGroupsPageCubit.createNewWallet('kira'),
                                              child: const Text('KIRA'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => networkGroupsPageCubit.createNewWallet('ethereum'),
                                              child: const Text('Ethereum'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => networkGroupsPageCubit.createNewWallet('polkadot'),
                                              child: const Text('Polkadot'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => networkGroupsPageCubit.createNewWallet('bitcoin'),
                                              child: const Text('Bitcoin'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => networkGroupsPageCubit.createNewWallet('cosmos'),
                                              child: const Text('Cosmos'),
                                            ),
                                          ],
                                        )),
                                  );
                                });
                          },
                          radius: 17,
                        ),
                      );
                    }

                    NetworkGroupListItemModel networkGroupListItemModel = networkGroupsPageState.allNetworks[index];

                    return GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).push<void>(
                          WalletListRoute(
                            vaultListItemModel: widget.vaultListItemModel,
                            vaultPasswordModel: PasswordModel.defaultPassword(),
                            parentContainerModel: networkGroupListItemModel,
                          ),
                        );
                      },
                      child: HorizontalListItem(
                        iconWidget: WalletsPreviewIcon(
                          radius: 17,
                          lockedBool: false,
                          pinnedBool: false,
                          wallets: networkGroupListItemModel.walletsPreview,
                          padding: 8,
                        ),
                        titleWidget: Text(networkGroupListItemModel.networkConfigModel.name),
                        trailingWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GradientIcon(networkGroupListItemModel.networkConfigModel.iconData, gradient: AppColors.primaryGradient, size: 20),
                            const SizedBox(height: 6),
                            Text(
                              networkGroupListItemModel.walletsPreview.length.toString(),
                              style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
