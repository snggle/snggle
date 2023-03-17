import 'package:snggle/infra/managers/database_entry_key.dart';

abstract class IDatabaseManager {
  Future<bool> containsKey({required DatabaseEntryKey databaseEntryKey});

  Future<String> read({required DatabaseEntryKey databaseEntryKey});

  Future<Map<String, String>> readAll();

  Future<void> write({required DatabaseEntryKey databaseEntryKey, required String data});
} 