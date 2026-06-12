import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/a_app_set_up_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_loading_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

class AppSetUpPinPageCubit extends Cubit<AAppSetUpPinPageState> {
  final AppPinType appPinType;
  final AppMasterKeyType? appMasterKeyType;
  final MnemonicModel? mnemonicModel;

  final AppService _appService = globalLocator<AppService>();
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  AppSetUpPinPageCubit({
    required this.appPinType,
    this.appMasterKeyType,
    this.mnemonicModel,
  }) : super(const AppSetUpPinPageEnterPinState.empty());

  void updateFirstPin(List<int> firstPinNumbers) {
    emit(AppSetUpPinPageEnterPinState(firstPinNumbers: firstPinNumbers));
  }

  void updateConfirmPin(List<int> confirmPinNumbers) {
    assert(state is AppSetUpPinPageConfirmPinState, 'State must be [AppSetupPinPageConfirmPinState] to call this method');

    AppSetUpPinPageConfirmPinState appSetupPinPageConfirmPinState = state as AppSetUpPinPageConfirmPinState;
    emit(appSetupPinPageConfirmPinState.copyWith(confirmPinNumbers: confirmPinNumbers));
  }

  void setUpFirstPin() {
    AppSetUpPinPageEnterPinState appSetupPinPageEnterPinState = state as AppSetUpPinPageEnterPinState;
    emit(AppSetUpPinPageConfirmPinState(
      firstPinNumbers: appSetupPinPageEnterPinState.firstPinNumbers,
      confirmPinNumbers: const <int>[],
    ));
  }

  Future<void> setUpConfirmPin() async {
    Future<void> minOperationTime = Future<void>.delayed(const Duration(seconds: 1));

    assert(state is AppSetUpPinPageConfirmPinState, 'State must be [AppSetupPinPageConfirmPinState] to call this method');
    AppSetUpPinPageConfirmPinState appSetupPinPageConfirmPinState = state as AppSetUpPinPageConfirmPinState;
    if (appSetupPinPageConfirmPinState.arePasswordsEqual()) {
      List<int> firstPinNumbersList = appSetupPinPageConfirmPinState.firstPinNumbers;
      PasswordModel passwordModel = PasswordModel.fromPlaintext(firstPinNumbersList.join(''));
      await _submitEnteredPin(passwordModel);
      await minOperationTime;
    } else {
      emit(AppSetUpPinPageInvalidPinState(
        firstPinNumbers: appSetupPinPageConfirmPinState.firstPinNumbers,
        confirmPinNumbers: appSetupPinPageConfirmPinState.confirmPinNumbers,
      ));
      throw InvalidPasswordException('PIN numbers are not equal');
    }
  }

  void resetAllPins() {
    emit(const AppSetUpPinPageEnterPinState.empty());
  }

  Future<void> _submitEnteredPin(PasswordModel passwordModel) async {
    if (appPinType == AppPinType.changePin) {
      await _changePin(passwordModel);
    } else {
      await _savePin(passwordModel);
    }
  }

  Future<void> _changePin(PasswordModel passwordModel) async {
    emit(const AppSetUpPinPageLoadingState());
    await _masterKeyController.changePassword(passwordModel);
  }

  Future<void> _savePin(PasswordModel pinPasswordModel) async {
    emit(const AppSetUpPinPageLoadingState());
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

    await _createTopLevelFolder();
  }

  Future<void> _createTopLevelFolder() async {
    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();

    await Directory('${rootDirectory.path}/secrets/vaults').create(recursive: true);

    GroupSecretsModel vaultsRootSecretsModel = GroupSecretsModel.generate(FilesystemPath.fromString('vaults'));
    await globalLocator<SecretsService>().save(vaultsRootSecretsModel, PasswordModel.defaultPassword());
  }
}
