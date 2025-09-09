import 'package:snggle/shared/models/networks/network_template_model.dart';

/// The [DerivationPathIndexExtractor] class is designed for extracting indexes from derivation paths according to the specific blockchain network.
class DerivationPathIndexExtractor {
  final String derivationPathTemplate;

  DerivationPathIndexExtractor({required this.derivationPathTemplate});

  DerivationPathIndexExtractor.fromNetworkTemplateModel(NetworkTemplateModel networkTemplateModel)
      : derivationPathTemplate = networkTemplateModel.derivationPathTemplate;

  int extractIndex(String derivationPath) {
    List<String> templateSegments = derivationPathTemplate.split('/');
    List<String> pathSegments = derivationPath.split('/');

    int incrementalIndex = templateSegments.indexWhere((String segment) => segment == '{{i}}' || segment == "{{i}}'");
    if (incrementalIndex == -1 || incrementalIndex >= pathSegments.length) {
      throw const FormatException('Invalid derivation path format');
    }

    String indexSegment = pathSegments[incrementalIndex];
    return int.parse(indexSegment.replaceAll("'", ''));
  }
}
