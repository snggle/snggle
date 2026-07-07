import 'package:snggle/shared/native/app_launch_mode.dart';

class AutofillSaveContext {
  final AppLaunchMode appLaunchMode;
  final String? appName;
  final String? email;
  final String? username;
  final String? password;

  const AutofillSaveContext({
    required this.appLaunchMode,
    required this.appName,
    required this.email,
    required this.username,
    required this.password,
  });

  factory AutofillSaveContext.fromMap(
      Map<Object?, Object?> map,
      ) {
    return AutofillSaveContext(
      appLaunchMode: AppLaunchMode.fromString(
        map['launchAction'] as String?,
      ),
      appName: map['appName'] as String?,
      email: map['email'] as String?,
      username: map['username'] as String?,
      password: map['password'] as String?,
    );
  }
}