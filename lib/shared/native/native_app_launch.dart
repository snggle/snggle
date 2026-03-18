import 'package:flutter/services.dart';
import 'package:snggle/shared/native/app_launch_context.dart';
import 'package:snggle/shared/native/app_launch_mode.dart';

class NativeAppLaunch {
  NativeAppLaunch._();

  static const MethodChannel _channel = MethodChannel(
    'snggle/app_launch',
  );

  static Future<AppLaunchContext> getContext() async {
    final Map<Object?, Object?>? result =
    await _channel.invokeMapMethod<Object?, Object?>(
      'getAppLaunchContext',
    );

    if (result == null) {
      return const AppLaunchContext(
        appLaunchMode: AppLaunchMode.main,
      );
    }

    return AppLaunchContext.fromMap(result);
  }
}