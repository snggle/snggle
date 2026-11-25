import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/two_factor_options_page/two_factor_options_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/totp_secret_input_parser.dart';

class TwoFactorOptionsPageCubit extends Cubit<TwoFactorOptionsPageState> {
  final EntryModel? _entryModel;
  final PasswordController _passwordController = globalLocator<PasswordController>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  TwoFactorOptionsPageCubit({required EntryModel? entryModel})
    : _entryModel = entryModel,
      super(TwoFactorOptionsPageState(totpExportAvailableBool: entryModel?.totpExistsBool ?? false));

  Future<Uri?> getTotpExportUri() async {
    EntryModel? entryModel = _entryModel;
    bool exportUnavailableBool = entryModel == null || state.totpExportAvailableBool == false;
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
    bool secretUnavailableBool = totpExportUri != null;
    if (secretUnavailableBool) {
      emit(const TwoFactorOptionsPageState(totpExportAvailableBool: false));
    }

    return totpExportUri;
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
}
