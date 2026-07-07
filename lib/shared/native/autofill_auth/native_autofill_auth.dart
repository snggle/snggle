import 'package:flutter/services.dart';

class NativeAutofillAuth {
  static const MethodChannel _channel = MethodChannel('snggle/autofill_auth');

  static Future<Map<String, dynamic>> getContext() async {
    final Map<dynamic, dynamic>? result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getAutofillContext');

    return Map<String, dynamic>.from(result ?? <dynamic, dynamic>{});
  }

  static Future<void> selectCredential({
    required String password,
    String? email,
    String? username,
  }) {
    assert(
      email != null || username != null,
      'Either email or username must be provided',
    );

    return _channel.invokeMethod(
      'selectCredential',
      <String, dynamic>{
        if (email != null) 'email': email,
        if (username != null) 'username': username,
        'password': password,
      },
    );
  }

  static Future<void> cancel() {
    return _channel.invokeMethod('cancel');
  }
}
