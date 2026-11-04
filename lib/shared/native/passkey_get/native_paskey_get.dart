import 'package:flutter/services.dart';
import 'package:snggle/shared/native/passkey_get/passkey_get_context.dart';

class NativePasskeyGet {
  static const MethodChannel _channel =
  MethodChannel('snggle/passkey_get');

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
    required String username,
  }) {
    return _channel.invokeMethod<void>(
      'selectPasskey',
      <String, dynamic>{
        'credentialId': credentialId,
        'username': username,
      },
    );
  }

  static Future<void> finishPasskeyGet({
    required String responseJson,
  }) {
    return _channel.invokeMethod<void>(
      'finishPasskeyGet',
      <String, dynamic>{
        'responseJson': responseJson,
      },
    );
  }

  static Future<void> cancel() {
    return _channel.invokeMethod<void>('cancel');
  }

  static Future<PasskeyGetContext> getPasskeyGetContext() async {
    final Map<String, dynamic> context = await getContext();

    return PasskeyGetContext.fromMap(context);
  }
}