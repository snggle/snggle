import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_last_index_extractor.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_second_last_index_extractor.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_types.dart';

/// The [ADerivationPathIndexExtractor] class is designed for extracting indexes from derivation paths according to the specific blockchain network.
abstract class ADerivationPathIndexExtractor {
  static ADerivationPathIndexExtractor fromSerializedType(String type) {
    DerivationPathType parserType = DerivationPathType.values.byName(type);

    return switch (parserType) {
      DerivationPathType.lastDynamic => DerivationPathLastIndexExtractor(),
      DerivationPathType.secondLastDynamic => DerivationPathSecondLastIndexExtractor(),
    };
  }

  DerivationPathType get derivationPathType;

  String serializeType();

  int extractIndex(String derivationPath);
}
