class ParentKeyNotFoundException implements Exception {
  final String? message;

  ParentKeyNotFoundException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}
