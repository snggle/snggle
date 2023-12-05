part of 'auth_singleton_cubit.dart';

class AuthSingletonState extends Equatable {
  final PasswordModel? appPasswordModel;

  const AuthSingletonState({
    required this.appPasswordModel,
  });

  @override
  List<Object?> get props => <Object?>[appPasswordModel];
}
