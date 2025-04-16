import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/a_derivation_path_index_extractor.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_types.dart';

class Solana4ElementsDerivationPathIndexExtractor extends ADerivationPathIndexExtractor {
  @override
  DerivationPathType get derivationPathType => DerivationPathType.solana_4elements;

  @override
  String serializeType() => 'solana';

  @override
  int extractIndex(String derivationPath) {
    List<String> parts = derivationPath.split('/');
    String indexPart = parts[parts.length - 2];
    return int.parse(indexPart.replaceAll("'", ''));
  }
}
