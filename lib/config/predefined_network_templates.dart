import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/ethereum_derivation_path_index_extractor.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/solana_4elements_derivation_path_index_extractor.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

class PredefinedNetworkTemplates {
  static List<NetworkTemplateModel> values = <NetworkTemplateModel>[ethereum, solana];

  static NetworkTemplateModel ethereum = NetworkTemplateModel(
    name: 'Ethereum',
    networkIconType: NetworkIconType.ethereum,
    derivationPathTemplate: "m/44'/60'/0'/0/{{i}}",
    derivationPathIndexExtractor: EthereumDerivationPathIndexExtractor(),
    addressEncoder: EthereumAddressEncoder(),
    derivator: Secp256k1Derivator(),
    curveType: CurveType.secp256k1,
    walletType: WalletType.legacy,
  );

  static NetworkTemplateModel solana = NetworkTemplateModel(
    name: 'Solana',
    networkIconType: NetworkIconType.cosmos,
    derivationPathTemplate: "m/44'/501'/{{i}}'/0'",
    derivationPathIndexExtractor: Solana4ElementsDerivationPathIndexExtractor(),
    addressEncoder: SolanaAddressEncoder(),
    derivator: ED25519Derivator(),
    curveType: CurveType.ed25519,
    walletType: WalletType.legacy,
  );
}
