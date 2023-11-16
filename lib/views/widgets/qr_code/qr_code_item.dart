import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeItem extends StatelessWidget {
  final int qrErrorCorrectionLevel;
  final double borderRadius;
  final String qrData;
  final Color backgroundColor;
  final Color qrColor;

  const QrCodeItem({
    required this.qrErrorCorrectionLevel,
    required this.borderRadius,
    required this.qrData,
    required this.backgroundColor,
    required this.qrColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: QrImage(
        foregroundColor: qrColor,
        errorCorrectionLevel: qrErrorCorrectionLevel,
        data: qrData,
        errorStateBuilder: (BuildContext context, Object? error) {
          return Center(
            child: Text(
              'QR code could not be generated: $error',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
