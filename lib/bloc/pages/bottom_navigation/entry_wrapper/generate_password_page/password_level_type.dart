enum PasswordLevelType {
  unsafe,
  weak,
  good,
  excellent,
  magnificent,
  custom;

  String get displayName => '${name[0].toUpperCase()}${name.substring(1)}';

  int? get defaultLengthAscii {
    switch (this) {
      case PasswordLevelType.good:
        return 18;
      case PasswordLevelType.excellent:
        return 20;
      case PasswordLevelType.magnificent:
        return 40;
      case PasswordLevelType.custom:
      default:
        return null;
    }
  }

  int? get defaultLengthSip2 {
    switch (this) {
      case PasswordLevelType.good:
        return 20;
      case PasswordLevelType.excellent:
      case PasswordLevelType.magnificent:
      case PasswordLevelType.custom:
      default:
        return null;
    }
  }
}
