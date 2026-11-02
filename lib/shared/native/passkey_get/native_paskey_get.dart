import 'package:flutter/services.dart';

class NativePasskeyGet {
  static const MethodChannel _channel = MethodChannel('snggle/passkey_get');

  static Future<Map<String, dynamic>> getContext() async {
    final Map<dynamic, dynamic>? result =
    await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'getPasskeyGetContext',
    );

    return Map<String, dynamic>.from(
      result ?? <dynamic, dynamic>{},
    );
  }

  static Future<void> selectPasskey({
    required String credentialId,
  }) {
    return _channel.invokeMethod(
      'selectPasskey',
      <String, dynamic>{
        'credentialId': credentialId,
      },
    );
  }

  static Future<void> cancel() {
    return _channel.invokeMethod('cancel');
  }
}