import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/crypto/address/i_blockchain_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip_proposal_type.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve_type.dart';

class CoinConfig extends Equatable {
  final int coinIndex;
  final BipProposalType purpose;
  final ECCurveType ecCurveType;
  final IBlockchainAddressEncoder<dynamic> addressEncoder;

  const CoinConfig({
    required this.coinIndex,
    required this.purpose,
    required this.ecCurveType,
    required this.addressEncoder,
  });

  String get baseDerivationPath => "m/${purpose.proposalNumber}'/$coinIndex'";

  @override
  List<Object?> get props => <Object>[coinIndex, purpose, ecCurveType, addressEncoder];
}
