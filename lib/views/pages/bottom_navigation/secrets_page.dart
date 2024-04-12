import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class SecretsPage extends StatelessWidget {
  const SecretsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      title: 'Secrets',
      popButtonVisible: false,
      body: Center(
        child: Text('Secrets Page'),
      ),
    );
  }
}
