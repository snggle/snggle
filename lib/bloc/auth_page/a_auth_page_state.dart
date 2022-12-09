part of 'auth_page_cubit.dart';

abstract class AAuthPageState extends Equatable {
  const AAuthPageState();

  @override
  List<Object> get props => <AAuthPageState>[];
}

class AuthPageInitialState extends AAuthPageState {}

class AuthPageLoadingAuthenticationState extends AAuthPageState {}

class AuthPageSuccessAuthenticationState extends AAuthPageState {}

class AuthPageInvalidAuthenticationState extends AAuthPageState {}

class AuthPageErrorState extends AAuthPageState {}
