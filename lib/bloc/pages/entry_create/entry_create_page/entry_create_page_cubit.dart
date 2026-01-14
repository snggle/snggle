import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp/otp.dart';
import 'package:snggle/bloc/pages/entry_create/entry_create_page/entry_create_page_state.dart';
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/totp_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryCreatePageCubit extends Cubit<EntryCreatePageState> {
  final EntryModelFactory _entryModelFactory = globalLocator<EntryModelFactory>();
  final EntriesService _entriesService = globalLocator<EntriesService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordController _passwordController = globalLocator<PasswordController>();

  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController loginTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final TextEditingController totpTextEditingController = TextEditingController();

  final FilesystemPath? _parentFilesystemPath;
  final EntryModel? _entryModel;
  final EntryPageType _mode;

  EntrySecretsModel? _entrySecretsModel;
  TotpConfig? _totpConfig;
  bool totpExistsBool = false;
  Timer? _totpTimer;

  EntryCreatePageCubit({
    required FilesystemPath? parentFilesystemPath,
    required EntryModel? entryModel,
    required EntryPageType mode,
  })  : _parentFilesystemPath = parentFilesystemPath,
        _entryModel = entryModel,
        _mode = mode,
        super(const EntryCreatePageState());

  @override
  Future<void> close() async {
    nameTextEditingController.dispose();
    loginTextEditingController.dispose();
    passwordTextEditingController.dispose();
    totpTextEditingController.dispose();

    await super.close();
  }

  Future<void> init() async {
    if (_mode == EntryPageType.create) {
      int lastEntryIndex = await _entriesService.getLastIndex();

      if (lastEntryIndex == -1) {
        nameTextEditingController.text = 'Entry';
      } else {
        nameTextEditingController.text = 'Entry ${lastEntryIndex + 1}';
      }
    } else {
      final EntryModel entryModel = _entryModel!;
      nameTextEditingController.text = entryModel.name;

      PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

      EntrySecretsModel entrySecretsModel = await _secretsService.get(
        entryModel.filesystemPath,
        entryPasswordModel,
      );

      _entrySecretsModel = entrySecretsModel;
      _totpConfig = entrySecretsModel.totpConfig;
      loginTextEditingController.text = entrySecretsModel.username ?? '';
      passwordTextEditingController.text = entrySecretsModel.password ?? '';
    }

    _totpTimer?.cancel(); // TODO(kamil): might be unnecessary

    bool localTotpExistsBool = _totpConfig != null;
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
      totpPeriod: _totpConfig?.period ?? 30,
      totpRemainingSeconds: localTotpExistsBool ? _getRemainingSeconds(_totpConfig!.period) : 0,
    ));
  }

  Future<EntryModel?> save() async {
    _totpTimer?.cancel();
    if (nameTextEditingController.text.isEmpty) {
      emit(const EntryCreatePageState(entryNameEmptyBool: true));
      return null;
    }

    emit(const EntryCreatePageState(entryNameEmptyBool: false));

    if (_mode == EntryPageType.create) {
      return _createNewEntry();
    } else {
      return _updateEntry();
    }
  }

  Future<void> setTotpConfig(TotpConfig config) async {
    _totpConfig = config;
    _enableTotp();
    emit(state.copyWith(
      totpExistsBool: true,
      totpPeriod: config.period,
      totpRemainingSeconds: _getRemainingSeconds(config.period),
    ));
  }

  Future<EntryModel?> _createNewEntry() async {
    return _entryModelFactory.createNewEntry(
      _parentFilesystemPath!,
      nameTextEditingController.text,
      loginTextEditingController.text,
      passwordTextEditingController.text,
      _totpConfig,
    );
  }

  Future<EntryModel?> _updateEntry() async {
    EntryModel entryModel = _entryModel!;

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel currentSecrets = _entrySecretsModel ?? await _secretsService.get(entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['username'] = loginTextEditingController.text
      ..['password'] = passwordTextEditingController.text
      ..['totpConfig'] = _totpConfig?.toJson();

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(entryModel.filesystemPath, json);

    await _secretsService.save(updatedSecrets, entryPasswordModel);

    _entrySecretsModel = updatedSecrets;

    return entryModel;
  }

  void _refreshTotp() {
    final TotpConfig? totpConfig = _totpConfig;
    if (totpConfig == null || totpConfig.secret.isEmpty) {
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

  Future<void> removeTotp() async {
    _totpConfig = null;
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
