import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
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

  EntrySecretsModel? _entrySecretsModel;

  EntryDetailsPageCubit({
    required EntryModel entryModel,
  })  : _entryModel = entryModel,
        super(const EntryDetailsPageState.loading());

  @override
  Future<void> close() async {
    _passwordController.removeByFilesystemPath(_entryModel.filesystemPath);

    titleTextEditingController.dispose();
    usernameTextEditingController.dispose();
    passwordTextEditingController.dispose();

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

    emit(state.copyWith(
      loadingBool: false,
    ));
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
}
