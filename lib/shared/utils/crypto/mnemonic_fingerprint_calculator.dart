import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/predefined_network_templates.dart';

class MnemonicFingerprintCalculator {
  static Future<String> calc(Mnemonic mnemonic) async {

    String ethParentDerivationPath = "m/44'/60'/0'";
    AHDWallet parentHDWallet = await PredefinedNetworkTemplates.ethereum.deriveWallet(mnemonic, ethParentDerivationPath);
    return parentHDWallet.privateKey.metadata.fingerprint.toString();
  }
}
