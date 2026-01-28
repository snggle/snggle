import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';

class ScanQrExceptionMsgs {
  static String getTitle(ScanQrExceptionType type) => switch (type) {
        ScanQrExceptionType.unsupported => 'Unsupported QR Code',
        ScanQrExceptionType.receivedAddressEmpty => 'Missing Sender Address',
        ScanQrExceptionType.vaultNotFound => 'Vault Not Found',
        ScanQrExceptionType.walletNotFound => 'Wallet Not Found',
        ScanQrExceptionType.walletWithEncryptedParents => 'Secured Wallet',
      };

  static String getDescription(ScanQrExceptionType type) => switch (type) {
        ScanQrExceptionType.unsupported => 'The scanned QR code is not supported by the application. Please ensure you are using a valid QR code.',
        ScanQrExceptionType.receivedAddressEmpty =>
          'Cannot determine the sender wallet from the scanned QR code. You can select the wallet manually by opening it and using "Sign transaction" button.',
        ScanQrExceptionType.vaultNotFound =>
          'The sender wallet belongs to a Vault that does not exist in the application. Make sure the vault you want to use is imported to Snggle.',
        ScanQrExceptionType.walletNotFound =>
          'The sender wallet does not exist in the application. Make sure the wallet you want to use is imported to Snggle.',
        ScanQrExceptionType.walletWithEncryptedParents =>
          "The sender wallet is in the password protected path. Please unlock the protected elements on the wallet's path to continue.",
      };
}
