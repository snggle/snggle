import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

@RoutePage()
class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Apps'),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AutoRouter.of(context).push(const QrCodeGenerateRoute());
          },
          child: const Text('Test Generate QR'),
        ),
      ),
    );
  }
}
