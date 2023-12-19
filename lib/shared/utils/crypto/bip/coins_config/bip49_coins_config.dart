import 'package:snggle/shared/utils/crypto/address/p2sh_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip_proposal_type.dart';
import 'package:snggle/shared/utils/crypto/bip/coins_config/coin_config.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve_type.dart';
import 'package:snggle/shared/utils/crypto/slip/slip44.dart';

class Bip49CoinsConfig {
  static CoinConfig bitcoin = CoinConfig(
    purpose: BipProposalType.bip49,
    coinIndex: Slip44.bitcoin,
    ecCurveType: ECCurveType.secp256k1,
    addressEncoder: P2SHAddressEncoder(),
  );
}
