import 'package:flutter/services.dart';

class NativeAutofillAuth {
  static const MethodChannel _channel = MethodChannel('snggle/autofill_auth');

  static Future<Map<String, dynamic>> getContext() async {
    final Map<dynamic, dynamic>? result =
    await _channel.invokeMethod<Map<dynamic, dynamic>>('getAutofillContext');

    return Map<String, dynamic>.from(result ?? <dynamic, dynamic>{});
  }

  static Future<void> selectCredential({
    required String username,
    required String password,
  }) {
    return _channel.invokeMethod('selectCredential', <String, dynamic>{
      'username': username,
      'password': password,
    });
  }

  static Future<void> cancel() {
    return _channel.invokeMethod('cancel');
  }
}