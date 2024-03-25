import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';

class SecretsAuthPageEnterPinState extends ASecretsAuthPageState {
  const SecretsAuthPageEnterPinState({required super.pinNumbers});

  SecretsAuthPageEnterPinState.empty() : super(pinNumbers: <int>[]);

  @override
  List<Object> get props => <Object>[pinNumbers];
}
