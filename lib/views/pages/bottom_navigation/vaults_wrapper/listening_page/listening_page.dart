import 'package:flutter/material.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/scan_qr_page.dart';
import 'package:snggle/views/widgets/trezor/receive_audio_page.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose option'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _showScanQRPage,
              child: const Text('QR'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showReceivePage,
              child: const Text('Audio'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showScanQRPage() async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return const ScanQRPage();
      },
    );
  }

  Future<void> _showReceivePage() async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return const ReceiveAudioPage();
      },
    );
  }
}
