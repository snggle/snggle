import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/record_audio_page/record_audio_page_cubit.dart';
import 'package:snggle/bloc/pages/record_audio_page/record_audio_page_state.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/database_mock.dart';
import '../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late RecordAudioPageCubit actualRecordAudioPageCubit;

  group('Test of RecordAudioPageCubit process (scanning single-part UR)', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualRecordAudioPageCubit = RecordAudioPageCubit(unsupportedOperationCallback: () {});
    });

    test('Should [return RecordAudioPageState] with initial values', () {
      // Act
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = const RecordAudioPageState();

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    test('Should [return RecordAudioPageState] with decoded value', () {
      // Act
      actualRecordAudioPageCubit.processAudio(
          Uint8List.fromList(<int>[217, 1, 48, 162, 1, 138, 24, 44, 245, 24, 60, 245, 0, 245, 0, 244, 0, 244, 2, 26, 151, 93, 77, 241]));
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = const RecordAudioPageState(
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

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    test('Should [return RecordAudioPageState] with loaded Audio result page', () {
      // Assert
      Widget actualRecordAudioResultPage = const SizedBox();

      // Act
      actualRecordAudioPageCubit.notifyViewLoaded(actualRecordAudioResultPage);
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = RecordAudioPageState(
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
        audioResultPage: actualRecordAudioResultPage,
      );

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    test('Should [return RecordAudioPageState] with reset values', () {
      // Act
      actualRecordAudioPageCubit.reset();
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = const RecordAudioPageState();

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Test of RecordAudioPageCubit process (scanning unsupported UR)', () {
    setUpAll(() async {
      await testDatabase.init(
        databaseMock: DatabaseMock.transactionsDatabaseMock,
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
      );

      actualRecordAudioPageCubit = RecordAudioPageCubit(unsupportedOperationCallback: () {});
    });

    test('Should [return RecordAudioPageState] with initial values', () {
      // Act
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = const RecordAudioPageState();

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    test('Should [return RecordAudioPageState] with decoded value', () {
      // Act
      actualRecordAudioPageCubit
          .processAudio(Uint8List.fromList(<int>[20, 1, 48, 162, 1, 41, 24, 44, 245, 24, 60, 88, 0, 245, 0, 244, 0, 244, 2, 26, 151, 93, 77, 241]));
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = const RecordAudioPageState();

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    test('Should [return RecordAudioPageState] with reset values', () {
      // Act
      actualRecordAudioPageCubit.reset();
      RecordAudioPageState actualRecordAudioPageState = actualRecordAudioPageCubit.state;

      // Assert
      RecordAudioPageState expectedRecordAudioPageState = const RecordAudioPageState();

      expect(actualRecordAudioPageState, expectedRecordAudioPageState);
    });

    tearDownAll(testDatabase.close);
  });
}
