import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        if (transactionModel.senderAddress != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'From',
            labelStyle: labelTextStyle,
            child: ETHAddressPreview(address: transactionModel.senderAddress!, textStyle: valueTextStyle),
          ),
        ],
        if (transactionModel.recipientAddress != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'To',
            labelStyle: labelTextStyle,
            child: ETHAddressPreview(address: transactionModel.recipientAddress!, textStyle: valueTextStyle),
          ),
        ],
        if (transactionModel.contractAddress != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'Contract',
            labelStyle: labelTextStyle,
            child: ETHAddressPreview(address: transactionModel.contractAddress!, textStyle: valueTextStyle),
          ),
        ],
        if (transactionModel.amount != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'Amount',
            labelStyle: labelTextStyle,
            child: Text(transactionModel.amount.toString(), style: valueTextStyle),
          ),
        ],
        if (transactionModel.fee != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'Fee',
            labelStyle: labelTextStyle,
            child: Text(transactionModel.fee.toString(), style: valueTextStyle),
          ),
        ],
        if (transactionModel.message != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'Message',
            labelStyle: labelTextStyle,
            child: Text(transactionModel.message!, style: valueTextStyle),
          ),
          const SizedBox(height: 16),
        ],
        if (transactionModel.signature != null) ...<Widget>[
          LabelWrapperVertical(
            label: 'Signature',
            bottomBorderVisibleBool: false,
            labelStyle: labelTextStyle,
            child: Text(StringUtils.getShortHex(transactionModel.signature!, 4), style: valueTextStyle),
          ),
        ],
      ],
    );
  }
}
