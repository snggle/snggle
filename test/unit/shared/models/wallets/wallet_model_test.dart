import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  group('Tests of WalletModel.name getter', () {
    test('Should [return wallet name]', () {
      // Arrange
      WalletModel actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'TEST',
      );

      // Act
      String actualName = actualWalletModel.name;

      // Assert
      String expectedName = 'TEST';

      expect(actualName, expectedName);
    });
  });

  group('Tests of WalletModel.getShortAddress()', () {
    test('Should [return short wallet address] with the given number of significant characters', () {
      // Arrange
      WalletModel actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      // Act
      String actualName = actualWalletModel.getShortAddress(3);

      // Assert
      String expectedName = '0x4BD...Dce';

      expect(actualName, expectedName);
    });
  });
}
