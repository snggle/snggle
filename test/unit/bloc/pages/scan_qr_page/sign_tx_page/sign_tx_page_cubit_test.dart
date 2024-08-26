import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  late SignTxPageCubit actualSignTxPageCubit;
  late WalletModel actualWalletModel;

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS values] and [transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SignTxPageCubit(
        cborEthSignRequest: CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        ),
      );

      actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel, walletPasswordModel: PasswordModel.defaultPassword());
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageConfirmTxState] with initialized wallet and wallet password', () async {
      // Act
      await actualSignTxPageCubit.init();
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSignTxPageCubit.signTransaction();
      SignTxPageSignedTxState actualSignTxPageState = actualSignTxPageCubit.state as SignTxPageSignedTxState;

      // Assert
      SignTxPageSignedTxState expectedSignTxPageState = SignTxPageSignedTxState(
        transactionModel: TransactionModel(
          id: Isar.autoIncrement,
          walletId: 1,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signDataType: SignDataType.rawBytes,
          senderAddress: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
          message:
              'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x53bf0a18754873a8102625d8225af6a15a43423c\n\nNonce:\n1d8d2dc1-0b7c-4762-a520-a485ae261719',
          signature: '0xb01714bf19f9e2afbdf53cf97b4479b7d55b729a604787681535f57c53df5cb07f8653c1a20bfa3e68c3289b2584ab7de9a9acc0998d0cfb5a34a2b586630e3b1b',
          signDate: actualSignTxPageState.transactionModel.signDate,
        ),
        cborEthSignature: CborEthSignature(
          signature: base64Decode('sBcUvxn54q+99Tz5e0R5t9VbcppgR4doFTX1fFPfXLB/hlPBogv6PmjDKJslhKt96amswJmNDPtaNKK1hmMOOxs='),
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
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

      actualSignTxPageCubit = SignTxPageCubit(
        cborEthSignRequest: CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
        ),
      );

      actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel, walletPasswordModel: PasswordModel.defaultPassword());
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [throw ScanTxException.receivedAddressEmpty] if [transaction HAS EMPTY address]', () async {
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

      actualSignTxPageCubit = SignTxPageCubit(
        cborEthSignRequest: CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        ),
      );

      actualWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      globalLocator<ActiveWalletController>().setActiveWallet(walletModel: actualWalletModel, walletPasswordModel: PasswordModel.defaultPassword());
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageConfirmTxState] with initialized wallet and wallet password', () async {
      // Act
      await actualSignTxPageCubit.init();
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSignTxPageCubit.signTransaction();
      SignTxPageSignedTxState actualSignTxPageState = actualSignTxPageCubit.state as SignTxPageSignedTxState;

      // Assert
      SignTxPageSignedTxState expectedSignTxPageState = SignTxPageSignedTxState(
        transactionModel: TransactionModel(
          id: Isar.autoIncrement,
          walletId: 1,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signDataType: SignDataType.rawBytes,
          senderAddress: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
          message:
              'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x53bf0a18754873a8102625d8225af6a15a43423c\n\nNonce:\n1d8d2dc1-0b7c-4762-a520-a485ae261719',
          signature: '0xb01714bf19f9e2afbdf53cf97b4479b7d55b729a604787681535f57c53df5cb07f8653c1a20bfa3e68c3289b2584ab7de9a9acc0998d0cfb5a34a2b586630e3b1b',
          signDate: actualSignTxPageState.transactionModel.signDate,
        ),
        cborEthSignature: CborEthSignature(
          signature: base64Decode('sBcUvxn54q+99Tz5e0R5t9VbcppgR4doFTX1fFPfXLB/hlPBogv6PmjDKJslhKt96amswJmNDPtaNKK1hmMOOxs='),
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
        ),
      );

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS EMPTY values] and [Transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SignTxPageCubit(
        cborEthSignRequest: CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        ),
      );
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageConfirmTxState] with initialized wallet and wallet password', () async {
      // Act
      await actualSignTxPageCubit.init();
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    test('Should [return SignTxPageSignedTxState] with signed transaction', () async {
      // Act
      await actualSignTxPageCubit.signTransaction();
      SignTxPageSignedTxState actualSignTxPageState = actualSignTxPageCubit.state as SignTxPageSignedTxState;

      // Assert
      SignTxPageSignedTxState expectedSignTxPageState = SignTxPageSignedTxState(
        transactionModel: TransactionModel(
          id: Isar.autoIncrement,
          walletId: 1,
          creationDate: actualSignTxPageState.transactionModel.creationDate,
          signDataType: SignDataType.rawBytes,
          senderAddress: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
          message:
              'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x53bf0a18754873a8102625d8225af6a15a43423c\n\nNonce:\n1d8d2dc1-0b7c-4762-a520-a485ae261719',
          signature: '0xb01714bf19f9e2afbdf53cf97b4479b7d55b729a604787681535f57c53df5cb07f8653c1a20bfa3e68c3289b2584ab7de9a9acc0998d0cfb5a34a2b586630e3b1b',
          signDate: actualSignTxPageState.transactionModel.signDate,
        ),
        cborEthSignature: CborEthSignature(
          signature: base64Decode('sBcUvxn54q+99Tz5e0R5t9VbcppgR4doFTX1fFPfXLB/hlPBogv6PmjDKJslhKt96amswJmNDPtaNKK1hmMOOxs='),
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
        ),
      );

      expect(actualSignTxPageState, expectedSignTxPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of SignTxPageCubit process [ActiveWalletController HAS EMPTY values], [wallet has PARENT password] and [transaction VALID]', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMockWithPassword,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualSignTxPageCubit = SignTxPageCubit(
        cborEthSignRequest: CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        ),
      );

      globalLocator<ActiveWalletController>().clearActiveWallet();
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

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

      actualSignTxPageCubit = SignTxPageCubit(
        cborEthSignRequest: CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x479b2970f03f9021cfF00B6e5807BA544EA351f8',
        ),
      );
    });

    test('Should [return SignTxPageConfirmTxState] with initial values', () {
      // Act
      ASignTxPageState actualSignTxPageState = actualSignTxPageCubit.state;

      // Assert
      ASignTxPageState expectedSignTxPageState = const SignTxPageConfirmTxState();

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
