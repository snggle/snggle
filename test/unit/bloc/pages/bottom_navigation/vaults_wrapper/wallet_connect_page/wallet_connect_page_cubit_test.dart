import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_connect_option.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';
import '../../../../../../utils/test_utils.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late WalletConnectPageCubit actualEthereumWalletConnectPageCubit;
  late WalletConnectPageCubit actualSolanaWalletConnectPageCubit;

  setUp(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      databaseMock: DatabaseMock.fullDatabaseMock,
    );

    actualEthereumWalletConnectPageCubit = WalletConnectPageCubit(
      vaultModel: VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
        fingerprint: 'o50XEfBazUYWOzGIr0PxLaijSkSunwKbAMkAjtlcGng=',
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[],
      ),
      walletModel: WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      ),
    );

    actualSolanaWalletConnectPageCubit = WalletConnectPageCubit(
      vaultModel: VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
        fingerprint: 'o50XEfBazUYWOzGIr0PxLaijSkSunwKbAMkAjtlcGng=',
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[],
      ),
      walletModel: WalletModel(
      id: 2,
      encryptedBool: false,
      pinnedBool: false,
      address: '4PBYLreUzbD92H4MVuGJvs6nbP3Ln7mx9GdtjyKryeW5',
      derivationPath: "m/44'/501'/0'/0'",
      filesystemPath: FilesystemPath.fromString('vault1/network2/wallet2'),
      name: 'WALLET 0',
    ),
    );
  });

  group('Tests of WalletConnectPageCubit process', () {
    test('Should [return WalletConnectPageState] with WalletConnectOption.qr as default state', () {
      // Act
      WalletConnectPageState actualWalletConnectPageState = actualEthereumWalletConnectPageCubit.state;

      // Assert
      WalletConnectPageState expectedWalletConnectPageState = const WalletConnectPageState(walletConnectOption: WalletConnectOption.qr);

      expect(actualWalletConnectPageState, expectedWalletConnectPageState);
    });

    test('Should [return WalletConnectPageState] with WalletConnectOption.hardware', () {
      // Act
      actualEthereumWalletConnectPageCubit.changeConnectOption(WalletConnectOption.hardware);
      WalletConnectPageState actualWalletConnectPageState = actualEthereumWalletConnectPageCubit.state;

      // Assert
      WalletConnectPageState expectedWalletConnectPageState = const WalletConnectPageState(walletConnectOption: WalletConnectOption.hardware);

      expect(actualWalletConnectPageState, expectedWalletConnectPageState);
    });

    test('Should [return WalletConnectPageState] with WalletConnectOption.qr', () {
      // Act
      actualEthereumWalletConnectPageCubit.changeConnectOption(WalletConnectOption.qr);
      WalletConnectPageState actualWalletConnectPageState = actualEthereumWalletConnectPageCubit.state;

      // Assert
      WalletConnectPageState expectedWalletConnectPageState = const WalletConnectPageState(walletConnectOption: WalletConnectOption.qr);

      expect(actualWalletConnectPageState, expectedWalletConnectPageState);
    });

    test('Should [return CborCryptoHDKey] with extended public key for all wallets (Ethereum)', () async {
      // Arrange
      TestUtils.mockPasswords(
        FilesystemPath.fromString('vault1/network1/wallet1'),
        List<PasswordModel>.generate(3, (_) => PasswordModel.defaultPassword()),
      );

      // Act
      CborCryptoHDKey actualCborCryptoHDKey = await actualEthereumWalletConnectPageCubit.getCborCryptoHDKey(connectAllBool: true);

      // Assert
      CborCryptoHDKey expectedCborCryptoHDKey = CborCryptoHDKey(
        isMaster: false,
        isPrivate: false,
        keyData: base64Decode('A7qX9gsjeMUktajTANBk+Qt4Kj61kmOZNTtGE7gCjId9'),
        chainCode: base64Decode('y6ftHhOQADTeltcKF0os/Ma+aHn6FXwpze9SWCLFh7U='),
        origin: const CborCryptoKeypath(components: <CborPathComponent>[
          CborPathComponent(index: 44, hardened: true),
          CborPathComponent(index: 60, hardened: true),
          CborPathComponent(index: 0, hardened: true),
        ], sourceFingerprint: 2429747484, depth: 3),
        parentFingerprint: 608992098,
        name: 'WALLET 0',
      );

      expect(actualCborCryptoHDKey, expectedCborCryptoHDKey);
    });

    test('Should [return CborCryptoHDKey] with extended public key for single wallet (Ethereum)', () async {
      // Arrange
      TestUtils.mockPasswords(
        FilesystemPath.fromString('vault1/network1/wallet1'),
        List<PasswordModel>.generate(3, (_) => PasswordModel.defaultPassword()),
      );

      // Act
      CborCryptoHDKey actualCborCryptoHDKey = await actualEthereumWalletConnectPageCubit.getCborCryptoHDKey(connectAllBool: false);

      // Assert
      CborCryptoHDKey expectedCborCryptoHDKey = CborCryptoHDKey(
        isMaster: false,
        isPrivate: false,
        keyData: base64Decode('A8Y38s8vNAvXkzd6tQf2iOc8alZjaaOe/avpBAiLxheo'),
        chainCode: base64Decode('9zp7uVBVTvf76kqiHs2v9hzqUcyNvJ9HjuyKnirZOC0='),
        origin: const CborCryptoKeypath(components: <CborPathComponent>[
          CborPathComponent(index: 44, hardened: true),
          CborPathComponent(index: 60, hardened: true),
          CborPathComponent(index: 0, hardened: true),
          CborPathComponent(index: 0, hardened: false),
        ], sourceFingerprint: 2455739192, depth: 4),
        children: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 0, hardened: false),
          ],
        ),
        parentFingerprint: 2429747484,
        name: 'WALLET 0',
      );

      expect(actualCborCryptoHDKey, expectedCborCryptoHDKey);
    });

    test('Should [return CborCryptoMultiAccounts] with extended public key for single wallet (Solana)', () async {
      // Arrange
      TestUtils.mockPasswords(
        FilesystemPath.fromString('vault1/network2/wallet2'),
        List<PasswordModel>.generate(3, (_) => PasswordModel.defaultPassword()),
      );

      // Act
      CborCryptoMultiAccounts actualMultiAccounts =
      await actualSolanaWalletConnectPageCubit.getCborCryptoMultiAccounts();

      // Assert
      CborCryptoHDKey expectedSolanaKey = CborCryptoHDKey(
        isMaster: false,
        isPrivate: false,
        keyData: base64Decode('4UQS8URJGafQt0+N8dK3aIRHwCFf9zdY10IQlvYT6zs='),
        origin: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
        ),
        name: 'WALLET 0',
      );

      CborCryptoMultiAccounts expectedMultiAccounts = CborCryptoMultiAccounts(
        cryptoHDKeyList: <CborCryptoHDKey>[expectedSolanaKey],
      );

      expect(actualMultiAccounts, expectedMultiAccounts);
    });

  });
}
