import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:snggle/passkey_create_context.dart';

class NativePasskeyCreate {
  static const MethodChannel _channel = MethodChannel(
    'snggle/passkey_create',
  );

  static Future<PasskeyCreateContext> getContext() async {
    final Map<dynamic, dynamic>? context =
    await _channel.invokeMethod(
      'getPasskeyCreateContext',
    );

    if (context == null) {
      throw Exception('Passkey create context is null');
    }

    return PasskeyCreateContext(
      requestJson: context['requestJson'] as String,
      clientDataHash: context['clientDataHash'] as Uint8List?,
      callingPackage: context['callingPackage'] as String?,
    );
  }

  static Future<void> finish({
    required String responseJson,
  }) async {
    await _channel.invokeMethod(
      'finishPasskeyCreate',
      {
        'responseJson': responseJson,
      },
    );
  }

  static Future<void> cancel() async {
    await _channel.invokeMethod(
      'cancelPasskeyCreate',
    );
  }
}