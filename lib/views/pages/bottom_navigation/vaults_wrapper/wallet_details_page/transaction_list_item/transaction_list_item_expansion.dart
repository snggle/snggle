import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/public_address_preview.dart';

class TransactionListItemExpansion extends StatelessWidget {
  final ATransactionModel transactionModel;

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
    String? fee = transactionModel is EthereumTransactionModel ? (transactionModel as EthereumTransactionModel).fee?.toString() : null;
    String? message = transactionModel.message;
    String? signature = transactionModel.signature;
    String? transactionData = transactionModel is SolanaTransactionModel ? (transactionModel as SolanaTransactionModel).transactionData : null;

    bool emptyTransactionDetailsBool = recipientAddress == null && message == null && contractAddress == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        if (senderAddress != null) ...<Widget>[
          CopyWrapper(
            value: senderAddress,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'From',
                labelStyle: labelTextStyle,
                child: PublicAddressPreview(address: senderAddress, textStyle: valueTextStyle),
              );
            },
          ),
        ],
        if (recipientAddress != null) ...<Widget>[
          CopyWrapper(
            value: recipientAddress,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'To',
                labelStyle: labelTextStyle,
                child: PublicAddressPreview(address: recipientAddress, textStyle: valueTextStyle),
              );
            },
          ),
        ],
        if (contractAddress != null) ...<Widget>[
          CopyWrapper(
            value: contractAddress,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'Contract',
                labelStyle: labelTextStyle,
                child: PublicAddressPreview(address: contractAddress, textStyle: valueTextStyle),
              );
            },
          ),
        ],
        if (amount != null) ...<Widget>[
          CopyWrapper(
            value: amount,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'Amount',
                labelStyle: labelTextStyle,
                child: Text(amount, style: valueTextStyle),
              );
            },
          ),
        ],
        if (fee != null) ...<Widget>[
          CopyWrapper(
            value: fee,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'Fee',
                labelStyle: labelTextStyle,
                child: Text(fee, style: valueTextStyle),
              );
            },
          ),
        ],
        if (message != null) ...<Widget>[
          CopyWrapper(
            value: message,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'Message',
                labelStyle: labelTextStyle,
                child: Text(message, style: valueTextStyle),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        if (transactionData != null && emptyTransactionDetailsBool == true) ...<Widget>[
          CopyWrapper(
            value: transactionData,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'Transaction data',
                labelStyle: labelTextStyle,
                child: Text(transactionData, style: valueTextStyle),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        if (signature != null) ...<Widget>[
          CopyWrapper(
            value: signature,
            copyWrapperBuilder: (BuildContext context) {
              return LabelWrapperVertical(
                label: 'Signature',
                bottomBorderVisibleBool: false,
                labelStyle: labelTextStyle,
                child: Text(StringUtils.getShortPublicAddress(signature, 4), style: valueTextStyle),
              );
            },
          ),
        ],
      ],
    );
  }
}
