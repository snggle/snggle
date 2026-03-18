enum AppLaunchMode {
  autofillAuth,
  main;

  static AppLaunchMode fromString(String? value) {
    return switch (value) {
      'autofillAuth' => AppLaunchMode.autofillAuth,
      _ => AppLaunchMode.main,
    };
  }
}