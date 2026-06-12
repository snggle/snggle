import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
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
import 'package:snggle/shared/utils/totp_secret_input_parser.dart';

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
  final TextEditingController totpSecretTextEditingController = TextEditingController();

  final FilesystemPath? _parentFilesystemPath;
  final EntryModel? _entryModel;
  final EntryPageType _entryPageType;
  late bool preexistingTotpBool;

  EntrySecretsModel? _entrySecretsModel;
  String _totpSecret = '';
  String _totpSecretRestoreBackup = '';
  bool _totpSecretRestoreBool = false;

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
    totpSecretTextEditingController.dispose();

    await super.close();
  }

  Future<void> init() async {
    nameTextEditingController.addListener(_updateEntryNameEmptyState);
    totpSecretTextEditingController.addListener(_handleSecretChanged);

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
      _totpSecret = entrySecretsModel.totpSecret;
    }

    bool localTotpExistsBool = _totpSecret.isNotEmpty;
    if (localTotpExistsBool) {
      totpSecretTextEditingController.text = _totpSecret;
    } else {
      removeTotp();
    }

    preexistingTotpBool = localTotpExistsBool == true;

    emit(state.copyWith(loadingBool: false, totpExistsBool: localTotpExistsBool));
  }

  Future<EntryModel?> save() async {
    if (nameTextEditingController.text.trim().isEmpty) {
      emit(state.copyWith(entryNameEmptyBool: true));
      return null;
    } else {
      emit(state.copyWith(entryNameEmptyBool: false));
    }

    if (totpSecretTextEditingController.text.trim().isEmpty) {
      removeTotp();
    } else if (_isSecretValidBool()) {
      _totpSecret = TotpSecretInputParser.fromInput(totpSecretTextEditingController.text);
      totpSecretTextEditingController.text = _totpSecret;
      emit(state.copyWith(totpExistsBool: true, totpInvalidBool: false));
    } else {
      emit(state.copyWith(totpExistsBool: true, totpInvalidBool: true));
      return null;
    }

    if (_entryPageType == EntryPageType.entryPageCreate) {
      return _createNewEntry();
    } else {
      return _updateEntry();
    }
  }

  void restorePreviousTotp() {
    if (_totpSecretRestoreBool == false) {
      return;
    }

    if (_totpSecretRestoreBackup.isNotEmpty) {
      _totpSecret = _totpSecretRestoreBackup;
      totpSecretTextEditingController.text = _totpSecret;
      emit(state.copyWith(totpExistsBool: true));
    } else {
      removeTotp();
    }
  }

  void removeTotp() {
    _totpSecret = '';
    totpSecretTextEditingController.text = '';
    emit(state.copyWith(totpExistsBool: false));
  }

  void startTotpEditingSession() {
    if (_totpSecretRestoreBool == true) {
      return;
    }

    _totpSecretRestoreBackup = _totpSecret;
    _totpSecretRestoreBool = true;
  }

  void finishTotpEditingSession() {
    _totpSecretRestoreBackup = '';
    _totpSecretRestoreBool = false;
  }

  bool _isSecretValidBool() {
    try {
      String totpSecret = TotpSecretInputParser.fromInput(totpSecretTextEditingController.text);
      TOTP.generate(totpSecret);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _handleSecretChanged() {
    emit(state.copyWith(totpInvalidBool: false));
  }

  Future<EntryModel?> _createNewEntry() async {
    return _entryModelFactory.createNewEntry(
      _parentFilesystemPath!,
      nameTextEditingController.text,
      websiteTextEditingController.text,
      emailTextEditingController.text,
      usernameTextEditingController.text,
      passwordTextEditingController.text,
      _totpSecret,
    );
  }

  Future<EntryModel?> _updateEntry() async {
    EntryModel entryModel = _entryModel!;
    String name = nameTextEditingController.text;
    String website = websiteTextEditingController.text;
    String email = emailTextEditingController.text;
    String username = usernameTextEditingController.text;
    String password = passwordTextEditingController.text;
    String totpSecret = _totpSecret;

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel currentSecrets = _entrySecretsModel ?? await _secretsService.get(entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['email'] = email
      ..['username'] = username
      ..['password'] = password
      ..['totpSecret'] = totpSecret;

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(entryModel.filesystemPath, json);
    EntryModel updatedEntryModel = entryModel.copyWith(
      name: name,
      website: website,
      emailExistsBool: email.isNotEmpty,
      usernameExistsBool: username.isNotEmpty,
      passwordExistsBool: password.isNotEmpty,
      totpExistsBool: totpSecret.isNotEmpty,
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
