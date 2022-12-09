part of 'initial_page_cubit.dart';

abstract class AInitialPageState extends Equatable {
  const AInitialPageState();

  @override
  List<Object> get props => <AInitialPageState>[];
}

class InitialPageInitialState extends AInitialPageState {}

class InitialPageSetupAuthenticationState extends AInitialPageState {}

class InitialPageAuthenticateState extends AInitialPageState {}

class InitialPageNoAuthenticationState extends AInitialPageState {}

class InitialPageErrorState extends AInitialPageState {}
