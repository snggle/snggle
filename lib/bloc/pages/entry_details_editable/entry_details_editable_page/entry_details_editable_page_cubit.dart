import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryDetailsEditablePageCubit extends Cubit<EntryDetailsEditablePageState> {
  final EntryModelFactory _entryModelFactory = globalLocator<EntryModelFactory>();
  final EntriesService _entriesService = globalLocator<EntriesService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordController _passwordController = globalLocator<PasswordController>();

  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController websiteTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController usernameTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  final FilesystemPath? _parentFilesystemPath;
  final EntryModel? _entryModel;
  final EntryPageType _entryPageType;

  EntrySecretsModel? _entrySecretsModel;

  EntryDetailsEditablePageCubit({
    required this._parentFilesystemPath,
    required this._entryModel,
    required this._entryPageType,
  }) : super(const EntryDetailsEditablePageState.loading());

  @override
  Future<void> close() async {
    nameTextEditingController.dispose();
    websiteTextEditingController.dispose();
    emailTextEditingController.dispose();
    usernameTextEditingController.dispose();
    passwordTextEditingController.dispose();

    await super.close();
  }

  Future<void> init() async {
    nameTextEditingController.addListener(_updateEntryNameEmptyState);

    if (_entryPageType == EntryPageType.entryPageCreate) {
      int lastEntryIndex = await _entriesService.getLastIndex();

      if (lastEntryIndex == -1) {
        nameTextEditingController.text = 'Entry';
      } else {
        nameTextEditingController.text = 'Entry ${lastEntryIndex + 1}';
      }
    } else {
      EntryModel entryModel = _entryModel!;
      nameTextEditingController.text = entryModel.name;
      websiteTextEditingController.text = entryModel.website;

      PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

      EntrySecretsModel entrySecretsModel = await _secretsService.get(
        entryModel.filesystemPath,
        entryPasswordModel,
      );

      _entrySecretsModel = entrySecretsModel;
      emailTextEditingController.text = entrySecretsModel.email;
      usernameTextEditingController.text = entrySecretsModel.username;
      passwordTextEditingController.text = entrySecretsModel.password;
    }

    emit(state.copyWith(loadingBool: false));
  }

  Future<EntryModel?> save() async {
    if (nameTextEditingController.text.trim().isEmpty) {
      emit(state.copyWith(entryNameEmptyBool: true));
      return null;
    } else {
      emit(state.copyWith(entryNameEmptyBool: false));
    }

    if (_entryPageType == EntryPageType.entryPageCreate) {
      return _createNewEntry();
    } else {
      return _updateEntry();
    }
  }

  Future<EntryModel?> _createNewEntry() async {
    return _entryModelFactory.createNewEntry(
      _parentFilesystemPath!,
      nameTextEditingController.text,
      websiteTextEditingController.text,
      emailTextEditingController.text,
      usernameTextEditingController.text,
      passwordTextEditingController.text,
    );
  }

  Future<EntryModel?> _updateEntry() async {
    EntryModel entryModel = _entryModel!;
    String name = nameTextEditingController.text;
    String website = websiteTextEditingController.text;
    String email = emailTextEditingController.text;
    String username = usernameTextEditingController.text;
    String password = passwordTextEditingController.text;

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel currentSecrets = _entrySecretsModel ?? await _secretsService.get(entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['email'] = email
      ..['username'] = username
      ..['password'] = password;

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(entryModel.filesystemPath, json);
    EntryModel updatedEntryModel = entryModel.copyWith(
      name: name,
      website: website,
      emailExistsBool: email.isNotEmpty,
      usernameExistsBool: username.isNotEmpty,
      passwordExistsBool: password.isNotEmpty,
    );

    await _secretsService.save(updatedSecrets, entryPasswordModel);
    await _entriesService.save(updatedEntryModel);

    _entrySecretsModel = updatedSecrets;

    return updatedEntryModel;
  }

  void _updateEntryNameEmptyState() {
    bool tmpEntryNameEmptyBool = nameTextEditingController.text.trim().isEmpty;

    if (state.entryNameEmptyBool != tmpEntryNameEmptyBool) {
      emit(state.copyWith(entryNameEmptyBool: tmpEntryNameEmptyBool));
    }
  }
}
