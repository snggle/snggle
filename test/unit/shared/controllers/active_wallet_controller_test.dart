import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  ActiveWalletController activeWalletController = ActiveWalletController();

  group('Tests of ActiveWalletController.setActiveWallet()', () {
    test('Should [set WalletModel] in ActiveWalletController', () {
      // Arrange
      WalletModel walletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      // Act
      activeWalletController.setActiveWallet(walletModel: walletModel);

      // Assert
      expect(activeWalletController.walletModel, walletModel);
      expect(activeWalletController.hasActiveWallet, true);
    });
  });

  group('Tests of ActiveWalletController.clearActiveWallet()', () {
    test('Should [clear WalletModel] in ActiveWalletController', () {
      // Act
      activeWalletController.clearActiveWallet();

      // Assert
      expect(activeWalletController.walletModel, null);
      expect(activeWalletController.hasActiveWallet, false);
    });
  });
}
