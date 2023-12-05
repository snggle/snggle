import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AppsPage extends StatelessWidget {
  const AppsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Apps Page')),
    );
  }
}
