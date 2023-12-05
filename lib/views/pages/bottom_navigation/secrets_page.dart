import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SecretsPage extends StatelessWidget {
  const SecretsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Secrets Page')),
    );
  }
}
