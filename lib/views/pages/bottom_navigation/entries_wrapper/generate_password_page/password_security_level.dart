enum PasswordSecurityLevel {
  unsafe,
  weak,
  good,
  excellent,
  superb;

  String get displayName => '${name[0].toUpperCase()}${name.substring(1)}';
}
