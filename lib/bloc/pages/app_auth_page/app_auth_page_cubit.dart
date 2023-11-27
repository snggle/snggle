import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_auth_page/a_app_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_invalid_pin_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

class AppAuthPageCubit extends Cubit<AAppAuthPageState> {
  final AppAuthService _appAuthService = globalLocator<AppAuthService>();
  final AuthSingletonCubit _authSingletonCubit;

  AppAuthPageCubit({AuthSingletonCubit? authSingletonCubit})
      : _authSingletonCubit = authSingletonCubit ?? globalLocator<AuthSingletonCubit>(),
        super(const AppAuthPageEnterPinState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(AppAuthPageEnterPinState(pinNumbers: pinNumbers));
  }

  Future<void> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _appAuthService.isPasswordValid(passwordModel);
    if (passwordValidBool) {
      _authSingletonCubit.setAppPassword(passwordModel);
    } else {
      emit(AppAuthPageInvalidPinState(pinNumbers: state.pinNumbers));
      throw InvalidPasswordException();
    }
  }
}
