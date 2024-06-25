import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_state.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';

void main() {
  TransactionModel transactionModel = TransactionModel(
    id: 4,
    walletId: 1,
    creationDate: DateTime.parse('2024-08-02T08:50:06.549602Z'),
    signDate: DateTime.parse('2024-08-02T08:50:07.539410Z'),
    signDataType: SignDataType.typedTransaction,
    amount: '0.019321570386261305 ETH',
    fee: '0.001496331786753402 ETH',
    functionData:
        '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd',
    contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad',
    senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
    signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01',
  );

  group('Tests of WalletDetailsPageState.loading() constructor', () {
    test('Should [return WalletDetailsPageState] with [loadingBool == TRUE] and empty transactions', () {
      // Act
      WalletDetailsPageState actualWalletDetailsPageState = const WalletDetailsPageState.loading();

      // Assert
      WalletDetailsPageState expectedWalletDetailsPageState = const WalletDetailsPageState(
        loadingBool: true,
        transactions: <TransactionModel>[],
      );

      expect(actualWalletDetailsPageState, expectedWalletDetailsPageState);
    });
  });

  group('Tests of WalletDetailsPageState.isSelectionEnabled getter', () {
    test('Should [return TRUE] if [SelectionModel NOT EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = const WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[],
        selectionModel: SimpleSelectionModel<TransactionModel>(allItemsCount: 4, selectedItems: <TransactionModel>[]),
      );

      // Act
      bool actualIsSelectionEnabledBool = actualWalletDetailsPageState.isSelectionEnabled;

      // Assert
      expect(actualIsSelectionEnabledBool, true);
    });

    test('Should [return FALSE] if [SelectionModel EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = const WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[],
      );

      // Act
      bool actualIsSelectionEnabledBool = actualWalletDetailsPageState.isSelectionEnabled;

      // Assert
      expect(actualIsSelectionEnabledBool, false);
    });
  });

  group('Tests of WalletDetailsPageState.isScrollDisabled getter', () {
    test('Should [return TRUE] if [transactions EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = const WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[],
      );

      // Act
      bool actualSelectionEnabledBool = actualWalletDetailsPageState.isScrollDisabled;

      // Assert
      expect(actualSelectionEnabledBool, true);
    });

    test('Should [return TRUE] if [loadingBool == TRUE]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = WalletDetailsPageState(
        loadingBool: true,
        transactions: <TransactionModel>[transactionModel],
      );

      // Act
      bool actualSelectionEnabledBool = actualWalletDetailsPageState.isScrollDisabled;

      // Assert
      expect(actualSelectionEnabledBool, true);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [transactions NOT EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[transactionModel],
      );

      // Act
      bool actualSelectionEnabledBool = actualWalletDetailsPageState.isScrollDisabled;

      // Assert
      expect(actualSelectionEnabledBool, false);
    });
  });

  group('Tests of WalletDetailsPageState.isEmpty getter', () {
    test('Should [return TRUE] if [transactions EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = const WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[],
      );

      // Act
      bool actualSelectionEnabledBool = actualWalletDetailsPageState.isEmpty;

      // Assert
      expect(actualSelectionEnabledBool, true);
    });

    test('Should [return FALSE] if [transactions NOT EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[transactionModel],
      );

      // Act
      bool actualSelectionEnabledBool = actualWalletDetailsPageState.isScrollDisabled;

      // Assert
      expect(actualSelectionEnabledBool, false);
    });
  });

  group('Tests of WalletDetailsPageState.selectedTransactions getter', () {
    test('Should [return List<TransactionModel>] if [SelectionModel NOT EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[transactionModel],
        selectionModel: SimpleSelectionModel<TransactionModel>(
          allItemsCount: 1,
          selectedItems: <TransactionModel>[transactionModel],
        ),
      );

      // Act
      List<TransactionModel> actualSelectedTransactions = actualWalletDetailsPageState.selectedTransactions;

      // Assert
      List<TransactionModel> expectedSelectedTransactions = <TransactionModel>[transactionModel];

      expect(actualSelectedTransactions, expectedSelectedTransactions);
    });

    test('Should [return EMPTY list] if [SelectionModel EMPTY]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[transactionModel],
        selectionModel: const SimpleSelectionModel<TransactionModel>(
          allItemsCount: 1,
          selectedItems: <TransactionModel>[],
        ),
      );

      // Act
      List<TransactionModel> actualSelectedTransactions = actualWalletDetailsPageState.selectedTransactions;

      // Assert
      List<TransactionModel> expectedSelectedTransactions = <TransactionModel>[];

      expect(actualSelectedTransactions, expectedSelectedTransactions);
    });

    test('Should [return EMPTY list] if [SelectionModel NULL]', () {
      // Assert
      WalletDetailsPageState actualWalletDetailsPageState = WalletDetailsPageState(
        loadingBool: false,
        transactions: <TransactionModel>[transactionModel],
      );

      // Act
      List<TransactionModel> actualSelectedTransactions = actualWalletDetailsPageState.selectedTransactions;

      // Assert
      List<TransactionModel> expectedSelectedTransactions = <TransactionModel>[];

      expect(actualSelectedTransactions, expectedSelectedTransactions);
    });
  });
}
