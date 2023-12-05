import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/shared/models/password_model.dart';

part 'auth_singleton_state.dart';

class AuthSingletonCubit extends Cubit<AuthSingletonState> {
  AuthSingletonCubit() : super(const AuthSingletonState(appPasswordModel: null));

  void setAppPassword(PasswordModel appPasswordModel) {
    emit(AuthSingletonState(appPasswordModel: appPasswordModel));
  }

  PasswordModel? get currentAppPasswordModel => state.appPasswordModel;
}
