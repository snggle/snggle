import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class TotpController {
  final TextEditingController totpCodeTextEditingController = TextEditingController();

  Timer? _timer;

  void dispose() {
    _timer?.cancel();
    totpCodeTextEditingController.dispose();
  }

  void start({required String totpSecret, required void Function(int? remainingSeconds) onUpdate, DateTime? timestamp}) {
    _timer?.cancel();
    _timer = null;

    int? remainingSeconds = _refreshCode(totpSecret, timestamp ?? DateTime.now());
    bool codeAvailableBool = remainingSeconds != null;
    if (codeAvailableBool) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        int? remainingSeconds = _refreshCode(totpSecret, timestamp ?? DateTime.now());
        bool codeUnavailableBool = remainingSeconds == null;
        if (codeUnavailableBool) {
          timer.cancel();
          _timer = null;
        }
        onUpdate(remainingSeconds);
      });
    }
    onUpdate(remainingSeconds);
  }

  String _formatTotpCode(String totpCode) {
    return '${totpCode.substring(0, 3)} ${totpCode.substring(3)}';
  }

  String _generateCode(String totpSecret, DateTime timestamp) {
    bool secretEmptyBool = totpSecret.isEmpty;
    if (secretEmptyBool) {
      return '';
    }

    try {
      return _formatTotpCode(TOTP.generate(totpSecret, timestamp: timestamp));
    } catch (exception) {
      AppLogger().log(message: exception.toString());
      return '';
    }
  }

  int _getRemainingSeconds(DateTime timestamp) {
    int elapsedSeconds = timestamp.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    return 30 - elapsedSeconds % 30;
  }

  int? _refreshCode(String totpSecret, DateTime timestamp) {
    String totpCode = _generateCode(totpSecret, timestamp);
    bool codeChangedBool = totpCodeTextEditingController.text != totpCode;
    if (codeChangedBool) {
      totpCodeTextEditingController.text = totpCode;
    }

    return totpCode.isEmpty ? null : _getRemainingSeconds(timestamp);
  }
}
