import 'package:snggle/shared/native/app_launch_mode.dart' show AppLaunchMode;

class AppLaunchContext {
  final AppLaunchMode appLaunchMode;

  const AppLaunchContext({
    required this.appLaunchMode,
  });

  factory AppLaunchContext.fromMap(
      Map<Object?, Object?> map,
      ) {
    return AppLaunchContext(
      appLaunchMode: AppLaunchMode.fromString(
        map['launchAction'] as String?,
      ),
    );
  }
}