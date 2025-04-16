import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_last_index_extractor.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_second_last_index_extractor.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/networks/network_type.dart';

class PredefinedNetworkTemplates {
  static List<NetworkTemplateModel> values = <NetworkTemplateModel>[ethereum, solana];

  static NetworkTemplateModel ethereum = NetworkTemplateModel(
    name: 'Ethereum',
    networkIconType: NetworkIconType.ethereum,
    networkType: NetworkType.ethereum,
    derivationPathTemplate: "m/44'/60'/0'/0/{{i}}",
    addressEncoder: EthereumAddressEncoder(),
    derivator: Secp256k1Derivator(),
    curveType: CurveType.secp256k1,
    walletType: WalletType.legacy,
  );

  static NetworkTemplateModel solana = NetworkTemplateModel(
    name: 'Solana',
    networkIconType: NetworkIconType.solana,
    networkType: NetworkType.solana,
    derivationPathTemplate: "m/44'/501'/{{i}}'/0'",
    addressEncoder: SolanaAddressEncoder(),
    derivator: ED25519Derivator(),
    curveType: CurveType.ed25519,
    walletType: WalletType.legacy,
  );
}
