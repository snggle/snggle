import 'package:flutter/services.dart';

class AndroidUtils {
  static const MethodChannel _channel = MethodChannel('android_utils');

  static Future<int?> getApiLevel() async {
    return _channel.invokeMethod<int>('getApiLevel');
  }
}
