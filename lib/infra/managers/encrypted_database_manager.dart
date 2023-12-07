import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/i_database_manager.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

/// Class to store data in database in encrypted form.
/// Using [DecryptedDatabaseManager] data is stored as a plain text.
/// e.g.:
/// {
///    "some_key": "some_value"
/// }
/// [EncryptedDatabaseManager] allows to store the same data in encrypted form:
/// e.g.:
/// {
///    "some_key": "9af15b336e6a9619928537df30b2e6a2376569f"
/// }
class EncryptedDatabaseManager implements IDatabaseManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final AuthSingletonCubit _authSingletonCubit;

  EncryptedDatabaseManager({
    AuthSingletonCubit? authSingletonCubit,
  }) : _authSingletonCubit = authSingletonCubit ?? globalLocator<AuthSingletonCubit>();

  @override
  Future<bool> containsKey({required DatabaseParentKey databaseParentKey}) async {
    return _flutterSecureStorage.containsKey(key: databaseParentKey.name);
  }

  @override
  Future<String> read({required DatabaseParentKey databaseParentKey}) async {
    String? encryptedData = await _flutterSecureStorage.read(key: databaseParentKey.name);
    if (encryptedData == null) {
      throw ParentKeyNotFoundException('${databaseParentKey.name} parent key not found in database');
    } else if (encryptedData.isEmpty) {
      throw FormatException('Value for ${databaseParentKey.name} parent key is empty. AES256 encryption does not support empty strings');
    } else if (_authSingletonCubit.currentAppPasswordModel == null) {
      throw Exception('[AuthSingletonCubit] state does not contain [appPasswordModel] which is required to decrypt ${databaseParentKey.name} value');
    }

    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
    PasswordModel appPasswordModel = _authSingletonCubit.currentAppPasswordModel!;
    return masterKeyVO.decrypt(appPasswordModel: appPasswordModel, encryptedData: encryptedData);
  }

  @override
  Future<void> write({required DatabaseParentKey databaseParentKey, required String plaintextValue}) async {
    if (plaintextValue.isEmpty) {
      throw const FormatException('Provided [plaintextValue] is empty. AES256 encryption does not support empty strings');
    } else if (_authSingletonCubit.currentAppPasswordModel == null) {
      throw Exception('[AuthSingletonCubit] state does not contain [appPasswordModel] which is required to encrypt ${databaseParentKey.name} value');
    }

    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
    PasswordModel appPasswordModel = _authSingletonCubit.currentAppPasswordModel!;

    String encryptedData = masterKeyVO.encrypt(appPasswordModel: appPasswordModel, decryptedData: plaintextValue);
    await _flutterSecureStorage.write(key: databaseParentKey.name, value: encryptedData);
  }
}
