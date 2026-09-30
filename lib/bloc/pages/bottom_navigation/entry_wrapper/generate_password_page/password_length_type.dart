enum PasswordLengthType {
  good,
  excellent,
  superb,
  custom;

  String get displayName => '${name[0].toUpperCase()}${name.substring(1)}';

  int? get defaultLength {
    switch (this) {
      case PasswordLengthType.good:
        return 18;
      case PasswordLengthType.excellent:
        return 20;
      case PasswordLengthType.superb:
        return 40;
      case PasswordLengthType.custom:
        return null;
    }
  }
}
