class InvalidCollectionException implements Exception {
  final String? message;

  InvalidCollectionException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}
