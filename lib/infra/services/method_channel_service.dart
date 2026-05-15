import 'package:flutter/services.dart';

class MethodChannelService {
  static const MethodChannel _channel =
  MethodChannel('autofill');

  static void initialize() {
    _channel.setMethodCallHandler(_handleCalls);
  }

  static Future<dynamic> _handleCalls(MethodCall call) async {
    switch (call.method) {
      case 'getCredentials':


      default:
        throw MissingPluginException();
    }
  }
}