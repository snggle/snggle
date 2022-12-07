part of 'auth_page_cubit.dart';

abstract class AAuthPageState extends Equatable {
  const AAuthPageState();

  @override
  List<Object> get props => <AAuthPageState>[];
}

class AuthPageInitialState extends AAuthPageState {}

class AuthPageSetupAuthenticationState extends AAuthPageState {}

class AuthPageAuthenticateState extends AAuthPageState {}

class AuthPageNoAuthenticationState extends AAuthPageState {}

class AuthPageLoadingAuthenticationState extends AAuthPageState {}

class AuthPageSuccessAuthenticationState extends AAuthPageState {}

class AuthPageInvalidAuthenticationState extends AAuthPageState {}

class AuthPageErrorAuthenticationState extends AAuthPageState {}
