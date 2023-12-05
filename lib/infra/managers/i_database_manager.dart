import 'package:snggle/infra/managers/database_parent_key.dart';

abstract class IDatabaseManager {
  Future<bool> containsKey({required DatabaseParentKey databaseParentKey});

  Future<String> read({required DatabaseParentKey databaseParentKey});

  Future<void> write({required DatabaseParentKey databaseParentKey, required String plaintextValue});
}
