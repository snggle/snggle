enum PasswordLevelType {
  unsafe,
  weak,
  good,
  excellent,
  magnificent,
  custom;

  String get displayName => '${name[0].toUpperCase()}${name.substring(1)}';

  int? get entropyTarget {
    switch (this) {
      case PasswordLevelType.good:
        return 112;
      case PasswordLevelType.excellent:
        return 128;
      case PasswordLevelType.magnificent:
        return 256;
      case PasswordLevelType.custom:
      default:
        return null;
    }
  }
}
