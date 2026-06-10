import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      title: 'Apps',
      popButtonVisible: false,
      body: Center(
        child: Text('Apps Page'),
      ),
    );
  }
}
