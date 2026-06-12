class TwoFactorOptionsType {
  final String totpSecret;
  final bool manualSecretInputBool;

  const TwoFactorOptionsType.manualSecretInput()
      : totpSecret = '',
        manualSecretInputBool = true;

  const TwoFactorOptionsType.scanQrCode(this.totpSecret) : manualSecretInputBool = false;
}
