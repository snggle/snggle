import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VaultListPage extends StatelessWidget {
  const VaultListPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Vault Page')),
    );
  }
}
