import 'dart:convert';

import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/entities/salt_entity.dart';

class SaltRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  Future<bool> isSaltExist() async {
    bool saltExists = await _databaseManager.containsKey(databaseEntryKey: DatabaseEntryKey.salt);
    return saltExists;
  }

  Future<SaltEntity> getSaltEntity() async {
    String saltString = await _databaseManager.read(databaseEntryKey: DatabaseEntryKey.salt);
    Map<String, dynamic> saltJson = jsonDecode(saltString) as Map<String, dynamic>;
    SaltEntity saltEntity = SaltEntity.fromJson(saltJson);
    return saltEntity;
  }

  Future<void> setSaltEntity({required SaltEntity saltEntity}) async {
    await _databaseManager.write(databaseEntryKey: DatabaseEntryKey.salt, data: jsonEncode(saltEntity.toJson()));
  }
}
