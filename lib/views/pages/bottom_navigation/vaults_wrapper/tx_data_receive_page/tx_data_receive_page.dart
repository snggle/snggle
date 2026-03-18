import 'package:flutter/material.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/record_audio_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/tx_data_receive_page/tx_mode_selection_button.dart';

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
  int _index = 0;
  bool _receivingStageBool = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: switch (_index) {
            0 => ScanQRPage(
                walletAutoDetectionEnabledBool: widget.walletAutoDetectionEnabledBool,
                onReceived: _hideSegmentedButton,
              ),
            _ => RecordAudioPage(
                walletAutoDetectionEnabledBool: widget.walletAutoDetectionEnabledBool,
                onReceived: _hideSegmentedButton,
              ),
          },
        ),
        if (_receivingStageBool)
          Positioned(
            left: 100,
            right: 100,
            top: 120,
            child: TxModeSelectionButton(
                index: _index,
                onChanged: (int newIndex) {
                  setState(() => _index = newIndex);
                }),
          ),
      ],
    );
  }

  void _hideSegmentedButton() {
    setState(() {
      _receivingStageBool = false;
    });
  }
}
