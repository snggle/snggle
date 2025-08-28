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

  late SolanaSignTxPageCubit actualSignTxPageCubit;
  late WalletModel actualWalletModel;

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS values] and [transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SolanaSignTxPageCubit(
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

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageConfirmTxState] with initialized wallet and wallet password', () async {
      // Act
      await actualSignTxPageCubit.init();
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSignTxPageCubit.signTransaction();
      SolanaSignTxPageSignedTxState actualSignTxPageState = actualSignTxPageCubit.state as SolanaSignTxPageSignedTxState;

      // Assert
      SolanaSignTxPageSignedTxState expectedSignTxPageState = SolanaSignTxPageSignedTxState(
        transactionModel: SolanaTransactionModel(
          id: Isar.autoIncrement,
          walletId: 2,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signature:
              '0x2c246c695a5e45977b4865050a73a38639cc2aa013ed9908ab95ae6303eb8e8b2dd7a3214d6aa9d5649d489d87a08964d5d826a225119a0c956ad2100c29030b',
          message:
          'opensea.io wants you to sign in with your account:\n'
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

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS values] and [transaction INVALID]', () {
    late WalletModel actualWalletModel;

    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SolanaSignTxPageCubit(
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

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [throw ScanTxException.receivedAddressEmpty] if [transaction HAS EMPTY address]', () async {
      // Arrange
      globalLocator<ActiveWalletController>().clearActiveWallet();

      // Assert
      expect(
        () => actualSignTxPageCubit.init(),
        throwsA(const ScanQrException(ScanQrExceptionType.receivedAddressEmpty)),
      );
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS values], [wallet has PARENT password] and [transaction VALID]', () {
    late WalletModel actualWalletModel;

    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMockWithPassword,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SolanaSignTxPageCubit(
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

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageConfirmTxState] with initialized wallet and wallet password', () async {
      // Arrange
      globalLocator<PasswordController>().addPassword(PasswordModel.defaultPassword(), const FilesystemPath(<String>['vault1']));

      // Act
      await actualSignTxPageCubit.init();
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSignTxPageCubit.signTransaction();
      SolanaSignTxPageSignedTxState actualSignTxPageState = actualSignTxPageCubit.state as SolanaSignTxPageSignedTxState;

      // Assert
      SolanaSignTxPageSignedTxState expectedSignTxPageState = SolanaSignTxPageSignedTxState(
        transactionModel: SolanaTransactionModel(
          id: Isar.autoIncrement,
          walletId: 2,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signature:
          '0x2c246c695a5e45977b4865050a73a38639cc2aa013ed9908ab95ae6303eb8e8b2dd7a3214d6aa9d5649d489d87a08964d5d826a225119a0c956ad2100c29030b',
          message:
          'opensea.io wants you to sign in with your account:\n'
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

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS EMPTY values] and [Transaction VALID]', () {
    setUp(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SolanaSignTxPageCubit(
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
      );
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [throw ScanQrExceptionType.receivedAddressEmpty] if [wallet NOT SET]', () async {
      // Assert
      expect(
            () => actualSignTxPageCubit.init(),
        throwsA(const ScanQrException(ScanQrExceptionType.receivedAddressEmpty)),
      );
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS EMPTY values], [wallet has PARENT password] and [transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMockWithPassword,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
          signData: base64Decode(
            'AQACBB0D1AEIXs5Rz43yeayo7W0tSpSEF7kNTRVAVF4UGFj0UZgIBV3jdeGVGJKrsLg0H3NjL/I/lmh3OjD0yjTNe1wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMGRm/lIRcy/+ytunLDm+e8jOW7xfcSayxDmzpAAAAAvsFnx3LCWACVgkEemZnhkUpLl9hJ7zvQyrFIrH+YayoDAwAJAwAtMQEAAAAAAwAFAu8BAAACAgABDAIAAAAAypo7AAAAAA==',
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
      );

      globalLocator<ActiveWalletController>().clearActiveWallet();
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [throw ScanTxException.walletWithEncryptedParents] if [wallet NOT SET] and [HAS parent password]', () async {
      // Assert
      expect(
        () => actualSignTxPageCubit.init(),
        throwsA(const ScanQrException(ScanQrExceptionType.walletWithEncryptedParents)),
      );
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS EMPTY values], [transaction VALID] but [address NOT EXISTS]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SolanaSignTxPageCubit(
        cborSolSignRequest: CborSolSignRequest(
          requestId: base64Decode('+/KzMsaXS3efD8VgHR9KsQ=='),
          signData: base64Decode(
            'AQACBB0D1AEIXs5Rz43yeayo7W0tSpSEF7kN1RVAVF4UGFj0UZgIBV3jdeGVGJKrsLg0H3NjL/I/lmh3OjD0yjTNe1wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMGRm/lIRcy/+ytunLDm+e8jOW7xfcSayxDmzpAAAAAvsFnx3LCWACVgkEemZnhkUpLl9hJ7zvQyrFIrH+YayoDAwAJAwAtMQEAAAAAAwAFAu8BAAACAgABDAIAAAAAypo7AAAAAA==',
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
      );
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASolanaSignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASolanaSignTxPageState expectedSignTxPageState = const SolanaSignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [throw ScanTxException.walletNotFound] if [wallet NOT SET] and [HAS parent password]', () async {
      // Assert
      expect(
        () => actualSignTxPageCubit.init(),
        throwsA(const ScanQrException(ScanQrExceptionType.walletNotFound)),
      );
    });

    tearDownAll(testDatabase.close);
  });
}
