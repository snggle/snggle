enum AppLaunchMode {
  autofillAuth,
  autofillSave,
  passkeyCreate,
  passkeyGet,
  main;

  static AppLaunchMode fromString(String? value) {
    return switch (value) {
      'autofillAuth' => AppLaunchMode.autofillAuth,
      'autofillSave' => AppLaunchMode.autofillSave,
      'passkeyCreate' => AppLaunchMode.passkeyCreate,
      'passkeyGet' => AppLaunchMode.passkeyGet,
      _ => AppLaunchMode.main,
    };
  }
}
