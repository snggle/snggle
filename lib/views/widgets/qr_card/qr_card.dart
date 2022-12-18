import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCard extends StatelessWidget {
  final List<String> qrData;
  final bool loop;
  final bool autoplay;
  final bool splitQrData;
  final int autoplayDelay;
  final int charactersPerCard;
  final double itemWidth;
  final double itemHeight;
  final double borderRadius;
  final double transitionDuration;
  final Color backgroundColor;
  final Color foregroundColor;

  QrCard({
    required this.qrData,
    this.loop = true,
    this.autoplay = true,
    this.autoplayDelay = 0,
    this.splitQrData = true,
    this.charactersPerCard = 100,
    this.itemWidth = 300,
    this.itemHeight = 300,
    this.borderRadius = 10,
    this.transitionDuration = 500,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    super.key,
  }) {
    if (splitQrData) {
      _initializeQrDataSplitter(qrData);
    }
  }

  List<String> qrSplitCardData = <String>[];

  @override
  Widget build(BuildContext context) {
    final CustomLayoutOption customLayoutOption = CustomLayoutOption(startIndex: 0, stateCount: 5);

    return Swiper(
      autoplay: autoplay,
      autoplayDelay: autoplayDelay,
      customLayoutOption: customLayoutOption,
      duration: transitionDuration.toInt(),
      itemCount: splitQrData ? qrSplitCardData.length : qrData.length,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      itemBuilder: _buildQrCard,
      layout: SwiperLayout.CUSTOM,
    );
  }

  Widget _buildQrCard(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: QrImage(
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        data: splitQrData ? qrSplitCardData[index] : qrData[index],
        errorStateBuilder: (BuildContext context, Object? error) {
          return _handleQrErrorMessage(context, error!);
        },
      ),
    );
  }

  Widget _handleQrErrorMessage(BuildContext context, Object error) {
    return const Center(
      child: Text(
        'QR code could not be generated',
        textAlign: TextAlign.center,
      ),
    );
  }

  void _initializeQrDataSplitter(List<String> qrData) {
    final StringBuffer buffer = StringBuffer();
    for (String data in qrData) {
      buffer.write(data.toString());
    }
    RegExp exp = RegExp('.{1,${charactersPerCard.toStringAsFixed(0)}}');
    Iterable<Match> matches = exp.allMatches(buffer.toString());
    qrSplitCardData = matches.map((Match m) => m.group(0)!).toList();
  }
}
