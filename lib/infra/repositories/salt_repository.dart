import 'dart:convert';

import 'package:snggle/infra/entities/salt_entity.dart';
import 'package:snggle/infra/managers/database_entry_key.dart';
import 'package:snggle/infra/managers/decrypted_database_manager.dart';

class SaltRepository {
  final DecryptedDatabaseManager _decryptedDatabaseManager = DecryptedDatabaseManager();

  Future<bool> isSaltExist() async {
    bool saltExists = await _decryptedDatabaseManager.containsKey(databaseEntryKey: DatabaseEntryKey.salt);
    return saltExists;
  }

  Future<SaltEntity> getSaltEntity() async {
    String saltString = await _decryptedDatabaseManager.read(databaseEntryKey: DatabaseEntryKey.salt);
    Map<String, dynamic> saltJson = jsonDecode(saltString) as Map<String, dynamic>;
    SaltEntity saltEntity = SaltEntity.fromJson(saltJson);
    return saltEntity;
  }

  Future<void> setSaltEntity({required SaltEntity saltEntity}) async {
    await _decryptedDatabaseManager.write(databaseEntryKey: DatabaseEntryKey.salt, data: jsonEncode(saltEntity.toJson()));
  }
}
