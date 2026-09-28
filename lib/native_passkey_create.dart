import 'package:flutter/services.dart';
import 'package:snggle/passkey_create_context.dart';

class NativePasskeyCreate {
  static const MethodChannel _channel = MethodChannel(
    'snggle/passkey_create',
  );

  static Future<PasskeyCreateContext> getContext() async {
    final Map<dynamic, dynamic>? context =
    await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'getPasskeyCreateContext',
    );

    if (context == null) {
      throw Exception('Passkey create context is null');
    }

    return PasskeyCreateContext.fromMap(context);
  }

  static Future<void> finish({
    required String responseJson,
  }) async {
    await _channel.invokeMethod<void>(
      'finishPasskeyCreate',
      <String, String>{
        'responseJson': responseJson,
      },
    );
  }

  static Future<void> cancel() async {
    await _channel.invokeMethod<void>(
      'cancelPasskeyCreate',
    );
  }
}