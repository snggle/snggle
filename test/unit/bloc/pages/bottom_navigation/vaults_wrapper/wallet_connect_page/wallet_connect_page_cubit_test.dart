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

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late WalletConnectPageCubit actualWalletConnectPageCubit;

  setUp(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      databaseMock: DatabaseMock.fullDatabaseMock,
    );

    actualWalletConnectPageCubit = WalletConnectPageCubit(
      vaultPasswordModel: PasswordModel.defaultPassword(),
      vaultModel: VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
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
  });

  group('Tests of WalletConnectPageCubit process', () {
    test('Should [return WalletConnectPageState] with WalletConnectOption.qr as default state', () {
      // Act
      WalletConnectPageState actualWalletConnectPageState = actualWalletConnectPageCubit.state;

      // Assert
      WalletConnectPageState expectedWalletConnectPageState = const WalletConnectPageState(walletConnectOption: WalletConnectOption.qr);

      expect(actualWalletConnectPageState, expectedWalletConnectPageState);
    });

    test('Should [return WalletConnectPageState] with WalletConnectOption.hardware', () {
      // Act
      actualWalletConnectPageCubit.changeConnectOption(WalletConnectOption.hardware);
      WalletConnectPageState actualWalletConnectPageState = actualWalletConnectPageCubit.state;

      // Assert
      WalletConnectPageState expectedWalletConnectPageState = const WalletConnectPageState(walletConnectOption: WalletConnectOption.hardware);

      expect(actualWalletConnectPageState, expectedWalletConnectPageState);
    });

    test('Should [return WalletConnectPageState] with WalletConnectOption.qr', () {
      // Act
      actualWalletConnectPageCubit.changeConnectOption(WalletConnectOption.qr);
      WalletConnectPageState actualWalletConnectPageState = actualWalletConnectPageCubit.state;

      // Assert
      WalletConnectPageState expectedWalletConnectPageState = const WalletConnectPageState(walletConnectOption: WalletConnectOption.qr);

      expect(actualWalletConnectPageState, expectedWalletConnectPageState);
    });

    test('Should [return CborCryptoHDKey] with extended public key for all wallets', () async {
      // Act
      CborCryptoHDKey actualCborCryptoHDKey = await actualWalletConnectPageCubit.getCborCryptoHDKey(connectAllBool: true);

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

    test('Should [return CborCryptoHDKey] with extended public key for single wallet', () async {
      // Act
      CborCryptoHDKey actualCborCryptoHDKey = await actualWalletConnectPageCubit.getCborCryptoHDKey(connectAllBool: false);

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
  });
}
