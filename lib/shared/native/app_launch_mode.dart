enum AppLaunchMode {
  autofillAuth,
  autofillSave,
  main;

  static AppLaunchMode fromString(String? value) {
    return switch (value) {
      'autofillAuth' => AppLaunchMode.autofillAuth,
      'autofillSave' => AppLaunchMode.autofillSave,
      _ => AppLaunchMode.main,
    };
  }
}