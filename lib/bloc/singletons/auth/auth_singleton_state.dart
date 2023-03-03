part of 'auth_singleton_cubit.dart';

class AuthSingletonState extends Equatable {
  final String? hashedAppPassword;

  const AuthSingletonState({
    required this.hashedAppPassword,
  });

  @override
  List<Object?> get props => <String?>[hashedAppPassword];
}
