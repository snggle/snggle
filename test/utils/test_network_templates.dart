import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

class TestNetworkTemplates {
  static NetworkTemplateModel ethereum = NetworkTemplateModel(
    name: 'Ethereum',
    networkIconType: NetworkIconType.ethereum,
    derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    addressEncoder: EthereumAddressEncoder(),
    derivator: Secp256k1Derivator(),
    curveType: CurveType.secp256k1,
    walletType: WalletType.legacy,
    predefinedNetworkTemplateId: 817800260,
  );
}
