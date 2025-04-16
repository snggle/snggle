import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/a_derivation_path_index_extractor.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_types.dart';

class EthereumDerivationPathIndexExtractor extends ADerivationPathIndexExtractor {
  @override
  DerivationPathType get derivationPathType => DerivationPathType.ethereum;

  @override
  String serializeType() => 'ethereum';

  @override
  int extractIndex(String derivationPath) {
    List<String> parts = derivationPath.split('/');
    return int.parse(parts.last);
  }
}
