import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

void main() {
  group('Tests of NetworkTemplateModel.baseDerivationPath getter', () {
    test('Should [return String] representing static part of derivation path (when derivation path template CONTAINS dynamic elements)', () {
      // Arrange
      NetworkTemplateModel actualNetworkTemplateModel = NetworkTemplateModel(
        name: 'Ethereum1',
        networkIconType: NetworkIconType.ethereum,
        derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );

      // Act
      String actualBaseDerivationPath = actualNetworkTemplateModel.baseDerivationPath;

      // Assert
      String expectedBaseDerivationPath = "m/44'/60'/0'";

      expect(actualBaseDerivationPath, expectedBaseDerivationPath);
    });

    test('Should [return String] representing static part of derivation path (when derivation path template NOT CONTAINS dynamic elements)', () {
      // Arrange
      NetworkTemplateModel actualNetworkTemplateModel = NetworkTemplateModel(
        name: 'Ethereum1',
        networkIconType: NetworkIconType.ethereum,
        derivationPathTemplate: "m/44'/60'/0'",
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );

      // Act
      String actualBaseDerivationPath = actualNetworkTemplateModel.baseDerivationPath;

      // Assert
      String expectedBaseDerivationPath = "m/44'/60'/0'";

      expect(actualBaseDerivationPath, expectedBaseDerivationPath);
    });

    test('Should [return String] representing static part of derivation path (when derivation path template EMPTY)', () {
      // Arrange
      NetworkTemplateModel actualNetworkTemplateModel = NetworkTemplateModel(
        name: 'Ethereum1',
        networkIconType: NetworkIconType.ethereum,
        derivationPathTemplate: 'm',
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );

      // Act
      String actualBaseDerivationPath = actualNetworkTemplateModel.baseDerivationPath;

      // Assert
      String expectedBaseDerivationPath = 'm';

      expect(actualBaseDerivationPath, expectedBaseDerivationPath);
    });
  });
}
