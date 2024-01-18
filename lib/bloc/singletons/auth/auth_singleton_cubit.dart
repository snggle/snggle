import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

part 'auth_singleton_state.dart';

class AuthSingletonCubit extends Cubit<AuthSingletonState> {
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();

  AuthSingletonCubit() : super(const AuthSingletonState(appPasswordModel: null));

  void setAppPassword(PasswordModel appPasswordModel) {
    emit(AuthSingletonState(appPasswordModel: appPasswordModel));
  }

  Future<Ciphertext> encrypt(String plaintextValue) async {
    if (plaintextValue.isEmpty) {
      throw const FormatException('Provided [plaintextValue] is empty. AES256 encryption does not support empty strings');
    } else if (currentAppPasswordModel == null) {
      throw Exception('[AuthSingletonCubit] state does not contain [appPasswordModel] which is required to encrypt data with Master Key');
    }

    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();

    Ciphertext ciphertext = masterKeyVO.encrypt(appPasswordModel: currentAppPasswordModel!, plaintextValue: plaintextValue);
    return ciphertext;
  }

  Future<String> decrypt(Ciphertext ciphertext) async {
    if (currentAppPasswordModel == null) {
      throw Exception('[AuthSingletonCubit] state does not contain [appPasswordModel] which is required to decrypt data with Master Key');
    }

    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
    String decryptedValue = masterKeyVO.decrypt(appPasswordModel: currentAppPasswordModel!, ciphertext: ciphertext);
    return decryptedValue;
  }

  PasswordModel? get currentAppPasswordModel => state.appPasswordModel;
}
