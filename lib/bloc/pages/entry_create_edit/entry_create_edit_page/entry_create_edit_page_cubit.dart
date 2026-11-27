import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_state.dart';
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
import 'package:snggle/views/pages/entry_create_edit/entry_page_type.dart';

class EntryCreateEditPageCubit extends Cubit<EntryCreateEditPageState> {
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

  final FilesystemPath _parentFilesystemPath;
  final EntryModel? _entryModel;
  final EntryPageType _entryPageType;

  EntrySecretsModel? _entrySecretsModel;

  EntryCreateEditPageCubit({
    required this._parentFilesystemPath,
    required this._entryModel,
    required this._entryPageType,
  }) : super(const EntryCreateEditPageState.loading());

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
    emailTextEditingController.addListener(_validateEmail);

    String totpSecret = '';
    if (_entryPageType == EntryPageType.create) {
      int lastEntryIndex = await _entriesService.getLastIndex();

      if (lastEntryIndex == -1) {
        nameTextEditingController.text = 'Entry';
      } else {
        nameTextEditingController.text = 'Entry ${lastEntryIndex + 1}';
      }
    } else {
      EntryModel entryModel = _entryModel!;
      nameTextEditingController.text = entryModel.name.trim();
      websiteTextEditingController.text = entryModel.website.trim();

      PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

      EntrySecretsModel entrySecretsModel = await _secretsService.get(
        entryModel.filesystemPath,
        entryPasswordModel,
      );

      _entrySecretsModel = entrySecretsModel;
      emailTextEditingController.text = entrySecretsModel.email;
      usernameTextEditingController.text = entrySecretsModel.username;
      passwordTextEditingController.text = entrySecretsModel.password;
      totpSecret = entrySecretsModel.totpSecret;
    }

    totpSecretTextEditingController.text = totpSecret;
    emit(state.copyWith(loadingBool: false, totpExistsBool: totpSecret.isNotEmpty));
  }

  Future<EntryModel?> save() async {
    _updateEntryNameEmptyState();
    _validateEmail();

    bool entryInvalidBool = state.entryNameEmptyBool || state.emailInvalidBool;
    if (entryInvalidBool) {
      return null;
    }

    if (_entryPageType == EntryPageType.create) {
      return _createNewEntry();
    } else {
      return _updateEntry();
    }
  }

  void updateTotpSecret(String totpSecret) {
    totpSecretTextEditingController.text = totpSecret;
    emit(state.copyWith(totpExistsBool: totpSecret.isNotEmpty));
  }

  Future<EntryModel?> _createNewEntry() async {
    return _entryModelFactory.createNewEntry(
      _parentFilesystemPath,
      nameTextEditingController.text.trim(),
      websiteTextEditingController.text.trim(),
      emailTextEditingController.text,
      usernameTextEditingController.text,
      passwordTextEditingController.text,
      totpSecretTextEditingController.text,
    );
  }

  Future<EntryModel?> _updateEntry() async {
    EntryModel entryModel = _entryModel!;
    String name = nameTextEditingController.text.trim();
    String website = websiteTextEditingController.text.trim();
    String email = emailTextEditingController.text;
    String username = usernameTextEditingController.text;
    String password = passwordTextEditingController.text;
    String totpSecret = totpSecretTextEditingController.text;

    PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel currentSecrets = _entrySecretsModel ?? await _secretsService.get(entryModel.filesystemPath, entryPasswordModel);

    Map<String, dynamic> json = currentSecrets.toJson()
      ..['email'] = email
      ..['username'] = username
      ..['password'] = password
      ..['totpSecret'] = totpSecret;

    EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(entryModel.filesystemPath, json);
    EntryModel updatedEntryModel = entryModel.copyWith(
      name: name.trim(),
      website: website.trim(),
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
    bool entryNameEmptyBool = nameTextEditingController.text.trim().isEmpty;
    bool entryNameStateChangedBool = state.entryNameEmptyBool != entryNameEmptyBool;
    if (entryNameStateChangedBool) {
      emit(state.copyWith(entryNameEmptyBool: entryNameEmptyBool));
    }
  }

  void _validateEmail() {
    String email = emailTextEditingController.text;
    bool atSignExistsBool = email.contains('@');
    bool atSignNotLastBool = email.endsWith('@') == false;
    bool emailValidBool = atSignExistsBool && atSignNotLastBool;

    emit(state.copyWith(emailInvalidBool: email.isNotEmpty && emailValidBool == false));
  }

  Uri? _generateTotpExportUri(EntryModel entryModel, EntrySecretsModel entrySecretsModel) {
    String totpSecret = TotpSecretInputParser.fromInput(entrySecretsModel.totpSecret).toUpperCase().replaceFirst(RegExp(r'=+$'), '');
    bool secretMissingBool = totpSecret.isEmpty;
    if (secretMissingBool) {
      return null;
    }

    const String issuer = 'SNGGLE';
    String entryName = entryModel.name.replaceAll(RegExp(r'\s*:\s*'), ' - ').trim();
    String accountName = entryName.isEmpty ? 'Entry' : entryName;

    return Uri(
      scheme: 'otpauth',
      host: 'totp',
      pathSegments: <String>['$issuer:$accountName'],
      queryParameters: <String, String>{'secret': totpSecret, 'issuer': issuer},
    );
  }

  Future<Uri?> getTotpExportUri() async {
    EntryModel? entryModel = _entryModel;
    bool exportUnavailableBool = entryModel == null || state.totpExistsBool == false;
    if (exportUnavailableBool) {
      return null;
    }

    EntrySecretsModel entrySecretsModel;
    try {
      PasswordModel passwordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);
      entrySecretsModel = await _secretsService.get(entryModel.filesystemPath, passwordModel);
    } catch (_) {
      return null;
    }

    Uri? totpExportUri = _generateTotpExportUri(entryModel, entrySecretsModel);

    return totpExportUri;
  }
}
