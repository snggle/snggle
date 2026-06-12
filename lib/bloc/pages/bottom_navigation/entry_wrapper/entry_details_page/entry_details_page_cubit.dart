import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class EntryDetailsPageCubit extends Cubit<EntryDetailsPageState> {
  final EntriesService _entriesService = globalLocator<EntriesService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordController _passwordController = globalLocator<PasswordController>();

  EntryModel _entryModel;

  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController websiteTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController usernameTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final TextEditingController totpTextEditingController = TextEditingController();

  EntrySecretsModel? _entrySecretsModel;
  bool totpExistsBool = false;
  Timer? _totpTimer;

  EntryDetailsPageCubit({
    required this._entryModel,
  }) : super(const EntryDetailsPageState.loading());

  EntryModel get entryModel => _entryModel;

  @override
  Future<void> close() async {
    _totpTimer?.cancel();
    _passwordController.removeByFilesystemPath(_entryModel.filesystemPath);

    nameTextEditingController.dispose();
    websiteTextEditingController.dispose();
    emailTextEditingController.dispose();
    usernameTextEditingController.dispose();
    passwordTextEditingController.dispose();
    totpTextEditingController.dispose();

    await super.close();
  }

  Future<void> init({DateTime? timestamp}) async {
    emit(state.copyWith(loadingBool: true));

    _entryModel = await _entriesService.getById(_entryModel.id);

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(_entryModel.filesystemPath);

    EntrySecretsModel entrySecretsModel = await _secretsService.get(
      _entryModel.filesystemPath,
      entryPasswordModel,
    );

    _entrySecretsModel = entrySecretsModel;
    nameTextEditingController.text = _entryModel.name;
    websiteTextEditingController.text = _entryModel.website;
    emailTextEditingController.text = entrySecretsModel.email;
    usernameTextEditingController.text = entrySecretsModel.username;
    passwordTextEditingController.text = entrySecretsModel.password;

    bool localTotpExistsBool = entrySecretsModel.totpSecret.isNotEmpty;
    if (localTotpExistsBool) {
      try {
        _enableTotp(timestamp: timestamp);
        emit(state.copyWith(
          loadingBool: false,
          totpExistsBool: true,
          totpRemainingSeconds: _getRemainingSeconds(timestamp: timestamp),
        ));
      } catch (e) {
        AppLogger().log(message: e.toString());
        emit(state.copyWith(
          loadingBool: false,
          totpExistsBool: false,
        ));
      }
    } else {
      emit(state.copyWith(
        loadingBool: false,
        totpExistsBool: false,
      ));
    }
  }

  Future<void> save() async {
    emit(state.copyWith(loadingBool: true));

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(_entryModel.filesystemPath);

    EntrySecretsModel currentSecrets =
        _entrySecretsModel ?? await _secretsService.get<EntrySecretsModel>(_entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['email'] = emailTextEditingController.text
      ..['username'] = usernameTextEditingController.text
      ..['password'] = passwordTextEditingController.text;

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(_entryModel.filesystemPath, json);

    await _secretsService.save(updatedSecrets, entryPasswordModel);

    _entrySecretsModel = updatedSecrets;
    emailTextEditingController.text = updatedSecrets.email;
    usernameTextEditingController.text = updatedSecrets.username;
    passwordTextEditingController.text = updatedSecrets.password;

    emit(state.copyWith(loadingBool: false));
  }

  int _getRemainingSeconds({DateTime? timestamp}) {
    int nowSeconds = (timestamp ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    int elapsed = nowSeconds % 30;
    return elapsed == 0 ? 30 : 30 - elapsed;
  }

  void _enableTotp({DateTime? timestamp}) {
    _refreshTotp(timestamp: timestamp);

    _totpTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _refreshTotp(timestamp: timestamp);
      },
    );
  }

  void _refreshTotp({DateTime? timestamp}) {
    EntrySecretsModel? entrySecretsModel = _entrySecretsModel;
    String totpSecret = entrySecretsModel?.totpSecret ?? '';

    if (totpSecret.isEmpty) {
      totpTextEditingController.text = '';
      emit(state.copyWith(totpExistsBool: false));
      return;
    }

    String totpCode = TOTP.generate(totpSecret, timestamp: timestamp);
    String formattedTotpCode = _formatTotpCode(totpCode);

    if (totpTextEditingController.text != formattedTotpCode) {
      totpTextEditingController.text = formattedTotpCode;
    }

    int remainingSeconds = _getRemainingSeconds(timestamp: timestamp);

    emit(state.copyWith(
      totpExistsBool: true,
      totpRemainingSeconds: remainingSeconds,
    ));
  }

  String _formatTotpCode(String value) {
    if (value.length != 6) {
      return value;
    }

    return '${value.substring(0, 3)} ${value.substring(3)}';
  }
}
