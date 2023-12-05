import 'package:snggle/bloc/app_setup_pin_page/app_setup_pin_page_cubit.dart';
import 'package:snggle/shared/models/password_model.dart';

class AppSetupPinPageConfirmState extends AAppSetupPinPageState {
  final PasswordModel passwordModel;

  const AppSetupPinPageConfirmState({required this.passwordModel});

  @override
  List<Object> get props => <Object>[passwordModel];
}
