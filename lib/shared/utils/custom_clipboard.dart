import 'package:flutter/services.dart';

class CustomClipboard {
  static const MethodChannel _channel = MethodChannel('custom_clipboard');

  static Future<void> setDataObscuringPreview({required String text}) {
    return _channel.invokeMethod('setDataObscuringPreview', text);
  }
}
