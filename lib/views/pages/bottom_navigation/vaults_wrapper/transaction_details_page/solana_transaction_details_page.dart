import 'package:auto_route/annotations.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_selector.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_animated.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_horizontal.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';

@RoutePage()
class SolanaTransactionDetailsPage extends StatefulWidget {
  final SolanaTransactionModel solanaTransactionModel;
  final NetworkTemplateModel networkTemplateModel;

  const SolanaTransactionDetailsPage({
    required this.solanaTransactionModel,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SolanaTransactionDetailsPageState();
}

class _SolanaTransactionDetailsPageState extends State<SolanaTransactionDetailsPage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle horizontalValueTextStyle = theme.textTheme.labelMedium!;
    TextStyle verticalValueTextStyle = theme.textTheme.bodyMedium!.copyWith(color: AppColors.body3, height: 1.48, letterSpacing: 0.1);
    TextStyle labelTextStyle = theme.textTheme.bodyMedium!.copyWith(color: AppColors.darkGrey);

    String? senderAddress = widget.solanaTransactionModel.senderAddress;
    String? recipientAddress = widget.solanaTransactionModel.recipientAddress;
    String? contractAddress = widget.solanaTransactionModel.contractAddress;

    String? amount = widget.solanaTransactionModel.amount;

    String? signDate =
        widget.solanaTransactionModel.signDate != null ? DateFormat('dd/MM/yy HH:mm').format(widget.solanaTransactionModel.signDate!) : null;
    String signDataType = widget.solanaTransactionModel.transactionData != null ? 'TRANSACTION' : 'PLAIN TEXT';

    String? message = widget.solanaTransactionModel.message;
    String? messageLength = message?.codeUnits.length.toString();

    String? transactionData = widget.solanaTransactionModel.transactionData;

    String? signatureAlgorithm = widget.networkTemplateModel.curveType.name;
    String? signature = widget.solanaTransactionModel.signature;
    String? signatureLength = signature != null ? HexCodec.decode(signature).length.toString() : null;

    return CustomScaffold(
      title: 'Details',
      body: ScrollableLayout(
        bottomMarginVisibleBool: false,
        scrollController: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              if (senderAddress != null) ...<Widget>[
                CopyWrapper(
                  value: senderAddress,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperAnimated(
                      label: 'Signer',
                      labelStyle: labelTextStyle,
                      collapsedValue: GradientText(
                        StringUtils.getShortPublicAddress(senderAddress, 6),
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                      expandedValue: Text(
                        senderAddress,
                        style: verticalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              if (signDate != null) ...<Widget>[
                CopyWrapper(
                  value: signDate,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperHorizontal(
                      label: 'Time',
                      labelStyle: labelTextStyle,
                      padding: EdgeInsets.zero,
                      child: GradientText(
                        signDate,
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              CopyWrapper(
                value: signDataType,
                copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                  return LabelWrapperHorizontal(
                    label: 'Format',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      signDataType,
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  );
                },
              ),
              if (contractAddress != null) ...<Widget>[
                CopyWrapper(
                  value: contractAddress,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperAnimated(
                      label: 'Contract',
                      labelStyle: labelTextStyle,
                      collapsedValue: GradientText(
                        StringUtils.getShortPublicAddress(contractAddress, 6),
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                      expandedValue: Text(
                        contractAddress,
                        style: verticalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              if (recipientAddress != null) ...<Widget>[
                CopyWrapper(
                  value: recipientAddress,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperAnimated(
                      label: 'Recipient',
                      labelStyle: labelTextStyle,
                      collapsedValue: GradientText(
                        StringUtils.getShortPublicAddress(recipientAddress, 6),
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                      expandedValue: Text(
                        recipientAddress,
                        style: verticalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              if (amount != null) ...<Widget>[
                CopyWrapper(
                  value: amount,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperHorizontal(
                      label: 'Amount',
                      labelStyle: labelTextStyle,
                      padding: EdgeInsets.zero,
                      child: GradientText(
                        amount,
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              if (message != null && messageLength != null) ...<Widget>[
                CopyWrapper(
                  value: messageLength,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperHorizontal(
                      label: 'Length',
                      labelStyle: labelTextStyle,
                      padding: EdgeInsets.zero,
                      child: GradientText(
                        '${messageLength} Bytes',
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                    );
                  },
                ),
                CopyWrapper(
                  value: message,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return TextDisplayModeSelector(
                      label: 'Message',
                      labelTextStyle: labelTextStyle,
                      textStyle: verticalValueTextStyle,
                      value: message,
                    );
                  },
                ),
              ],
              if (transactionData != null) ...<Widget>[
                CopyWrapper(
                  value: transactionData,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperVertical(
                      label: 'Transaction data',
                      labelStyle: labelTextStyle,
                      labelPadding: const EdgeInsets.only(top: 10, bottom: 6, left: 16, right: 16),
                      padding: const EdgeInsets.only(bottom: 10),
                      bottomBorderVisibleBool: false,
                      child: Text(
                        transactionData,
                        style: verticalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              if (signature != null && signatureLength != null) ...<Widget>[
                CopyWrapper(
                  value: signatureAlgorithm,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperHorizontal(
                      label: 'Algorithm',
                      labelStyle: labelTextStyle,
                      padding: EdgeInsets.zero,
                      child: GradientText(
                        signatureAlgorithm,
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                    );
                  },
                ),
                CopyWrapper(
                  value: signatureLength,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperHorizontal(
                      label: 'Size',
                      labelStyle: labelTextStyle,
                      padding: EdgeInsets.zero,
                      child: GradientText(
                        '${HexCodec.decode(widget.solanaTransactionModel.signature!).length.toString()} Bytes',
                        gradient: AppColors.primaryGradient,
                        textStyle: horizontalValueTextStyle,
                      ),
                    );
                  },
                ),
                CopyWrapper(
                  value: signature,
                  copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
                    return LabelWrapperVertical(
                      label: 'Signature',
                      labelStyle: labelTextStyle,
                      labelPadding: const EdgeInsets.only(top: 10, bottom: 6, left: 16, right: 16),
                      padding: const EdgeInsets.only(bottom: 10),
                      bottomBorderVisibleBool: false,
                      child: Text(
                        signature,
                        style: verticalValueTextStyle,
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
