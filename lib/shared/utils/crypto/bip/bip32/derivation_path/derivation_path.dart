import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path_element.dart';

class DerivationPath extends Equatable {
  static const String _masterChar = 'm';

  final List<DerivationPathElement> elements;

  DerivationPath({List<DerivationPathElement>? elements}) : elements = elements ?? List<DerivationPathElement>.empty(growable: true);

  factory DerivationPath.parse(String derivationPath) {
    String parsedDerivationPath = derivationPath;
    if (parsedDerivationPath.endsWith('/')) {
      parsedDerivationPath = parsedDerivationPath.substring(0, parsedDerivationPath.length - 1);
    }

    List<String> pathElements = parsedDerivationPath.split('/').where((String elem) => elem.isNotEmpty).toList();
    if (pathElements.isEmpty || pathElements.first != _masterChar) {
      throw FormatException('Invalid BIP32 derivation path ($derivationPath)');
    }

    List<DerivationPathElement> parsedElements = pathElements.sublist(1).map(DerivationPathElement.parse).toList();
    return DerivationPath(elements: parsedElements);
  }

  @override
  String toString() {
    List<String> pathElementsStrings = <String>[_masterChar, ...elements.map((DerivationPathElement elem) => elem.toString())];
    return pathElementsStrings.join('/');
  }

  @override
  List<Object?> get props => <Object?>[elements];
}