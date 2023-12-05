class InvalidPasswordException implements Exception {
  final String? message;

  InvalidPasswordException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}
