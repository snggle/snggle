import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/a_solana_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/solana_sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  late SolanaSignTxPageCubit actualSolanaSignTxPageCubit;
  late WalletModel actualWalletModel;

  group('Tests of SolanaSignTxPageCubit process [useWalletAutoDetectionBool = true] and [transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSolanaSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('eGTmHNPqQ7S8Tr82B/gXJQ=='),
          signData: base64Decode(
            'AQACBB0D1AEIXs5Rz43yeayo7W0tSpSEF7kNTRVAVF4UGFj0UZgIBV3jdeGVGJKrsLg0H3NjL/I/lmh3OjD0yjTNe1wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMGRm/lIRcy/+ytunLDm+e8jOW7xfcSayxDmzpAAAAAItbFV40WJHs9F/tzZoXC0g3E5NES2zVTarwDxUJuR/kDAwAJAwAtMQEAAAAAAwAFAu8BAAACAgABDAIAAAAAypo7AAAAAA==',
          ),
          dataType: CborSolSignDataType.transaction,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true)
            ],
          ),
        ),
        walletAutoDetectionEnabledBool: true,
      );

      actualWalletModel = WalletModel(
        id: 2,
        encryptedBool: false,
        pinnedBool: false,
        address: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        derivationPath: "m/44'/501'/0'/0'",
        filesystemPath: FilesystemPath.fromString('vault1/network2/wallet2'),
        name: 'WALLET 1',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel);
    });

    test('Should [return SolanaSignTxPageCubit] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageCubit] with initialized wallet and wallet password', () async {
      // Act
      await actualSolanaSignTxPageCubit.init();
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSolanaSignTxPageCubit.signTransaction();
      SolanaSignTxPageSignedTxState actualSignTxPageState = actualSolanaSignTxPageCubit.state as SolanaSignTxPageSignedTxState;

      // Assert
      SolanaSignTxPageSignedTxState expectedSignTxPageState = SolanaSignTxPageSignedTxState(
          transactionModel: SolanaTransactionModel(
            id: Isar.autoIncrement,
            walletId: 2,
            creationDate: actualSignTxPageState.transactionModel.creationDate,
            signature:
                '0x693db5bf119ce9f2d9fe6de94c423641d9e7c61adbd3d9ec51782d308d7cfa7bdabe3565131336ada3e72a144d163be08cb7db65af0a200263075c43a16cf50c',
            transactionData:
                '0x010002041d03d401085ece51cf8df279aca8ed6d2d4a948417b90d4d1540545e141858f4519808055de375e1951892abb0b8341f73632ff23f9668773a30f4ca34cd7b5c00000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a4000000022d6c5578d16247b3d17fb736685c2d20dc4e4d112db35536abc03c5426e47f90303000903002d31010000000003000502ef010000020200010c0200000000ca9a3b00000000',
            signDate: actualSignTxPageState.transactionModel.signDate,
            signDataType: SignDataType.typedTransaction,
            amount: '1 SOL',
            senderAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
            recipientAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z',
            signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
          ),
          cborSolSignature: CborSolSignature(
            requestId: base64Decode('eGTmHNPqQ7S8Tr82B/gXJQ=='),
            signature: base64Decode(
              'aT21vxGc6fLZ/m3pTEI2Qdnnxhrb09nsUXgtMI18+nvavjVlExM2raPnKhRNFjvgjLfbZa8KIAJjB1xDoWz1DA==',
            ),
          ));

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SolanaSignTxPageCubit process [useWalletAutoDetectionBool = true] and [MISSING WALLET ADDRESS]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSolanaSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
          signData: base64Decode(
            'b3BlbnNlYS5pbyB3YW50cyB5b3UgdG8gc2lnbiBpbiB3aXRoIHlvdXIgYWNjb3VudDoKMnhHRDdjV3R3cG1DcFcyTnZUOUVKdDk2ZURhdlMzc3VWZ1FOVmFCVTRBMTkKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClVSSTogaHR0cHM6Ly9vcGVuc2VhLmlvLwpWZXJzaW9uOiAxCkNoYWluIElEOiAxCk5vbmNlOiBncThjcDI4aW5uODlyZ3ZhaG91c2QycXMzMwpJc3N1ZWQgQXQ6IDIwMjUtMDgtMjVUMTY6MjU6MzkuMzI5Wg==',
          ),
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
          ),
          dataType: CborSolSignDataType.message,
        ),
        walletAutoDetectionEnabledBool: true,
      );
    });

    test('Should [return SolanaSignTxPageCubit] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageCubit] with active wallet address if [transaction HAS EMPTY address]', () async {
      // Assert
      expect(
        () => actualSolanaSignTxPageCubit.init(),
        throwsA(const ScanQrException(ScanQrExceptionType.receivedAddressEmpty)),
      );
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SolanaSignTxPageCubit process [useWalletAutoDetectionBool = true], [wallet has PARENT password]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMockWithPassword,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSolanaSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('eGTmHNPqQ7S8Tr82B/gXJQ=='),
          signData: base64Decode(
            'AQACBB0D1AEIXs5Rz43yeayo7W0tSpSEF7kNTRVAVF4UGFj0UZgIBV3jdeGVGJKrsLg0H3NjL/I/lmh3OjD0yjTNe1wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMGRm/lIRcy/+ytunLDm+e8jOW7xfcSayxDmzpAAAAAItbFV40WJHs9F/tzZoXC0g3E5NES2zVTarwDxUJuR/kDAwAJAwAtMQEAAAAAAwAFAu8BAAACAgABDAIAAAAAypo7AAAAAA==',
          ),
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
          ),
          dataType: CborSolSignDataType.transaction,
        ),
        walletAutoDetectionEnabledBool: true,
      );
    });

    test('Should [return SolanaSignTxPageCubit] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageCubit] with initialized wallet and wallet password', () async {
      // Arrange
      globalLocator<PasswordController>().addPassword(PasswordModel.defaultPassword(), const FilesystemPath(<String>['vault1']));

      // Act
      await actualSolanaSignTxPageCubit.init();
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSolanaSignTxPageCubit.signTransaction();
      SolanaSignTxPageSignedTxState actualSignTxPageState = actualSolanaSignTxPageCubit.state as SolanaSignTxPageSignedTxState;

      // Assert
      SolanaSignTxPageSignedTxState expectedSignTxPageState = SolanaSignTxPageSignedTxState(
          transactionModel: SolanaTransactionModel(
            id: Isar.autoIncrement,
            walletId: 2,
            creationDate: actualSignTxPageState.transactionModel.creationDate,
            signature:
                '0x693db5bf119ce9f2d9fe6de94c423641d9e7c61adbd3d9ec51782d308d7cfa7bdabe3565131336ada3e72a144d163be08cb7db65af0a200263075c43a16cf50c',
            transactionData:
                '0x010002041d03d401085ece51cf8df279aca8ed6d2d4a948417b90d4d1540545e141858f4519808055de375e1951892abb0b8341f73632ff23f9668773a30f4ca34cd7b5c00000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a4000000022d6c5578d16247b3d17fb736685c2d20dc4e4d112db35536abc03c5426e47f90303000903002d31010000000003000502ef010000020200010c0200000000ca9a3b00000000',
            signDate: actualSignTxPageState.transactionModel.signDate,
            signDataType: SignDataType.typedTransaction,
            amount: '1 SOL',
            senderAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
            recipientAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z',
            signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
          ),
          cborSolSignature: CborSolSignature(
            requestId: base64Decode('eGTmHNPqQ7S8Tr82B/gXJQ=='),
            signature: base64Decode(
              'aT21vxGc6fLZ/m3pTEI2Qdnnxhrb09nsUXgtMI18+nvavjVlExM2raPnKhRNFjvgjLfbZa8KIAJjB1xDoWz1DA==',
            ),
          ));

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SolanaSignTxPageCubit process [useWalletAutoDetectionBool = false] and [transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSolanaSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
          signData: base64Decode(
            'b3BlbnNlYS5pbyB3YW50cyB5b3UgdG8gc2lnbiBpbiB3aXRoIHlvdXIgYWNjb3VudDoKMnhHRDdjV3R3cG1DcFcyTnZUOUVKdDk2ZURhdlMzc3VWZ1FOVmFCVTRBMTkKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClVSSTogaHR0cHM6Ly9vcGVuc2VhLmlvLwpWZXJzaW9uOiAxCkNoYWluIElEOiAxCk5vbmNlOiBncThjcDI4aW5uODlyZ3ZhaG91c2QycXMzMwpJc3N1ZWQgQXQ6IDIwMjUtMDgtMjVUMTY6MjU6MzkuMzI5Wg==',
          ),
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
          ),
          dataType: CborSolSignDataType.message,
        ),
        walletAutoDetectionEnabledBool: false,
      );

      actualWalletModel = WalletModel(
        id: 2,
        encryptedBool: false,
        pinnedBool: false,
        address: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        derivationPath: "m/44'/501'/0'/0'",
        filesystemPath: FilesystemPath.fromString('vault1/network2/wallet2'),
        name: 'WALLET 1',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel);
    });

    test('Should [return SolanaSignTxPageCubit] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageCubit] with initialized wallet and wallet password', () async {
      // Act
      await actualSolanaSignTxPageCubit.init();
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSolanaSignTxPageCubit.signTransaction();
      SolanaSignTxPageSignedTxState actualSignTxPageState = actualSolanaSignTxPageCubit.state as SolanaSignTxPageSignedTxState;

      // Assert
      SolanaSignTxPageSignedTxState expectedSignTxPageState = SolanaSignTxPageSignedTxState(
        transactionModel: SolanaTransactionModel(
          id: Isar.autoIncrement,
          walletId: 2,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signature:
              '0x2c246c695a5e45977b4865050a73a38639cc2aa013ed9908ab95ae6303eb8e8b2dd7a3214d6aa9d5649d489d87a08964d5d826a225119a0c956ad2100c29030b',
          message: 'opensea.io wants you to sign in with your account:\n'
              '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n'
              '\n'
              'Click to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n'
              '\n'
              'URI: https://opensea.io/\n'
              'Version: 1\n'
              'Chain ID: 1\n'
              'Nonce: gq8cp28inn89rgvahousd2qs33\n'
              'Issued At: 2025-08-25T16:25:39.329Z',
          signDate: actualSignTxPageState.transactionModel.signDate,
          signDataType: SignDataType.rawBytes,
          signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        ),
        cborSolSignature: CborSolSignature(
          signature: base64Decode('LCRsaVpeRZd7SGUFCnOjhjnMKqAT7ZkIq5WuYwPrjost16MhTWqp1WSdSJ2HoIlk1dgmoiURmgyVatIQDCkDCw=='),
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
        ),
      );

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SolanaSignTxPageCubit process [useWalletAutoDetectionBool = false] and [MISSING WALLET ADDRESS]', () {
    late WalletModel actualWalletModel;

    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSolanaSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
          signData: base64Decode(
            'b3BlbnNlYS5pbyB3YW50cyB5b3UgdG8gc2lnbiBpbiB3aXRoIHlvdXIgYWNjb3VudDoKMnhHRDdjV3R3cG1DcFcyTnZUOUVKdDk2ZURhdlMzc3VWZ1FOVmFCVTRBMTkKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClVSSTogaHR0cHM6Ly9vcGVuc2VhLmlvLwpWZXJzaW9uOiAxCkNoYWluIElEOiAxCk5vbmNlOiBncThjcDI4aW5uODlyZ3ZhaG91c2QycXMzMwpJc3N1ZWQgQXQ6IDIwMjUtMDgtMjVUMTY6MjU6MzkuMzI5Wg==',
          ),
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
          ),
          dataType: CborSolSignDataType.message,
        ),
        walletAutoDetectionEnabledBool: false,
      );

      actualWalletModel = WalletModel(
        id: 2,
        encryptedBool: false,
        pinnedBool: false,
        address: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        derivationPath: "m/44'/501'/0'/0'",
        filesystemPath: FilesystemPath.fromString('vault1/network2/wallet2'),
        name: 'WALLET 1',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel);
    });

    test('Should [return SolanaSignTxPageCubit] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageCubit] with active wallet address if [transaction HAS EMPTY address]', () async {
      // Arrange
      await actualSolanaSignTxPageCubit.init();

      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;
      String actualActiveWalletAddress = actualSolanaSignTxPageCubit.senderWalletModel.address;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();
      String expectedActiveWalletAddress = '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19';

      expect(actualSignTxPageState, expectedSignTxPageState);
      expect(actualActiveWalletAddress, expectedActiveWalletAddress);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SolanaSignTxPageCubit process [useWalletAutoDetectionBool = false], [wallet has PARENT password]', () {
    late WalletModel actualWalletModel;

    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMockWithPassword,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSolanaSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
          signData: base64Decode(
            'b3BlbnNlYS5pbyB3YW50cyB5b3UgdG8gc2lnbiBpbiB3aXRoIHlvdXIgYWNjb3VudDoKMnhHRDdjV3R3cG1DcFcyTnZUOUVKdDk2ZURhdlMzc3VWZ1FOVmFCVTRBMTkKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClVSSTogaHR0cHM6Ly9vcGVuc2VhLmlvLwpWZXJzaW9uOiAxCkNoYWluIElEOiAxCk5vbmNlOiBncThjcDI4aW5uODlyZ3ZhaG91c2QycXMzMwpJc3N1ZWQgQXQ6IDIwMjUtMDgtMjVUMTY6MjU6MzkuMzI5Wg==',
          ),
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
          ),
          dataType: CborSolSignDataType.message,
        ),
        walletAutoDetectionEnabledBool: false,
      );

      actualWalletModel = WalletModel(
        id: 2,
        encryptedBool: false,
        pinnedBool: false,
        address: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        derivationPath: "m/44'/501'/0'/0'",
        filesystemPath: FilesystemPath.fromString('vault1/network2/wallet2'),
        name: 'WALLET 1',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel);
    });

    test('Should [return SolanaSignTxPageCubit] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageCubit] with initialized wallet and wallet password', () async {
      // Arrange
      globalLocator<PasswordController>().addPassword(PasswordModel.defaultPassword(), const FilesystemPath(<String>['vault1']));

      // Act
      await actualSolanaSignTxPageCubit.init();
      ASolanaSignTxPageState actualSignTxPageState = actualSolanaSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SolanaSignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSolanaSignTxPageCubit.signTransaction();
      SolanaSignTxPageSignedTxState actualSignTxPageState = actualSolanaSignTxPageCubit.state as SolanaSignTxPageSignedTxState;

      // Assert
      SolanaSignTxPageSignedTxState expectedSignTxPageState = SolanaSignTxPageSignedTxState(
        transactionModel: SolanaTransactionModel(
          id: Isar.autoIncrement,
          walletId: 2,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signature:
              '0x2c246c695a5e45977b4865050a73a38639cc2aa013ed9908ab95ae6303eb8e8b2dd7a3214d6aa9d5649d489d87a08964d5d826a225119a0c956ad2100c29030b',
          message: 'opensea.io wants you to sign in with your account:\n'
              '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n'
              '\n'
              'Click to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n'
              '\n'
              'URI: https://opensea.io/\n'
              'Version: 1\n'
              'Chain ID: 1\n'
              'Nonce: gq8cp28inn89rgvahousd2qs33\n'
              'Issued At: 2025-08-25T16:25:39.329Z',
          signDate: actualSignTxPageState.transactionModel.signDate,
          signDataType: SignDataType.rawBytes,
          signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        ),
        cborSolSignature: CborSolSignature(
          signature: base64Decode('LCRsaVpeRZd7SGUFCnOjhjnMKqAT7ZkIq5WuYwPrjost16MhTWqp1WSdSJ2HoIlk1dgmoiURmgyVatIQDCkDCw=='),
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
        ),
      );

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    tearDownAll(testDatabase.close);
  });
}
