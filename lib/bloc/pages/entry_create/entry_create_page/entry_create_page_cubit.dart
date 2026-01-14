import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_create/entry_create_page/entry_create_page_state.dart';
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
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

  final FilesystemPath? _parentFilesystemPath;
  final EntryModel? _entryModel;
  final EntryPageType _mode;

  EntrySecretsModel? _entrySecretsModel;

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

    await super.close();
  }

  Future<void> init() async {
    if (_mode == EntryPageType.entryPageCreate) {
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
      loginTextEditingController.text = entrySecretsModel.username ?? '';
      passwordTextEditingController.text = entrySecretsModel.password ?? '';
    }

    emit(state.copyWith(
      loadingBool: false,
    ));
  }

  Future<EntryModel?> save() async {
    if (nameTextEditingController.text.isEmpty) {
      emit(const EntryCreatePageState(entryNameEmptyBool: true));
      return null;
    }

    emit(const EntryCreatePageState(entryNameEmptyBool: false));

    if (_mode == EntryPageType.entryPageCreate) {
      return _createNewEntry();
    } else {
      return _updateEntry();
    }
  }

  Future<EntryModel?> _createNewEntry() async {
    return _entryModelFactory.createNewEntry(
      _parentFilesystemPath!,
      nameTextEditingController.text,
      loginTextEditingController.text,
      passwordTextEditingController.text,
    );
  }

  Future<EntryModel?> _updateEntry() async {
    EntryModel entryModel = _entryModel!;

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel currentSecrets = _entrySecretsModel ?? await _secretsService.get(entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['username'] = loginTextEditingController.text
      ..['password'] = passwordTextEditingController.text;

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(entryModel.filesystemPath, json);

    await _secretsService.save(updatedSecrets, entryPasswordModel);

    _entrySecretsModel = updatedSecrets;

    return entryModel;
  }
}
