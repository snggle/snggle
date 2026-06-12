import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';

class ReadTotpDataExceptionMsgs {
  static String getTitle(ReadTotpDataExceptionType type) => switch (type) {
        ReadTotpDataExceptionType.unsupported => 'Unsupported QR Code',
        ReadTotpDataExceptionType.unsupportedTotpConfiguration => 'Unsupported TOTP Config',
        ReadTotpDataExceptionType.secretNotFound => 'Missing TOTP Secret',
      };

  static String getDescriptionForQR(ReadTotpDataExceptionType type) => switch (type) {
        ReadTotpDataExceptionType.unsupported =>
          'The scanned QR code does not contain the TOTP secret configuration. Please ensure you are using a valid QR code or enter the TOTP secret manually.',
        ReadTotpDataExceptionType.unsupportedTotpConfiguration => 'The scanned QR code contains unsupported configuration of TOTP parameters.',
        ReadTotpDataExceptionType.secretNotFound =>
          'The scanned QR code does not contains a TOTP Secret. Please ensure you are using a valid QR code or enter the TOTP secret manually.',
      };
}
