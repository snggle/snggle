import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp/otp.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/totp_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class EntryDetailsPageCubit extends Cubit<EntryDetailsPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordController _passwordController = globalLocator<PasswordController>();

  final EntryModel _entryModel;

  final TextEditingController titleTextEditingController = TextEditingController(text: 'My Credentials');
  final TextEditingController usernameTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final TextEditingController totpTextEditingController = TextEditingController();

  EntrySecretsModel? _entrySecretsModel;
  bool totpExistsBool = false;
  Timer? _totpTimer;

  EntryDetailsPageCubit({
    required EntryModel entryModel,
  })  : _entryModel = entryModel,
        super(const EntryDetailsPageState.loading());

  @override
  Future<void> close() async {
    _totpTimer?.cancel();
    _passwordController.removeByFilesystemPath(_entryModel.filesystemPath);

    titleTextEditingController.dispose();
    usernameTextEditingController.dispose();
    passwordTextEditingController.dispose();
    totpTextEditingController.dispose();

    await super.close();
  }

  Future<void> init() async {
    emit(state.copyWith(loadingBool: true));

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(_entryModel.filesystemPath);

    EntrySecretsModel entrySecretsModel = await _secretsService.get(
      _entryModel.filesystemPath,
      entryPasswordModel,
    );

    _entrySecretsModel = entrySecretsModel;
    usernameTextEditingController.text = entrySecretsModel.username ?? '';
    passwordTextEditingController.text = entrySecretsModel.password ?? '';

    _totpTimer?.cancel(); // TODO(kamil): might be unnecessary

    bool localTotpExistsBool = entrySecretsModel.totpConfig != null;
    if (localTotpExistsBool == true) {
      localTotpExistsBool = true;
      _enableTotp();
    } else {
      localTotpExistsBool = false;
      totpTextEditingController.text = '';
    }

    emit(state.copyWith(
      loadingBool: false,
      totpExistsBool: localTotpExistsBool,
      totpPeriod: entrySecretsModel.totpConfig?.period ?? 30,
      totpRemainingSeconds: localTotpExistsBool ? _getRemainingSeconds(entrySecretsModel.totpConfig!.period) : 0,
    ));
  }

  void _refreshTotp() {
    EntrySecretsModel? entrySecretsModel = _entrySecretsModel;
    TotpConfig? totpConfig = entrySecretsModel?.totpConfig;

    if (totpConfig!.secret.isEmpty) {
      return;
    }

    int now = DateTime.now().millisecondsSinceEpoch;

    String code = OTP.generateTOTPCodeString(
      totpConfig.secret,
      now,
      length: totpConfig.digits,
      interval: totpConfig.period,
      algorithm: totpConfig.algorithm,
      isGoogle: true,
    );

    int middle = code.length ~/ 2;
    code = '${code.substring(0, middle)} ${code.substring(middle)}';

    if (totpTextEditingController.text != code) {
      totpTextEditingController.text = code;
    }

    int remainingSeconds = _getRemainingSeconds(totpConfig.period);

    emit(state.copyWith(
      totpExistsBool: true,
      totpPeriod: totpConfig.period,
      totpRemainingSeconds: remainingSeconds,
    ));
  }

  int _getRemainingSeconds(int period) {
    int nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int elapsed = nowSeconds % period;
    return elapsed == 0 ? period : period - elapsed;
  }

  String buildQrData() {
    String login = usernameTextEditingController.text;
    String password = passwordTextEditingController.text;

    // TODO(kamil): reconsider content
    Map<String, String> jsonPayload = <String, String>{
      'login': login,
      'password': password,
    };

    return jsonEncode(jsonPayload);
  }

  Future<void> save() async {
    emit(state.copyWith(loadingBool: true));

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(_entryModel.filesystemPath);

    EntrySecretsModel currentSecrets =
        _entrySecretsModel ?? await _secretsService.get<EntrySecretsModel>(_entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['username'] = usernameTextEditingController.text
      ..['password'] = passwordTextEditingController.text;

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(_entryModel.filesystemPath, json);

    await _secretsService.save(updatedSecrets, entryPasswordModel);

    _entrySecretsModel = updatedSecrets;
    usernameTextEditingController.text = updatedSecrets.username ?? '';
    passwordTextEditingController.text = updatedSecrets.password ?? '';

    emit(state.copyWith(loadingBool: false));
  }

  Future<void> removeTotp() async {
    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(_entryModel.filesystemPath);
    EntrySecretsModel currentSecrets = _entrySecretsModel ?? await _secretsService.get(_entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['totpConfig'] = <String, dynamic>{
        'secret': '',
        'algorithm': 'SHA1',
        'digits': 6,
        'period': 30,
      };

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(_entryModel.filesystemPath, json);

    await _secretsService.save(updatedSecrets, entryPasswordModel);

    _totpTimer?.cancel();

    emit(state.copyWith(totpExistsBool: false, totpRemainingSeconds: 0, totpPeriod: 30));
  }

  void _enableTotp() {
    _refreshTotp();

    _totpTimer?.cancel();
    _totpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshTotp();
    });
  }
}
