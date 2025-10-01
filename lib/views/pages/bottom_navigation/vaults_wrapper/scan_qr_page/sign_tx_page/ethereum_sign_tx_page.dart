import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/a_ethereum_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/ethereum_sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/states/ethereum_sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/states/ethereum_sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/tx_confirmation_scaffold.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/public_address_preview.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class EthereumSignTxPage extends StatefulWidget {
  final EthereumSignTxPageCubit signTxPageCubit;

  const EthereumSignTxPage({
    required this.signTxPageCubit,
    super.key,
  });

  static Future<EthereumSignTxPage> load(CborEthSignRequest cborEthSignRequest) async {
    EthereumSignTxPageCubit ethereumSignTxPageCubit = EthereumSignTxPageCubit(cborEthSignRequest: cborEthSignRequest);

    try {
      await ethereumSignTxPageCubit.init();
      return EthereumSignTxPage(signTxPageCubit: ethereumSignTxPageCubit);
    } on ScanQrException {
      await ethereumSignTxPageCubit.close();
      rethrow;
    }
  }

  @override
  State<StatefulWidget> createState() => _EthereumSignTxPageState();
}

class _EthereumSignTxPageState extends State<EthereumSignTxPage> {
  @override
  void dispose() {
    widget.signTxPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<EthereumSignTxPageCubit, AEthereumSignTxPageState>(
      bloc: widget.signTxPageCubit,
      builder: (BuildContext context, AEthereumSignTxPageState signTxPageState) {
        late Widget child;

        if (signTxPageState is EthereumSignTxPageConfirmTxState) {
          child = TxConfirmationScaffold(
            title: 'CONFIRM',
            onSignPressed: widget.signTxPageCubit.signTransaction,
            transactionBodyWidget: Builder(
              builder: (BuildContext context) {
                EthereumTransactionModel tx = widget.signTxPageCubit.transactionModel;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (tx.senderAddress != null) LabelWrapperVertical(label: 'From', child: PublicAddressPreview(address: tx.senderAddress!)),
                    if (tx.recipientAddress != null) LabelWrapperVertical(label: 'To', child: PublicAddressPreview(address: tx.recipientAddress!)),
                    if (tx.contractAddress != null)
                      LabelWrapperVertical(label: 'Contract', child: PublicAddressPreview(address: tx.contractAddress!)),
                    if (tx.amount != null)
                      LabelWrapperVertical(
                        label: 'Amount',
                        child: GradientText(tx.amount!, gradient: AppColors.primaryGradient, textStyle: textTheme.bodyMedium),
                      ),
                    if (tx.fee != null)
                      LabelWrapperVertical(
                        label: 'Fee',
                        child: GradientText(tx.fee!, gradient: AppColors.primaryGradient, textStyle: textTheme.bodyMedium),
                      ),
                    if (tx.functionData != null)
                      LabelWrapperVertical(
                        label: 'Data',
                        child: Text(tx.functionData!, style: textTheme.bodyMedium?.copyWith(color: AppColors.body3)),
                      ),
                    if (tx.message != null)
                      LabelWrapperVertical(
                        label: 'Message',
                        child: Text(tx.message!, style: textTheme.bodyMedium?.copyWith(color: AppColors.body3)),
                      ),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
          );
        } else if (signTxPageState is EthereumSignTxPageSignedTxState) {
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
                  child: PublicAddressPreview(
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
