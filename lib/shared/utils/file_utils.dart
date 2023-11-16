import 'dart:math';

class FileUtils {
  static String estimateDataSize(int size) {
    assert(size >= 0, 'Data size must be greater than or equal to 0');

    if (size > 0) {
      final List<String> siSuffixes = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
      final int unitIndex = (log(size) / log(1024)).floor();
      final num unitValue = size / pow(1024, unitIndex);
      String unitString = unitValue.toStringAsFixed(2);
      if (unitValue.toStringAsFixed(2).endsWith('.0')) {
        unitString = unitValue.toInt().toString();
      }
      return '$unitString ${siSuffixes[unitIndex]}';
    }
    return '0 B';
  }
}
