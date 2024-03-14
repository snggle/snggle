import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

void main() {
  group('Tests of VaultSelectionModel.canPinAll getter', () {
    test('Should [return TRUE] if [all items UNPINNED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: false, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canPinAll, true);
    });

    test('Should [return TRUE] if [at least one item UNPINNED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: true, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: true, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: false, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canPinAll, true);
    });

    test('Should [return FALSE] if [all items PINNED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: true, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: true, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canPinAll, false);
    });

    test('Should [return FALSE] if [selection EMPTY]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[]);

      // Assert
      expect(actualVaultSelectionModel.canPinAll, false);
    });
  });

  group('Tests of VaultSelectionModel.canUnpinAll getter', () {
    test('Should [return TRUE] if [all items PINNED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: true, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: true, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canUnpinAll, true);
    });

    test('Should [return TRUE] if [at least one item PINNED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canUnpinAll, true);
    });

    test('Should [return FALSE] if [all items UNPINNED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: false, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canUnpinAll, false);
    });

    test('Should [return FALSE] if [selection EMPTY]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[]);

      // Assert
      expect(actualVaultSelectionModel.canUnpinAll, false);
    });
  });

  group('Tests of VaultSelectionModel.canLockAll getter', () {
    test('Should [return TRUE] if [all items UNLOCKED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: true, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: true, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canLockAll, true);
    });

    test('Should [return FALSE] if [at least one item LOCKED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canLockAll, false);
    });

    test('Should [return FALSE] if [all items LOCKED]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: false, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ]);

      // Assert
      expect(actualVaultSelectionModel.canLockAll, false);
    });

    test('Should [return FALSE] if [selection EMPTY]', () {
      // Arrange
      VaultSelectionModel actualVaultSelectionModel = VaultSelectionModel(<VaultListItemModel>[]);

      // Assert
      expect(actualVaultSelectionModel.canLockAll, false);
    });
  });
}
