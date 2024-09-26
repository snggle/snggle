import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/eth_address_preview.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class TransactionListItemExpansion extends StatelessWidget {
  final TransactionModel transactionModel;

  const TransactionListItemExpansion({
    required this.transactionModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    TextStyle? labelTextStyle = textTheme.labelMedium?.copyWith(
      color: AppColors.body3,
      height: 1.1,
      letterSpacing: 1.1,
    );

    TextStyle? valueTextStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.body3,
      height: 1.1,
      letterSpacing: 0.5,
    );

    String? senderAddress = transactionModel.senderAddress;
    String? recipientAddress = transactionModel.recipientAddress;
    String? contractAddress = transactionModel.contractAddress;
    String? amount = transactionModel.amount?.toString();
    String? fee = transactionModel.fee?.toString();
    String? message = transactionModel.message;
    String? signature = transactionModel.signature;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        if (senderAddress != null) ...<Widget>[
          CopyWrapper(
            value: senderAddress,
            child: LabelWrapperVertical(
              label: 'From',
              labelStyle: labelTextStyle,
              child: ETHAddressPreview(address: senderAddress, textStyle: valueTextStyle),
            ),
          ),
        ],
        if (recipientAddress != null) ...<Widget>[
          CopyWrapper(
            value: recipientAddress,
            child: LabelWrapperVertical(
              label: 'To',
              labelStyle: labelTextStyle,
              child: ETHAddressPreview(address: recipientAddress, textStyle: valueTextStyle),
            ),
          ),
        ],
        if (contractAddress != null) ...<Widget>[
          CopyWrapper(
            value: contractAddress,
            child: LabelWrapperVertical(
              label: 'Contract',
              labelStyle: labelTextStyle,
              child: ETHAddressPreview(address: contractAddress, textStyle: valueTextStyle),
            ),
          ),
        ],
        if (amount != null) ...<Widget>[
          CopyWrapper(
            value: amount,
            child: LabelWrapperVertical(
              label: 'Amount',
              labelStyle: labelTextStyle,
              child: Text(amount, style: valueTextStyle),
            ),
          ),
        ],
        if (fee != null) ...<Widget>[
          CopyWrapper(
            value: fee,
            child: LabelWrapperVertical(
              label: 'Fee',
              labelStyle: labelTextStyle,
              child: Text(fee, style: valueTextStyle),
            ),
          ),
        ],
        if (message != null) ...<Widget>[
          CopyWrapper(
            value: message,
            child: LabelWrapperVertical(
              label: 'Message',
              labelStyle: labelTextStyle,
              child: Text(message, style: valueTextStyle),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (signature != null) ...<Widget>[
          CopyWrapper(
            value: signature,
            child: LabelWrapperVertical(
              label: 'Signature',
              bottomBorderVisibleBool: false,
              labelStyle: labelTextStyle,
              child: Text(StringUtils.getShortHex(signature, 4), style: valueTextStyle),
            ),
          ),
        ],
      ],
    );
  }
}
