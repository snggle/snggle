import 'package:flutter/services.dart';
import 'package:snggle/shared/native/passkey_create/passkey_create_context.dart';

class NativePasskeyCreate {
  NativePasskeyCreate._();

  static const MethodChannel _channel = MethodChannel(
    'snggle/passkey_create',
  );

  static Future<PasskeyCreateContext> getContext() async {
    Map<Object?, Object?>? result =
    await _channel.invokeMapMethod<Object?, Object?>(
      'getPasskeyCreateContext',
    );

    if (result == null) {
      throw StateError('Passkey create context is missing');
    }

    return PasskeyCreateContext.fromMap(result);
  }

  static Future<void> finish({
    required String responseJson,
  }) async {
    await _channel.invokeMethod<void>(
      'finishPasskeyCreate',
      <String, Object>{
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