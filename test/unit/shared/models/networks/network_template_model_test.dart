import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

void main() {
  group('Tests of NetworkTemplateModel.id getter', () {
    test('Should [return ID] of specified NetworkTemplateModel', () {
      // Arrange
      NetworkTemplateModel actualNetworkTemplateModel = NetworkTemplateModel(
        name: 'Ethereum',
        networkIconType: NetworkIconType.ethereum,
        derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );

      // Act
      int actualId = actualNetworkTemplateModel.id;

      // Assert
      int expectedId = 817800260;

      expect(actualId, expectedId);
    });
  });

  group('Tests of NetworkTemplateModel.deriveWallet()', () {
    test('Should [return AHDWallet] derived from specified Mnemonic and derivation path', () async {
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

      Mnemonic actualMnemonic = Mnemonic.fromMnemonicPhrase('carry pave input birth pole vague elephant moment either science food donkey');
      String derivationPath = "m/44'/60'/0'/0/0";

      // Act
      AHDWallet actualHDWallet = await actualNetworkTemplateModel.deriveWallet(actualMnemonic, derivationPath);

      // Assert
      Bip32KeyMetadata expectedBip32KeyMetadata = Bip32KeyMetadata(
          depth: 5,
          chainCode: base64Decode('VLeAYwfBCC9ru0eZoNFFQmseJnGXmznAxZCzoXd+kmY='),
          fingerprint: BigInt.parse('3348545310'),
          parentFingerprint: BigInt.parse('2382068266'),
          masterFingerprint: BigInt.parse('4271868422'),
          shiftedIndex: 0);

      AHDWallet expectedHDWallet = LegacyHDWallet(
        address: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        walletConfig: LegacyWalletConfig<ABip32PrivateKey>(
          addressEncoder: EthereumAddressEncoder(),
          derivator: Secp256k1Derivator(),
          curveType: CurveType.secp256k1,
        ),
        privateKey: Secp256k1PrivateKey.fromBytes(base64Decode('I7S5jRH/GJjsK5uQAS+BVCcZgU3ytjjH1P+zPzjtRS4='), metadata: expectedBip32KeyMetadata),
        publicKey: Secp256k1PublicKey.fromCompressedBytes(base64Decode('AlsnWtgkUnraj3YGBmwpOnNV8rh94AISDgIbpjYAjAOK'), metadata: expectedBip32KeyMetadata),
        derivationPath: LegacyDerivationPath.parse("m/44'/60'/0'/0/0"),
      );

      expect(actualHDWallet, expectedHDWallet);
    });
  });

  group('Tests of NetworkTemplateModel.getCustomizableDerivationPath()', () {
    test('Should [return customizable derivation path] if [variables EXIST]', () {
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
      String actualDerivationPath = actualNetworkTemplateModel.getCustomizableDerivationPath(accountIndex: 1, changeIndex: 2, addressIndex: 3);

      // Assert
      String expectedDerivationPath = '2/3';

      expect(actualDerivationPath, expectedDerivationPath);
    });

    test('Should [return customizable derivation path] with added "address" section if [variables NOT EXIST]', () {
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
      String actualDerivationPath = actualNetworkTemplateModel.getCustomizableDerivationPath(accountIndex: 1, changeIndex: 2, addressIndex: 3);

      // Assert
      String expectedDerivationPath = '3';

      expect(actualDerivationPath, expectedDerivationPath);
    });
  });

  group('Tests of NetworkTemplateModel.mergeCustomDerivationPath()', () {
    test('Should [return derivation path] combined from base and customizable parts', () {
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
      String actualDerivationPath = actualNetworkTemplateModel.mergeCustomDerivationPath('0/1');

      // Assert
      String expectedDerivationPath = "m/44'/60'/0'/0/1";

      expect(actualDerivationPath, expectedDerivationPath);
    });

    test('Should [return derivation path] combined from base and customizable parts (customizable part starts with /)', () {
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
      String actualDerivationPath = actualNetworkTemplateModel.mergeCustomDerivationPath('/0/1');

      // Assert
      String expectedDerivationPath = "m/44'/60'/0'/0/1";

      expect(actualDerivationPath, expectedDerivationPath);
    });

    test('Should [return derivation path] combined from base and customizable parts (customizable part ends with /)', () {
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
      String actualDerivationPath = actualNetworkTemplateModel.mergeCustomDerivationPath('0/1/');

      // Assert
      String expectedDerivationPath = "m/44'/60'/0'/0/1";

      expect(actualDerivationPath, expectedDerivationPath);
    });

    test('Should [return derivation path] combined from base and customizable parts (customizable part empty)', () {
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
      String actualDerivationPath = actualNetworkTemplateModel.mergeCustomDerivationPath('');

      // Assert
      String expectedDerivationPath = "m/44'/60'/0'";

      expect(actualDerivationPath, expectedDerivationPath);
    });
  });

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
