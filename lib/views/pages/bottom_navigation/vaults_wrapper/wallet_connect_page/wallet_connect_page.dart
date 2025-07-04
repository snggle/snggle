import 'package:auto_route/auto_route.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_connect_option.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_option_button.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_qr_connect_page.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class WalletConnectPage extends StatefulWidget {
  final VaultModel vaultModel;
  final WalletModel walletModel;
  final NetworkTemplateModel networkTemplateModel;

  const WalletConnectPage({
    required this.vaultModel,
    required this.walletModel,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();

  late final WalletConnectPageCubit walletConnectPageCubit = WalletConnectPageCubit(
    vaultModel: widget.vaultModel,
    walletModel: widget.walletModel,
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return CustomScaffold(
      title: 'Connect Wallet',
      popAvailableBool: true,
      popButtonVisible: true,
      body: BlocBuilder<WalletConnectPageCubit, WalletConnectPageState>(
        bloc: walletConnectPageCubit,
        builder: (BuildContext context, WalletConnectPageState walletConnectPageState) {
          return Column(
            children: <Widget>[
              Text(
                'Choose a connection method',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  WalletConnectOptionButton(
                    selectedBool: walletConnectPageState.walletConnectOption == WalletConnectOption.qr,
                    label: 'QR based',
                    icon: AppIcons.connect_wallet_qr,
                    onTap: () => walletConnectPageCubit.changeConnectOption(WalletConnectOption.qr),
                  ),
                  WalletConnectOptionButton(
                    selectedBool: walletConnectPageState.walletConnectOption == WalletConnectOption.hardware,
                    label: 'Hardware based',
                    icon: AppIcons.connect_wallet_hardware,
                    onTap: () => walletConnectPageCubit.changeConnectOption(WalletConnectOption.hardware),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    if (walletConnectPageState.walletConnectOption == WalletConnectOption.qr) ...<Widget>[
                      GradientOutlinedButton.large(
                        label: 'Single wallet',
                        icon: const AssetIcon(AppIcons.connect_wallet_qr, size: 18),
                        onPressed: () => _showQRConnectPage(false),
                      ),
                    ],
                    if (walletConnectPageState.walletConnectOption == WalletConnectOption.qr) ...<Widget>[
                      GradientOutlinedButton.large(
                        label: 'All wallets',
                        icon: const AssetIcon(AppIcons.connect_wallet_qr, size: 18),
                        onPressed: () => _showQRConnectPage(true),
                      ),
                    ],
                    if (walletConnectPageState.walletConnectOption == WalletConnectOption.qr) ...<Widget>[
                      GradientOutlinedButton.large(
                        label: 'Selected wallets',
                        icon: const AssetIcon(AppIcons.connect_wallet_qr, size: 18),
                        onPressed: _selectWalletsForExport,
                      ),
                    ],
                    if (walletConnectPageState.walletConnectOption == WalletConnectOption.hardware) ...<Widget>[
                      const GradientOutlinedButton.large(label: 'Use Trezor interface', icon: AssetIcon(AppIcons.wallet_trezor, size: 18)),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showQRConnectPage(bool connectAllBool) async {
    Future<ACborTaggedObject> Function()? networkHandler = _getNetworkHandler(connectAllBool: connectAllBool);

    if (networkHandler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported network for QR connection')),
      );
      return;
    }

    await _showQrDialog(networkHandler);
  }

  Future<void> _showQrDialog(Future<ACborTaggedObject> Function() networkHandler) async {

    await CustomLoadingDialog.show<ACborTaggedObject>(
      context: context,
      title: 'Loading...',
      futureFunction: networkHandler,
      onSuccess: (ACborTaggedObject result) async {
        bool? navigateBackBool = await showDialog<bool>(
          context: context,
          useSafeArea: false,
          builder: (BuildContext context) {
            return WalletQrConnectPage(
              walletModel: widget.walletModel,
              networkTemplateModel: widget.networkTemplateModel,
              cborTaggedObject: result,
            );
          },
        );

        if (navigateBackBool == true) {
          await AutoRouter.of(context).pop();
        }
      },
    );
  }

  Future<ACborTaggedObject> Function()? _getNetworkHandler({bool connectAllBool = false, List<WalletModel>? selectedWallets}) {
    String name = widget.networkTemplateModel.name.toLowerCase();
    return switch (name) {
      'ethereum' => () => walletConnectPageCubit.getCborCryptoHDKey(
        connectAllBool: connectAllBool,
        selectedWallets: selectedWallets,
      ),
      'solana' => () => walletConnectPageCubit.getCborCryptoMultiAccounts(
        connectAllBool: connectAllBool,
        selectedWallets: selectedWallets,
      ),
      String() => null,
    };
  }

  Future<void> _selectWalletsForExport() async {

    List<NetworkGroupModel> networkGroups =
    await _networkGroupsService.getAllByParentPath(widget.vaultModel.filesystemPath);
    FilesystemPath filesystemPathTest = widget.vaultModel.filesystemPath;
    for (NetworkGroupModel networkGroup in networkGroups) {
      if (networkGroup.networkTemplateModel.curveType == CurveType.ed25519) {
        filesystemPathTest = networkGroup.filesystemPath;
      }
    }

    List<WalletModel>? selectedWallets = await AutoRouter.of(context).push<List<WalletModel>>(
      WalletSelectItemListRoute(
        name: 'Select Wallets',
        vaultModel: widget.vaultModel,
        filesystemPath: filesystemPathTest,
        networkGroupModel: await _networkGroupsService.getById(widget.vaultModel.id * 2),
      ),
    );

    if (selectedWallets == null || selectedWallets.isEmpty) {
      return;
    }

    Future<ACborTaggedObject> Function()? networkHandler = _getNetworkHandler(connectAllBool: false, selectedWallets: selectedWallets);
    if (networkHandler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported network for QR connection')),
      );
      return;
    }

    await _showQrDialog(networkHandler);
  }
}