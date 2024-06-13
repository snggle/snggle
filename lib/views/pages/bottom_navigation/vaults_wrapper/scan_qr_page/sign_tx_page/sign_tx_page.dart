import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/tx_confirmation_scaffold.dart';
import 'package:snggle/views/widgets/generic/eth_address_preview.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class SignTxPage extends StatefulWidget {
  final SignTxPageCubit signTxPageCubit;

  const SignTxPage({
    required this.signTxPageCubit,
    super.key,
  });

  static Future<SignTxPage> load(CborEthSignRequest cborEthSignRequest) async {
    SignTxPageCubit signTxPageCubit = SignTxPageCubit(cborEthSignRequest: cborEthSignRequest);

    try {
      await signTxPageCubit.init();
      return SignTxPage(signTxPageCubit: signTxPageCubit);
    } on ScanQrException {
      await signTxPageCubit.close();
      rethrow;
    }
  }

  @override
  State<StatefulWidget> createState() => _SignTxPageState();
}

class _SignTxPageState extends State<SignTxPage> {
  @override
  void dispose() {
    widget.signTxPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SignTxPageCubit, ASignTxPageState>(
      bloc: widget.signTxPageCubit,
      builder: (BuildContext context, ASignTxPageState signTxPageState) {
        late Widget child;

        if (signTxPageState is SignTxPageConfirmTxState) {
          child = TxConfirmationScaffold(
            title: 'CONFIRM',
            transactionModel: widget.signTxPageCubit.transactionModel,
            onSignPressed: widget.signTxPageCubit.signTransaction,
          );
        } else if (signTxPageState is SignTxPageSignedTxState) {
          child = QRResultScaffold.fromUniformResource(
            title: 'SIGNATURE',
            closeButtonVisible: true,
            ur: UR.fromCborTaggedObject(signTxPageState.cborEthSignature),
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
