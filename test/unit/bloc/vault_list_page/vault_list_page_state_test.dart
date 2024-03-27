import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_state.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

void main() {
  List<VaultListItemModel> actualVaultListItemModels = <VaultListItemModel>[
    VaultListItemModel(
      encryptedBool: true,
      vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
      vaultWallets: const <WalletModel>[],
    ),
    VaultListItemModel(
      encryptedBool: false,
      vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
      vaultWallets: const <WalletModel>[],
    ),
    VaultListItemModel(
      encryptedBool: false,
      vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
      vaultWallets: const <WalletModel>[],
    ),
  ];

  group('Tests of VaultListPageState constructor', () {
    test('Should [return SORTED list] where [pinned vaults FIRST]', () {
      // Act
      VaultListPageState vaultListPageState = VaultListPageState(loadingBool: false, allVaults: actualVaultListItemModels);

      // Assert
      List<VaultListItemModel> expectedVaultListItemModels = <VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
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
      ];

      expect(vaultListPageState.allVaults, expectedVaultListItemModels);
    });
  });

  group('Tests of VaultListPageState.isSelectingEnabled getter', () {
    test('Should [return TRUE] if [VaultSelectionModel EXISTS]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: false,
        allVaults: actualVaultListItemModels,
        selectionModel: VaultSelectionModel(<VaultListItemModel>[]),
      );

      // Assert
      expect(actualVaultListPageState.isSelectingEnabled, true);
    });

    test('Should [return FALSE] if [VaultSelectionModel NOT EXISTS]', () {
      // Arrange
      VaultListPageState vaultListPageState = VaultListPageState(loadingBool: false, allVaults: actualVaultListItemModels);

      // Assert
      expect(vaultListPageState.isSelectingEnabled, false);
    });
  });

  group('Tests of VaultListPageState.isScrollDisabled getter', () {
    test('Should [return TRUE] if [loadingBool == TRUE]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: true,
        allVaults: actualVaultListItemModels,
      );

      // Assert
      expect(actualVaultListPageState.isScrollDisabled, true);
    });

    test('Should [return TRUE] if [loadingBool == FALSE] and [vaults EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(loadingBool: false, allVaults: const <VaultListItemModel>[]);

      // Assert
      expect(actualVaultListPageState.isScrollDisabled, true);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [vaults NOT EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(loadingBool: false, allVaults: actualVaultListItemModels);

      // Assert
      expect(actualVaultListPageState.isScrollDisabled, false);
    });
  });

  group('Tests of VaultListPageState.hasEmptyVaults getter', () {
    test('Should [return TRUE] if [loadingBool == FALSE] and [vaults EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(loadingBool: false, allVaults: const <VaultListItemModel>[]);

      // Assert
      expect(actualVaultListPageState.hasEmptyVaults, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE] and [vaults EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: true,
        allVaults: const <VaultListItemModel>[],
      );

      // Assert
      expect(actualVaultListPageState.hasEmptyVaults, false);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [vaults NOT EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(loadingBool: false, allVaults: actualVaultListItemModels);

      // Assert
      expect(actualVaultListPageState.isScrollDisabled, false);
    });
  });

  group('Tests of VaultListPageState.selectedVaults getter', () {
    test('Should [return selected vaults] if [VaultSelectionModel EXISTS] and [selected vaults NOT EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: false,
        allVaults: actualVaultListItemModels,
        selectionModel: VaultSelectionModel(actualVaultListItemModels),
      );

      // Act
      List<VaultListItemModel> actualSelectedVaults = actualVaultListPageState.selectedItems;

      // Assert
      List<VaultListItemModel> expectedSelectedVaults = <VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 0, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: false, name: 'Test Vault 1'),
          vaultWallets: const <WalletModel>[],
        ),
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
      ];

      expect(actualSelectedVaults, expectedSelectedVaults);
    });

    test('Should [return EMPTY list] if [VaultSelectionModel EXISTS] but [selected vaults EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: false,
        allVaults: actualVaultListItemModels,
        selectionModel: VaultSelectionModel(<VaultListItemModel>[]),
      );

      // Act
      List<VaultListItemModel> actualSelectedVaults = actualVaultListPageState.selectedItems;

      // Assert
      List<VaultListItemModel> expectedSelectedVaults = <VaultListItemModel>[];

      expect(actualSelectedVaults, expectedSelectedVaults);
    });

    test('Should [return EMPTY list] if [VaultSelectionModel NOT EXISTS]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(loadingBool: false, allVaults: actualVaultListItemModels);

      // Act
      List<VaultListItemModel> actualSelectedVaults = actualVaultListPageState.selectedItems;

      // Assert
      List<VaultListItemModel> expectedSelectedVaults = <VaultListItemModel>[];

      expect(actualSelectedVaults, expectedSelectedVaults);
    });
  });

  group('Tests of VaultListPageState.visibleVaults getter', () {
    test('Should [return vaults] where [name CONTAINS searchPattern]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: false,
        allVaults: actualVaultListItemModels,
        searchPattern: 'Test Vault 2',
      );

      // Act
      List<VaultListItemModel> actualVisibleVaults = actualVaultListPageState.visibleVaults;

      // Assert
      List<VaultListItemModel> expectedVisibleVaults = <VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
      ];

      expect(actualVisibleVaults, expectedVisibleVaults);
    });

    test('Should [return vaults] where [name CONTAINS searchPattern] (case insensitive)', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: false,
        allVaults: actualVaultListItemModels,
        searchPattern: 'test vault 2',
      );

      // Act
      List<VaultListItemModel> actualVisibleVaults = actualVaultListPageState.visibleVaults;

      // Assert
      List<VaultListItemModel> expectedVisibleVaults = <VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: true,
          vaultModel: VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
          vaultWallets: const <WalletModel>[],
        ),
      ];

      expect(actualVisibleVaults, expectedVisibleVaults);
    });

    test('Should [return all vaults] if [searchPattern EMPTY]', () {
      // Arrange
      VaultListPageState actualVaultListPageState = VaultListPageState(
        loadingBool: false,
        allVaults: actualVaultListItemModels,
        searchPattern: '',
      );

      // Act
      List<VaultListItemModel> actualVisibleVaults = actualVaultListPageState.visibleVaults;

      // Assert
      List<VaultListItemModel> expectedVisibleVaults = <VaultListItemModel>[
        VaultListItemModel(
          encryptedBool: false,
          vaultModel: VaultModel(index: 2, uuid: '3c9f53ff-a5bc-465a-a3ef-c518d763eeb1', pinnedBool: true, name: 'Test Vault 3'),
          vaultWallets: const <WalletModel>[],
        ),
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
      ];

      expect(actualVisibleVaults, expectedVisibleVaults);
    });
  });
}
