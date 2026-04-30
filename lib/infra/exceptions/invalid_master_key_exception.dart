class InvalidMasterKeyException implements Exception {
  final String? message;

  InvalidMasterKeyException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}
