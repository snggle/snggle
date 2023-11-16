import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';
import 'package:snggle/shared/models/multi_qr_code_item_model.dart';

class QrCodeScanPageReceivedState extends AQrCodeScanPageState {
  final List<MultiQrCodeItemModel> multiQrCodeItemModelList;
  final List<Duration> scanTimes;

  const QrCodeScanPageReceivedState({
    required this.multiQrCodeItemModelList,
    required this.scanTimes,
  });

  int get estimatedTotalDataLength {
    if (multiQrCodeItemModelList.isEmpty) {
      return 0;
    }
    int maxPages = multiQrCodeItemModelList.first.maxPages;
    int dataLength = multiQrCodeItemModelList.first.data.length;
    return maxPages * dataLength;
  }

  String get estimatedTimeToCompletion {
    if (scanTimes.isEmpty || multiQrCodeItemModelList.isEmpty) {
      return 'Unknown';
    }
    int maxPages = multiQrCodeItemModelList.first.maxPages;
    int remainingPages = maxPages - scannedPagesCount;
    int dataLength = multiQrCodeItemModelList.first.data.length;
    int estimatedSizeOfLeftovers = remainingPages * dataLength;
    return (estimatedSizeOfLeftovers / estimatedDataTransferRate).round().toString();
  }

  double get estimatedDataTransferRate {
    if (scanTimes.isEmpty || multiQrCodeItemModelList.isEmpty) {
      return 0;
    } else {
      Duration totalScanTime = Duration.zero;
      for (Duration duration in scanTimes) {
        totalScanTime += duration;
      }
      int estimatedDataTransferred = scannedPagesCount * multiQrCodeItemModelList.first.data.length;
      return estimatedDataTransferred / totalScanTime.inSeconds;
    }
  }

  double get percentageScanned {
    if (multiQrCodeItemModelList.isEmpty || scannedPagesCount == 0) {
      return 0;
    }
    int maxPages = multiQrCodeItemModelList.first.maxPages;
    return scannedPagesCount / maxPages;
  }

  int get scannedPagesCount {
    if (multiQrCodeItemModelList.isEmpty) {
      return 0;
    }
    return multiQrCodeItemModelList.length;
  }

  @override
  List<Object> get props => <Object>[multiQrCodeItemModelList, scanTimes];
}
