import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_totp_page/scan_totp_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/totp_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class ScanTotpQRPageCubit extends Cubit<ScanTotpQRPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordController _passwordController = globalLocator<PasswordController>();

  final EntryModel? _entryModel;
  final ValueNotifier<double> progressNotifier;
  final VoidCallback _unsupportedOperationCallback;
  final VoidCallback _onFinished;
  final Future<void> Function(TotpConfig config)? _onTotpScanned;

  EntrySecretsModel? _entrySecretsModel;

  ScanTotpQRPageCubit({
    required void Function() unsupportedOperationCallback,
    required void Function() onFinished,
    required EntryModel? entryModel,
    Future<void> Function(TotpConfig config)? onTotpScanned,
  })  : _unsupportedOperationCallback = unsupportedOperationCallback,
        _onFinished = onFinished,
        _entryModel = entryModel,
        _onTotpScanned = onTotpScanned,
        progressNotifier = ValueNotifier<double>(0),
        super(const ScanTotpQRPageState());

  void processQR(String data) {
    if (state.canReceiveQRCode() == false) {
      return;
    }

    try {
      TotpConfig config = TotpConfig.fromInput(data);
      _finishScanning(config);
    } catch (e) {
      AppLogger().log(message: 'Camera received a QR code that could not be processed', logLevel: LogLevel.warning);
    }
  }

  void reset() {
    progressNotifier.value = 0;

    emit(const ScanTotpQRPageState());
  }

  Future<void> _finishScanning(TotpConfig totpConfig) async {
    try {
      emit(const ScanTotpQRPageState(processingQRBool: true));

      if (_entryModel == null) {
        await _onTotpScanned?.call(totpConfig);
        _onFinished();
        return;
      }

      EntryModel entryModel = _entryModel;

      PasswordModel entryPasswordModel = await _passwordController.getPasswordByFilesystemPath(entryModel.filesystemPath);

      EntrySecretsModel currentSecrets;
      try {
        currentSecrets = _entrySecretsModel ?? await _secretsService.get(entryModel.filesystemPath, entryPasswordModel);
      } catch (_) {
        currentSecrets = EntrySecretsModel(
          filesystemPath: entryModel.filesystemPath,
        );
      }

      Map<String, dynamic> json = currentSecrets.toJson()..['totpConfig'] = totpConfig.toJson();

      EntrySecretsModel updatedSecrets = EntrySecretsModel.fromJson(entryModel.filesystemPath, json);

      await _secretsService.save(updatedSecrets, entryPasswordModel);

      _onFinished();
    } catch (_) {
      _unsupportedOperationCallback();
    }
  }
}
