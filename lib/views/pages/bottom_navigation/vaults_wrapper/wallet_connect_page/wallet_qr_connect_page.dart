import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/legacy_derivation_path_list_item.dart';
import 'package:snggle/views/widgets/generic/expandable_switch_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class WalletQrConnectPage extends StatefulWidget {
  final WalletModel walletModel;
  final NetworkTemplateModel networkTemplateModel;
  final CborCryptoHDKey cborCryptoHDKey;

  const WalletQrConnectPage({
    required this.walletModel,
    required this.networkTemplateModel,
    required this.cborCryptoHDKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletQrConnectPageState();
}

class _WalletQrConnectPageState extends State<WalletQrConnectPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return QRResultScaffold.fromUniformResource(
      title: 'Wallet QR Connect',
      subtitle: 'Extended public key',
      popButtonVisible: true,
      ur: UR.fromCborTaggedObject(widget.cborCryptoHDKey),
      tooltip: BottomTooltip(
        actions: <Widget>[
          BottomTooltipItem(
            assetIconData: AppIcons.menu_save,
            label: 'Done',
            onTap: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
      addressPreview: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: LabelWrapperVertical(
          label: 'Extended public key path:',
          bottomBorderVisibleBool: false,
          child: LegacyDerivationPathListItem(
            derivationPath: widget.walletModel.derivationPath,
            networkTemplateModel: widget.networkTemplateModel,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          ExpandableSwitchTile(
            label: 'Extended public key details',
            body: Text(
              const JsonEncoder.withIndent('   ').convert(widget.cborCryptoHDKey.toCborMap(includeTagBool: true).toJson()),
              style: theme.textTheme.labelMedium?.copyWith(color: AppColors.body3),
            ),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
