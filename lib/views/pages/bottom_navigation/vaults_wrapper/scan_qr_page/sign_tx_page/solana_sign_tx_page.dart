import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/a_solana_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/solana_sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/solana_tx_confirmation_scaffold.dart';
import 'package:snggle/views/widgets/generic/eth_address_preview.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class SolanaSignTxPage extends StatefulWidget {
  final SolanaSignTxPageCubit signTxPageCubit;

  const SolanaSignTxPage({
    required this.signTxPageCubit,
    super.key,
  });

  static Future<SolanaSignTxPage> load(CborSolSignRequest cborSolSignRequest) async {
    SolanaSignTxPageCubit signTxPageCubit = SolanaSignTxPageCubit(cborSolSignRequest: cborSolSignRequest);

    try {
      await signTxPageCubit.init();
      return SolanaSignTxPage(signTxPageCubit: signTxPageCubit);
    } on ScanQrException {
      await signTxPageCubit.close();
      rethrow;
    }
  }

  @override
  State<StatefulWidget> createState() => _SolanaSignTxPageState();
}

class _SolanaSignTxPageState extends State<SolanaSignTxPage> {
  @override
  void dispose() {
    widget.signTxPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SolanaSignTxPageCubit, ASolanaSignTxPageState>(
      bloc: widget.signTxPageCubit,
      builder: (BuildContext context, ASolanaSignTxPageState signTxPageState) {
        late Widget child;

        if (signTxPageState is SolanaSignTxPageConfirmTxState) {
          child = SolanaTxConfirmationScaffold(
            title: 'CONFIRM',
            transactionModel: widget.signTxPageCubit.transactionModel,
            onSignPressed: widget.signTxPageCubit.signTransaction,
          );
        } else if (signTxPageState is SolanaSignTxPageSignedTxState) {
          child = QRResultScaffold.fromUniformResource(
            title: 'SIGNATURE',
            closeButtonVisible: true,
            ur: UR.fromCborTaggedObject(signTxPageState.cborSolSignature),
            tooltip: BottomTooltip(
              actions: <Widget>[
                BottomTooltipItem(
                  assetIconData: AppIcons.menu_save,
                  label: 'Finish',
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                LabelWrapperVertical(
                  label: 'Signed with',
                  child: ETHAddressPreview(
                    address: widget.signTxPageCubit.signWalletModel.address,
                    textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                  ),
                ),
                LabelWrapperVertical(
                  label: 'Signature',
                  child: Text(
                    signTxPageState.transactionModel.signature!,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                  ),
                ),
              ],
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }
}
