import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_singleton_state.dart';

class AuthSingletonCubit extends Cubit<AuthSingletonState> {
  AuthSingletonCubit() : super(const AuthSingletonState(hashedAppPassword: null));

  void setPassword(String hashedPassword) {
    emit(AuthSingletonState(hashedAppPassword: hashedPassword));
  }
}
