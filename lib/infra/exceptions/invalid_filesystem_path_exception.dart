class InvalidFilesystemPathException implements Exception {
  final String? message;

  InvalidFilesystemPathException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}
