import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/a_app_pin_set_up_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_confirm_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_enter_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_loading_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_pin_page_invalid_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

class AppPinSetUpPageCubit extends Cubit<AAppPinSetUpPageState> {
  final AppPinType appPinType;
  final AppMasterKeyType? appMasterKeyType;
  final MnemonicModel? mnemonicModel;

  final AppService _appService = globalLocator<AppService>();
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  AppPinSetUpPageCubit({
    required this.appPinType,
    this.appMasterKeyType,
    this.mnemonicModel,
  }) : super(const AppPinSetUpPageEnterState.empty());

  void updateFirstPin(List<int> firstPinNumbers) {
    emit(AppPinSetUpPageEnterState(firstPinNumbers: firstPinNumbers));
  }

  void updateConfirmPin(List<int> confirmPinNumbers) {
    assert(state is AppPinSetUpPageConfirmState, 'State must be [AppPinSetUpPageConfirmState] to call this method');

    AppPinSetUpPageConfirmState appPinSetUpPageConfirmState = state as AppPinSetUpPageConfirmState;
    emit(appPinSetUpPageConfirmState.copyWith(confirmPinNumbers: confirmPinNumbers));
  }

  void setUpFirstPin() {
    AppPinSetUpPageEnterState appPinSetUpPageEnterState = state as AppPinSetUpPageEnterState;
    emit(AppPinSetUpPageConfirmState(
      firstPinNumbers: appPinSetUpPageEnterState.firstPinNumbers,
      confirmPinNumbers: const <int>[],
    ));
  }

  Future<void> setUpConfirmPin() async {
    Future<void> minOperationTime = Future<void>.delayed(const Duration(seconds: 1));

    assert(state is AppPinSetUpPageConfirmState, 'State must be [AppPinSetUpPageConfirmState] to call this method');
    AppPinSetUpPageConfirmState appPinSetUpPageConfirmState = state as AppPinSetUpPageConfirmState;
    if (appPinSetUpPageConfirmState.arePasswordsEqual()) {
      List<int> firstPinNumbersList = appPinSetUpPageConfirmState.firstPinNumbers;
      PasswordModel passwordModel = PasswordModel.fromPlaintext(firstPinNumbersList.join(''));
      await _submitEnteredPin(passwordModel);
      await minOperationTime;
    } else {
      emit(AppPinSetUpPageInvalidState(
        firstPinNumbers: appPinSetUpPageConfirmState.firstPinNumbers,
        confirmPinNumbers: appPinSetUpPageConfirmState.confirmPinNumbers,
      ));
      throw InvalidPasswordException('PIN numbers are not equal');
    }
  }

  void resetAllPins() {
    emit(const AppPinSetUpPageEnterState.empty());
  }

  Future<void> _submitEnteredPin(PasswordModel passwordModel) async {
    if (appPinType == AppPinType.change) {
      await _changePin(passwordModel);
    } else {
      await _savePin(passwordModel);
    }
  }

  Future<void> _changePin(PasswordModel passwordModel) async {
    emit(const AppPinSetUpPageLoadingState());
    await _masterKeyController.changePassword(passwordModel);
  }

  Future<void> _savePin(PasswordModel pinPasswordModel) async {
    emit(const AppPinSetUpPageLoadingState());
    if (appMasterKeyType == AppMasterKeyType.create) {
      await _appService.wipeAll();
      await globalLocator<IsarDatabaseManager>().initDatabase();
    }
    if (mnemonicModel == null) {
      throw Exception('Mnemonic cannot be empty');
    }
    MasterKeyVO masterKeyVO = await MasterKeyVO.create(passwordModel: pinPasswordModel, mnemonicModel: mnemonicModel!);
    await _masterKeyService.setMasterKey(masterKeyVO);

    _masterKeyController.setPassword(pinPasswordModel);
  }
}
