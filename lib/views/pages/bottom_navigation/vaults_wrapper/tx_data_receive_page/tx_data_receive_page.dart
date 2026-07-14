import 'package:flutter/material.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page.dart';

// Previously this widget was a wrapper for 2 different sign tx modes: QR and audio
class TxDataReceivePage extends StatefulWidget {
  final bool walletAutoDetectionEnabledBool;

  const TxDataReceivePage({
    required this.walletAutoDetectionEnabledBool,
    super.key,
  });

  @override
  State<TxDataReceivePage> createState() => _TxDataReceivePageState();
}

class _TxDataReceivePageState extends State<TxDataReceivePage> {
  final int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: switch (_index) {
            _ => ScanQRPage(
                walletAutoDetectionEnabledBool: widget.walletAutoDetectionEnabledBool,
              ),
          },
        ),
      ],
    );
  }
}
