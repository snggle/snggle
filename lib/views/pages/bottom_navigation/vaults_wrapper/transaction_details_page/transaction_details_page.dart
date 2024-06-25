import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
// TODO(dominik): Temporary page to display transaction details
class TransactionDetailsPage extends StatelessWidget {
  final TransactionModel transactionModel;

  const TransactionDetailsPage({
    required this.transactionModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Transaction details',
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(transactionModel.toEntity().toString()),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
