import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';

class SecretsSetupPinPageEnterPinState extends ASecretsSetupPinPageState {
  final List<int> firstPinNumbers;

  const SecretsSetupPinPageEnterPinState({required this.firstPinNumbers});

  const SecretsSetupPinPageEnterPinState.empty() : firstPinNumbers = const <int>[];

  @override
  List<Object?> get props => <Object?>[firstPinNumbers];
}
