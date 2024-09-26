import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/utils/date_time_utils.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';

class TransactionListItemTitle extends StatelessWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final double detailsOpacity;
  final TransactionModel transactionModel;

  const TransactionListItemTitle({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.detailsOpacity,
    required this.transactionModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (selectionEnabledBool) ...<Widget>[
            CustomCheckbox(selectedBool: selectedBool, size: 14),
            const SizedBox(width: 6),
          ],
          SizedBox(
            width: 55,
            child: Text(
              DateTimeUtils.parseDateTimeToRelativeTime(transactionModel.signDate),
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.middleGrey,
                letterSpacing: -0.5,
                height: 0.95,
              ),
            ),
          ),
          const SizedBox(width: 10.5),
          SizedBox(
            width: 50,
            child: GradientText(
              switch (transactionModel.signDataType) {
                SignDataType.typedTransaction => 'TX',
                SignDataType.rawBytes => 'TEXT',
              },
              gradient: RadialGradient(radius: 1, center: Alignment.center, colors: AppColors.primaryGradient.colors),
              textStyle: textTheme.labelMedium?.copyWith(height: 0.95, letterSpacing: 1),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 15.5),
          Expanded(
            flex: 3,
            child: Opacity(
              opacity: detailsOpacity,
              child: Text(
                transactionModel.title.replaceAll('\n', ' '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(color: AppColors.body3, height: 0.95, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
