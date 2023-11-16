import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Settings'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: qrCodeCubit.fetchMemoryQrCode,
              child: const Text('Fetch QR-code from Memory'),
            ),
            BlocBuilder<QRCodeCubit, String>(
              bloc: qrCodeCubit,
              builder: (BuildContext context, String state) {
                return Text(state);
              },
            ),
          ],
        ),
      ),
    );
  }
}
