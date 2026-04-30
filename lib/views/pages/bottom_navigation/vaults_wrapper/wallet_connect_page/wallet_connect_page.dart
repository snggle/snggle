import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/networks/network_type.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_connect_option.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_audio_connect_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_option_button.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_qr_connect_page.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
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
                  if (widget.networkTemplateModel.networkType == NetworkType.ethereum)
                    WalletConnectOptionButton(
                      selectedBool: walletConnectPageState.walletConnectOption == WalletConnectOption.audio,
                      label: 'Audio based',
                      icon: AppIcons.soundwave_big,
                      onTap: () => walletConnectPageCubit.changeConnectOption(WalletConnectOption.audio),
                    ),
                ],
              ),
              const SizedBox(height: 34),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    if (walletConnectPageState.walletConnectOption == WalletConnectOption.qr) ...<Widget>[
                      switch (widget.networkTemplateModel.networkType) {
                        NetworkType.ethereum => GradientOutlinedButton.large(
                            label: 'Metamask QR',
                            icon: const AssetIcon(AppIcons.wallet_metamask, size: 18),
                            onPressed: _showQRConnectPage,
                          ),
                        NetworkType.solana => GradientOutlinedButton.large(
                            label: 'Solflare QR',
                            icon: const AssetIcon(AppIcons.wallet_solflare, size: 18),
                            onPressed: _showQRConnectPage,
                          ),
                      }
                    ],
                    if (walletConnectPageState.walletConnectOption == WalletConnectOption.audio) ...<Widget>[
                      GradientOutlinedButton.large(
                        label: 'Mirage audio',
                        icon: const AssetIcon(AppIcons.mirage_logo, size: 30),
                        onPressed: _showAudioConnectPage,
                      ),
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

  Future<void> _showQRConnectPage() async {
    await CustomLoadingDialog.show<ACborTaggedObject>(
      context: context,
      title: 'Loading...',
      futureFunction: () {
        switch (widget.networkTemplateModel.networkType) {
          case NetworkType.ethereum:
            return walletConnectPageCubit.getCborCryptoHDKey(derivationPathDepth: 3);
          case NetworkType.solana:
            return walletConnectPageCubit.getCborCryptoMultiAccounts();
        }
      },
      onSuccess: (ACborTaggedObject cborTaggedObject) async {
        bool? navigateBackBool = await showDialog<bool>(
          context: context,
          useSafeArea: false,
          builder: (BuildContext context) {
            return WalletQrConnectPage(
              walletModel: widget.walletModel,
              networkTemplateModel: widget.networkTemplateModel,
              cborTaggedObject: cborTaggedObject,
            );
          },
        );

        if (navigateBackBool == true) {
          await AutoRouter.of(context).pop();
        }
      },
      onError: _handleInvalidMasterKeyException,
    );
  }

  Future<void> _showAudioConnectPage() async {
    await CustomLoadingDialog.show<CborCryptoHDKey>(
      context: context,
      title: 'Loading...',
      futureFunction: () => walletConnectPageCubit.getCborCryptoHDKey(derivationPathDepth: 4),
      onSuccess: (CborCryptoHDKey cborCryptoHDKey) async {
        bool? navigateBackBool = await showDialog<bool>(
          context: context,
          useSafeArea: false,
          builder: (BuildContext context) {
            return WalletAudioConnectPage(
              walletModel: widget.walletModel,
              networkTemplateModel: widget.networkTemplateModel,
              cborCryptoHDKey: cborCryptoHDKey,
            );
          },
        );

        if (navigateBackBool == true) {
          await AutoRouter.of(context).pop();
        }
      },
      onError: _handleInvalidMasterKeyException,
    );
  }

  void _handleInvalidMasterKeyException(Object error) {
    if (mounted == false || error is! InvalidMasterKeyException) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(MasterKeyDialog.show(context));
    });
  }
}
