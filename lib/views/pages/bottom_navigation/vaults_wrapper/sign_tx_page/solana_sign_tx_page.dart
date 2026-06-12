import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/a_solana_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/solana_sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/sign_tx_page/tx_confirmation_scaffold.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/public_address_preview.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class SolanaSignTxPage extends StatefulWidget {
  final SolanaSignTxPageCubit solanaSignTxPageCubit;

  const SolanaSignTxPage({
    required this.solanaSignTxPageCubit,
    super.key,
  });

  static Future<SolanaSignTxPage> load({required bool walletAutoDetectionEnabledBool, required CborSolSignRequest cborSolSignRequest}) async {
    SolanaSignTxPageCubit solanaSignTxPageCubit =
        SolanaSignTxPageCubit(cborSolSignRequest: cborSolSignRequest, walletAutoDetectionEnabledBool: walletAutoDetectionEnabledBool);

    try {
      await solanaSignTxPageCubit.init();
      return SolanaSignTxPage(solanaSignTxPageCubit: solanaSignTxPageCubit);
    } on ReadTxDataException {
      await solanaSignTxPageCubit.close();
      rethrow;
    }
  }

  @override
  State<StatefulWidget> createState() => _SolanaSignTxPageState();
}

class _SolanaSignTxPageState extends State<SolanaSignTxPage> {
  @override
  void dispose() {
    widget.solanaSignTxPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SolanaSignTxPageCubit, ASolanaSignTxPageState>(
      bloc: widget.solanaSignTxPageCubit,
      builder: (BuildContext context, ASolanaSignTxPageState signTxPageState) {
        late Widget child;

        if (signTxPageState is SolanaSignTxPageConfirmTxState) {
          child = TxConfirmationScaffold(
            title: 'CONFIRM',
            onSignPressed: widget.solanaSignTxPageCubit.signTransaction,
            transactionBodyWidget: Builder(
              builder: (BuildContext context) {
                SolanaTransactionModel tx = widget.solanaSignTxPageCubit.solanaTransactionModel;
                bool transactionPageEmptyBool =
                    tx.senderAddress == null && tx.recipientAddress == null && tx.contractAddress == null && tx.amount == null && tx.message == null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LabelWrapperVertical(label: 'Signer', child: PublicAddressPreview(address: tx.signerAddress)),
                    if (tx.senderAddress != null) LabelWrapperVertical(label: 'From', child: PublicAddressPreview(address: tx.senderAddress!)),
                    if (tx.recipientAddress != null) LabelWrapperVertical(label: 'To', child: PublicAddressPreview(address: tx.recipientAddress!)),
                    if (tx.contractAddress != null) LabelWrapperVertical(label: 'Mint', child: PublicAddressPreview(address: tx.contractAddress!)),
                    if (tx.amount != null)
                      LabelWrapperVertical(
                        label: 'Amount',
                        child: CopyWrapper(
                          value: tx.amount!,
                          copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                            return GradientText(tx.amount!, gradient: AppColors.primaryGradient, textStyle: textTheme.bodyMedium);
                          },
                        ),
                      ),
                    if (tx.message != null)
                      LabelWrapperVertical(
                        label: 'Message',
                        child: CopyWrapper(
                          value: tx.message!,
                          copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                            return Text(tx.message!, style: textTheme.bodyMedium?.copyWith(color: AppColors.body3));
                          },
                        ),
                      ),
                    if (transactionPageEmptyBool == true)
                      LabelWrapperVertical(
                        label: 'Transaction data',
                        child: CopyWrapper(
                          value: tx.transactionData!,
                          copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                            return Text(tx.transactionData!, style: textTheme.bodyMedium?.copyWith(color: AppColors.body3));
                          },
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
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
                  child: PublicAddressPreview(
                    address: widget.solanaSignTxPageCubit.senderWalletModel.address,
                    textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                  ),
                ),
                LabelWrapperVertical(
                  label: 'Signature',
                  child: CopyWrapper(
                    value: signTxPageState.transactionModel.signature!,
                    copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                      return Text(
                        signTxPageState.transactionModel.signature!,
                        style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                      );
                    },
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
