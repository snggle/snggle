import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/scan_tx_page/scan_qr_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/scan_qr_page_state.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/database_mock.dart';
import '../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late ScanQRPageCubit actualScanQRPageCubit;

  group('Test of ScanQRPageCubit process (scanning single-part UR)', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualScanQRPageCubit = ScanQRPageCubit(unsupportedOperationCallback: () {});
    });

    test('Should [return ScanQRPageState] with initial values', () {
      // Act
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with decoded value', () {
      // Act
      actualScanQRPageCubit.processQR('ur:crypto-keypath/taaddyoeadlecsdwykcsfnykaeykaewkaewkaocymshlgtwnvejedtny');
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState(
        loadingBool: true,
        cborTaggedObject: CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        ),
      );

      expect(actualScanQRPageCubit.progressNotifier.value, 1);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with loaded QR result page', () {
      // Assert
      Widget actualQRResultPage = const SizedBox();

      // Act
      actualScanQRPageCubit.notifyViewLoaded(actualQRResultPage);
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = ScanQRPageState(
        loadingBool: false,
        cborTaggedObject: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        ),
        qrResultPage: actualQRResultPage,
      );

      expect(actualScanQRPageCubit.progressNotifier.value, 1);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with reset values', () {
      // Act
      actualScanQRPageCubit.reset();
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Test of ScanQRPageCubit process (scanning multi-part UR)', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualScanQRPageCubit = ScanQRPageCubit(unsupportedOperationCallback: () {});
    });

    test('Should [return ScanQRPageState] with initial values', () {
      // Act
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with updated progress (1/3)', () {
      // Act
      actualScanQRPageCubit.processQR(
        'ur:eth-sign-request/1015-3/lpcfaxylaxcfadmkcyltotttcwhdlowkcymwenidhdoyolwsvwlthkpfstgwamdklotizsvofybahthkbkenjofhhsdkcneodwdwcxcsftksjpimbnfhfxdpcmbtkiindebbjyiacnieenieiseodpemiaiacpemcpkbdyendnkoihdidyfrihfmkgbyjpisfsbnftkoihctatctcwsbfwdnpmglrlhlehwngyfnzmguptfdvycyzcgyflfmknrturamheguwkhsfngrfgdypfcycldwnldigdvtvekkfwbyfzfemuhfet',
      );
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with updated progress (2/3)', () {
      // Act
      actualScanQRPageCubit.processQR(
        'ur:eth-sign-request/491-3/lpcfadwmaxcfadmkcyltotttcwhdlogycwgsbweyashhaygmfpchcahhgsfxfxbgaockcthlfghghpchhlgucehhbagafgbwhdfxaehggecaceesinhyiddiceglbyaegrlbghchgsfyfebtbshlbthybtfxfxhkfghygygofdbwbzgubegwbthphphyaobtguhehechfegridjnkoroidfysbjtveetfxltethenyjklycxmdjtlgcpkibygopepeiaehcxmeaebgcpdtctsskpgmahrhfgfmlrssdtdyksenihbylsvd',
      );
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0.3333333333333333);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with decoded value (3/3)', () {
      // Act
      actualScanQRPageCubit.processQR(
        'ur:eth-sign-request/675-3/lpcfaootaxcfadmkcyltotttcwhdlohsiakkcxgdjljziniakkcxdeisjyjyjojkftdldljljoihjtjkihhsdminjldljojpinkohsiakkdtdmbkbkghisinjkcxjpihjskpihjkjycxktinjzjzcxjtjljycxjyjpinioioihjpcxhscxidjzjliajeiaishsinjtcxjyjphsjtjkhsiajyinjljtcxjljpcxiajljkjycxhsjtkkcxiohsjkcxiyihihjkdmbkbkhghsjzjzihjycxhsieiejpihjkjkftbkbsuepsbg',
      );
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = ScanQRPageState(
        loadingBool: true,
        cborTaggedObject: CborEthSignRequest(
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
          address: '0x53bf0a18754873a8102625d8225af6a15a43423c',
        ),
      );

      expect(actualScanQRPageCubit.progressNotifier.value, 1);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with loaded QR result page', () {
      // Assert
      Widget actualQRResultPage = const SizedBox();

      // Act
      actualScanQRPageCubit.notifyViewLoaded(actualQRResultPage);
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = ScanQRPageState(
        loadingBool: false,
        cborTaggedObject: CborEthSignRequest(
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
          address: '0x53bf0a18754873a8102625d8225af6a15a43423c',
        ),
        qrResultPage: actualQRResultPage,
      );

      expect(actualScanQRPageCubit.progressNotifier.value, 1);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with reset values', () {
      // Act
      actualScanQRPageCubit.reset();
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Test of ScanQRPageCubit process (scanning unsupported UR)', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualScanQRPageCubit = ScanQRPageCubit(unsupportedOperationCallback: () {});
    });

    test('Should [return ScanQRPageState] with initial values', () {
      // Act
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with decoded value', () {
      // Act
      actualScanQRPageCubit.processQR(
        'ur:bytes/hdeymejtswhhylkepmykhhtsytsnoyoyaxaedsuttydmmhhpktpmsrjtgwdpfnsboxgwlbaawzuefywkdplrsrjynbvygabwjldapfcsdwkbrkch',
      );
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 1);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    test('Should [return ScanQRPageState] with reset values', () {
      // Act
      actualScanQRPageCubit.reset();
      ScanQRPageState actualScanQRPageState = actualScanQRPageCubit.state;

      // Assert
      ScanQRPageState expectedScanQRPageState = const ScanQRPageState();

      expect(actualScanQRPageCubit.progressNotifier.value, 0);
      expect(actualScanQRPageState, expectedScanQRPageState);
    });

    tearDownAll(testDatabase.close);
  });
}
