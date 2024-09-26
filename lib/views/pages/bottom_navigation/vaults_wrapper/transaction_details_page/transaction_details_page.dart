import 'dart:typed_data';

import 'package:auto_route/annotations.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_scan_icon.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_display_mode_selector.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_selector.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_animated.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_horizontal.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';

@RoutePage()
class TransactionDetailsPage extends StatefulWidget {
  final TransactionModel transactionModel;
  final NetworkTemplateModel networkTemplateModel;

  const TransactionDetailsPage({
    required this.transactionModel,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle horizontalValueTextStyle = theme.textTheme.labelMedium!;
    TextStyle verticalValueTextStyle = theme.textTheme.bodyMedium!.copyWith(color: AppColors.body3, height: 1.48, letterSpacing: 0.1);
    TextStyle labelTextStyle = theme.textTheme.bodyMedium!.copyWith(color: AppColors.darkGrey);

    String? senderAddress = widget.transactionModel.senderAddress;
    String? recipientAddress = widget.transactionModel.recipientAddress;
    String? contractAddress = widget.transactionModel.contractAddress;

    String? fee = widget.transactionModel.fee;
    String? amount = widget.transactionModel.amount;

    Uint8List? abiFunctionBytes = widget.transactionModel.functionData != null ? HexCodec.decode(widget.transactionModel.functionData!) : null;
    String? functionSelector = abiFunctionBytes != null ? HexCodec.encode(abiFunctionBytes.sublist(0, 4), includePrefixBool: true) : null;
    Uint8List? functionData = abiFunctionBytes?.sublist(4);

    String? signDate = widget.transactionModel.signDate != null ? DateFormat('dd/MM/yy HH:mm').format(widget.transactionModel.signDate!) : null;
    String signDataType = switch (widget.transactionModel.signDataType) {
      SignDataType.typedTransaction => 'TRANSACTION',
      SignDataType.rawBytes => 'PLAIN TEXT',
    };

    String? message = widget.transactionModel.message;
    String? messageLength = message?.codeUnits.length.toString();

    String? signatureAlgorithm = widget.networkTemplateModel.curveType.name;
    String? signature = widget.transactionModel.signature;
    String? signatureLength = signature != null ? HexCodec.decode(signature).length.toString() : null;

    return CustomScaffold(
      title: 'Details',
      body: ScrollableLayout(
        scrollController: scrollController,
        tooltip: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomBottomNavigationBarScanIcon(foregroundColor: AppColors.darkGrey),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              if (senderAddress != null) ...<Widget>[
                CopyWrapper(
                  value: senderAddress,
                  child: LabelWrapperAnimated(
                    label: 'Signer',
                    labelStyle: labelTextStyle,
                    collapsedValue: GradientText(
                      StringUtils.getShortHex(senderAddress, 6),
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                    expandedValue: Text(
                      senderAddress,
                      style: verticalValueTextStyle,
                    ),
                  ),
                ),
              ],
              if (signDate != null) ...<Widget>[
                CopyWrapper(
                  value: signDate,
                  child: LabelWrapperHorizontal(
                    label: 'Time',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      signDate,
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
              ],
              CopyWrapper(
                value: signDataType,
                child: LabelWrapperHorizontal(
                  label: 'Format',
                  labelStyle: labelTextStyle,
                  padding: EdgeInsets.zero,
                  child: GradientText(
                    signDataType,
                    gradient: AppColors.primaryGradient,
                    textStyle: horizontalValueTextStyle,
                  ),
                ),
              ),
              if (contractAddress != null) ...<Widget>[
                CopyWrapper(
                  value: contractAddress,
                  child: LabelWrapperAnimated(
                    label: 'Contract',
                    labelStyle: labelTextStyle,
                    collapsedValue: GradientText(
                      StringUtils.getShortHex(contractAddress, 6),
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                    expandedValue: Text(
                      contractAddress,
                      style: verticalValueTextStyle,
                    ),
                  ),
                ),
              ],
              if (recipientAddress != null) ...<Widget>[
                CopyWrapper(
                  value: recipientAddress,
                  child: LabelWrapperAnimated(
                    label: 'Recipient',
                    labelStyle: labelTextStyle,
                    collapsedValue: GradientText(
                      StringUtils.getShortHex(recipientAddress, 6),
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                    expandedValue: Text(
                      recipientAddress,
                      style: verticalValueTextStyle,
                    ),
                  ),
                ),
              ],
              if (fee != null) ...<Widget>[
                CopyWrapper(
                  value: fee,
                  child: LabelWrapperHorizontal(
                    label: 'Fee',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      fee,
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
              ],
              if (amount != null) ...<Widget>[
                CopyWrapper(
                  value: amount,
                  child: LabelWrapperHorizontal(
                    label: 'Amount',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      amount,
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
              ],
              if (functionData != null && functionSelector != null) ...<Widget>[
                CopyWrapper(
                  value: functionSelector,
                  child: LabelWrapperHorizontal(
                    label: 'Function',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      functionSelector,
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
                CopyWrapper(
                  value: HexCodec.encode(functionData, includePrefixBool: true),
                  child: AbiDisplayModeSelector(
                    label: 'Data',
                    labelTextStyle: labelTextStyle,
                    textStyle: verticalValueTextStyle,
                    functionBytes: functionData,
                  ),
                ),
              ],
              if (message != null && messageLength != null) ...<Widget>[
                CopyWrapper(
                  value: messageLength,
                  child: LabelWrapperHorizontal(
                    label: 'Length',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      '${messageLength} Bytes',
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
                CopyWrapper(
                  value: message,
                  child: TextDisplayModeSelector(
                    label: 'Message',
                    labelTextStyle: labelTextStyle,
                    textStyle: verticalValueTextStyle,
                    value: message,
                  ),
                ),
              ],
              if (signature != null && signatureLength != null) ...<Widget>[
                CopyWrapper(
                  value: signatureAlgorithm,
                  child: LabelWrapperHorizontal(
                    label: 'Algorithm',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      signatureAlgorithm,
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
                CopyWrapper(
                  value: signatureLength,
                  child: LabelWrapperHorizontal(
                    label: 'Size',
                    labelStyle: labelTextStyle,
                    padding: EdgeInsets.zero,
                    child: GradientText(
                      '${HexCodec.decode(widget.transactionModel.signature!).length.toString()} Bytes',
                      gradient: AppColors.primaryGradient,
                      textStyle: horizontalValueTextStyle,
                    ),
                  ),
                ),
                CopyWrapper(
                  value: signature,
                  child: LabelWrapperVertical(
                    label: 'Signature',
                    labelStyle: labelTextStyle,
                    labelPadding: const EdgeInsets.only(top: 10, bottom: 6, left: 16, right: 16),
                    padding: const EdgeInsets.only(bottom: 10),
                    bottomBorderVisibleBool: false,
                    child: Text(
                      signature,
                      style: verticalValueTextStyle,
                    ),
                  ),
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
