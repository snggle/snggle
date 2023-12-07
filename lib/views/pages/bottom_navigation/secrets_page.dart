import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

@RoutePage()
class SecretsPage extends StatelessWidget {
  const SecretsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Secrets'),
      body: Center(child: Text('Secrets Page')),
    );
  }
}
