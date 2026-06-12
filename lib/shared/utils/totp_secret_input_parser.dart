import 'package:snggle/shared/exceptions/read_totp_data_exception.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';

class TotpSecretInputParser {
  static const String _supportedScheme = 'otpauth';
  static const String _supportedHost = 'totp';
  static const String _supportedAlgorithm = 'sha1';
  static const String _supportedDigits = '6';
  static const String _supportedPeriod = '30';

  static String fromInput(String input, {bool inputFromQrBool = false}) {
    String trimmedInput = input.trim();

    if (inputFromQrBool == true) {
      Uri? uri = Uri.tryParse(trimmedInput);
      if (uri == null || uri.scheme != _supportedScheme) {
        throw const ReadTotpDataException(ReadTotpDataExceptionType.unsupported);
      }

      if (uri.host.toLowerCase() != _supportedHost) {
        throw const ReadTotpDataException(ReadTotpDataExceptionType.unsupported);
      }

      Map<String, String> qrParameters = uri.queryParameters;
      _validateSupportedTotpConfiguration(qrParameters);

      String secret = _normalizeSecret(_getParameter(qrParameters, 'secret') ?? '');
      if (secret.isEmpty) {
        throw const ReadTotpDataException(ReadTotpDataExceptionType.secretNotFound);
      }

      return secret;
    }

    return _normalizeSecret(trimmedInput);
  }

  static void _validateSupportedTotpConfiguration(Map<String, String> qrParameters) {
    String? algorithm = _getParameter(qrParameters, 'algorithm');
    if (algorithm != null && algorithm.toLowerCase() != _supportedAlgorithm) {
      throw const ReadTotpDataException(ReadTotpDataExceptionType.unsupportedTotpConfiguration);
    }

    String? digits = _getParameter(qrParameters, 'digits');
    if (digits != null && digits != _supportedDigits) {
      throw const ReadTotpDataException(ReadTotpDataExceptionType.unsupportedTotpConfiguration);
    }

    String? period = _getParameter(qrParameters, 'period');
    if (period != null && period != _supportedPeriod) {
      throw const ReadTotpDataException(ReadTotpDataExceptionType.unsupportedTotpConfiguration);
    }
  }

  static String? _getParameter(Map<String, String> qrParameters, String key) {
    for (MapEntry<String, String> entry in qrParameters.entries) {
      if (entry.key.toLowerCase() == key) {
        return entry.value;
      }
    }

    return null;
  }

  static String _normalizeSecret(String string) {
    return string.replaceAll(RegExp(r'\s+'), '').toLowerCase();
  }
}
