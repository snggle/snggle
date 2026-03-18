import 'package:snggle/shared/exceptions/read_tx_data_exception_type.dart';

class ReadTxDataExceptionMsgs {
  static String getTitle(ReadTxDataExceptionType type) => switch (type) {
        ReadTxDataExceptionType.unsupported => 'Unsupported Transaction',
        ReadTxDataExceptionType.receivedAddressEmpty => 'Missing Sender Address',
        ReadTxDataExceptionType.vaultNotFound => 'Vault Not Found',
        ReadTxDataExceptionType.walletNotFound => 'Wallet Not Found',
        ReadTxDataExceptionType.walletWithEncryptedParents => 'Secured Wallet',
      };

  static String getDescriptionForQR(ReadTxDataExceptionType type) => switch (type) {
        ReadTxDataExceptionType.unsupported =>
          'The scanned QR code is not supported by the application. Please ensure you are using a valid QR code.',
        ReadTxDataExceptionType.receivedAddressEmpty =>
          'Cannot determine the sender wallet from the scanned QR code. You can select the wallet manually by opening it and using "Sign transaction" button.',
        ReadTxDataExceptionType.vaultNotFound =>
          'The sender wallet belongs to a Vault that does not exist in the application. Make sure the vault you want to use is imported to Snggle.',
        ReadTxDataExceptionType.walletNotFound =>
          'The sender wallet does not exist in the application. Make sure the wallet you want to use is imported to Snggle.',
        ReadTxDataExceptionType.walletWithEncryptedParents =>
          "The sender wallet is in the password protected path. Please unlock the protected elements on the wallet's path to continue.",
      };

  static String getDescriptionForAudio(ReadTxDataExceptionType type) => switch (type) {
        ReadTxDataExceptionType.unsupported => 'The recorded audio is not supported by the application. Please ensure you are using a valid audio.',
        ReadTxDataExceptionType.receivedAddressEmpty =>
          'Cannot determine the sender wallet from the recorded audio. You can select the wallet manually by opening it and using "Sign transaction" button.',
        ReadTxDataExceptionType.vaultNotFound =>
          'The sender wallet belongs to a Vault that does not exist in the application. Make sure the vault you want to use is imported to Snggle.',
        ReadTxDataExceptionType.walletNotFound =>
          'The sender wallet does not exist in the application. Make sure the wallet you want to use is imported to Snggle.',
        ReadTxDataExceptionType.walletWithEncryptedParents =>
          "The sender wallet is in the password protected path. Please unlock the protected elements on the wallet's path to continue.",
      };
}
