class ChildKeyNotFoundException implements Exception {
  final String? message;

  ChildKeyNotFoundException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}
