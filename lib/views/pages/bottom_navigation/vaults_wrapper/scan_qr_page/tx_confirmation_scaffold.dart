import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/eth_address_preview.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class TxConfirmationScaffold extends StatefulWidget {
  final String title;
  final TransactionModel transactionModel;
  final VoidCallback onSignPressed;

  const TxConfirmationScaffold({
    required this.title,
    required this.transactionModel,
    required this.onSignPressed,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TxConfirmationScaffoldState();
}

class _TxConfirmationScaffoldState extends State<TxConfirmationScaffold> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Gradient gradient = const RadialGradient(
      radius: 10,
      center: Alignment(-0.6, -0.6),
      colors: <Color>[
        Color(0xFF000000),
        Color(0xFF42D2FF),
        Color(0xFF939393),
        Color(0xFF000000),
      ],
    );

    return CustomScaffold(
      title: widget.title,
      body: BottomTooltipWrapper(
        tooltip: BottomTooltip(
          actions: <Widget>[
            BottomTooltipItem(
              assetIconData: AppIcons.menu_save,
              label: 'Sign',
              onTap: widget.onSignPressed,
            )
          ],
        ),
        child: GradientScrollbar(
          scrollController: scrollController,
          margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.transactionModel.senderAddress != null) ...<Widget>[
                    LabelWrapperVertical(label: 'From', child: ETHAddressPreview(address: widget.transactionModel.senderAddress!)),
                  ],
                  if (widget.transactionModel.recipientAddress != null) ...<Widget>[
                    LabelWrapperVertical(label: 'To', child: ETHAddressPreview(address: widget.transactionModel.recipientAddress!)),
                  ],
                  if (widget.transactionModel.contractAddress != null) ...<Widget>[
                    LabelWrapperVertical(label: 'Contract', child: ETHAddressPreview(address: widget.transactionModel.contractAddress!)),
                  ],
                  if (widget.transactionModel.amount != null) ...<Widget>[
                    LabelWrapperVertical(
                      label: 'Amount',
                      child: GradientText(widget.transactionModel.amount.toString(), gradient: gradient, textStyle: textTheme.bodyMedium),
                    ),
                  ],
                  if (widget.transactionModel.fee != null) ...<Widget>[
                    LabelWrapperVertical(
                      label: 'Fee',
                      child: GradientText(widget.transactionModel.fee.toString(), gradient: gradient, textStyle: textTheme.bodyMedium),
                    ),
                  ],
                  if (widget.transactionModel.functionData != null) ...<Widget>[
                    LabelWrapperVertical(
                      label: 'Data',
                      child: Text(widget.transactionModel.functionData!, style: textTheme.bodyMedium?.copyWith(color: AppColors.body3)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.transactionModel.message != null) ...<Widget>[
                    LabelWrapperVertical(
                      label: 'Message',
                      child: Text(widget.transactionModel.message!, style: textTheme.bodyMedium?.copyWith(color: AppColors.body3)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
