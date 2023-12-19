import 'package:snggle/shared/utils/crypto/address/cosmos_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/address/ethereum_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/address/p2pkh_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip_proposal_type.dart';
import 'package:snggle/shared/utils/crypto/bip/coins_config/coin_config.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve_type.dart';
import 'package:snggle/shared/utils/crypto/slip/slip173.dart';
import 'package:snggle/shared/utils/crypto/slip/slip44.dart';

class Bip44CoinsConfig {
  static CoinConfig bitcoin = CoinConfig(
    purpose: BipProposalType.bip44,
    coinIndex: Slip44.bitcoin,
    ecCurveType: ECCurveType.secp256k1,
    addressEncoder: P2PKHAddressEncoder(),
  );

  static CoinConfig cosmos = CoinConfig(
    purpose: BipProposalType.bip44,
    coinIndex: Slip44.cosmos,
    ecCurveType: ECCurveType.secp256k1,
    addressEncoder: CosmosAddressEncoder(hrp: Slip173.cosmos),
  );

  static CoinConfig ethereum = CoinConfig(
    purpose: BipProposalType.bip44,
    coinIndex: Slip44.ethereum,
    ecCurveType: ECCurveType.secp256k1,
    addressEncoder: EthereumAddressEncoder(),
  );

  static CoinConfig kira = CoinConfig(
    purpose: BipProposalType.bip44,
    coinIndex: Slip44.kex,
    ecCurveType: ECCurveType.secp256k1,
    addressEncoder: CosmosAddressEncoder(hrp: Slip173.kira),
  );

}
