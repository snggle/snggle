import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/record_audio_page/record_audio_page_state.dart';

void main() {
  group('Tests of RecordAudioPageState.canReceiveAudio()', () {
    test('Should [return TRUE] if [loadingBool == FALSE], [cborTaggedObject EMPTY] and [audioResultPage EMPTY]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState();

      // Act
      bool actualScanningEnabledBool = actualRecordAudioPageState.canReceiveAudio();

      // Assert
      expect(actualScanningEnabledBool, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(loadingBool: true);

      // Act
      bool actualScanningEnabledBool = actualRecordAudioPageState.canReceiveAudio();

      // Assert
      expect(actualScanningEnabledBool, false);
    });

    test('Should [return FALSE] if [cborTaggedObject HAS VALUE]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(
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

      // Act
      bool actualScanningEnabledBool = actualRecordAudioPageState.canReceiveAudio();

      // Assert
      expect(actualScanningEnabledBool, false);
    });

    test('Should [return FALSE] if [audioResultPage HAS VALUE]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(audioResultPage: SizedBox());

      // Act
      bool actualScanningEnabledBool = actualRecordAudioPageState.canReceiveAudio();

      // Assert
      expect(actualScanningEnabledBool, false);
    });
  });

  group('Tests of RecordAudioPageState.shouldLoadResultPage()', () {
    test('Should [return TRUE] if [loadingBool == TRUE], [cborTaggedObject HAS VALUE] and [audioResultPage EMPTY]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(
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

      // Act
      bool actualLoadResultBool = actualRecordAudioPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE], [cborTaggedObject HAS VALUE] and [audioResultPage HAS VALUES]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(
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
        audioResultPage: SizedBox(),
      );

      // Act
      bool actualLoadResultBool = actualRecordAudioPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, false);
    });

    test('Should [return FALSE] if [loadingBool == TRUE], [cborTaggedObject EMPTY] and [audioResultPage EMPTY]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(
        loadingBool: true,
      );

      // Act
      bool actualLoadResultBool = actualRecordAudioPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, false);
    });

    test('Should [return FALSE] if [loadingBool == FALSE], [cborTaggedObject HAS VALUE] and [audioResultPage EMPTY]', () {
      // Arrange
      RecordAudioPageState actualRecordAudioPageState = const RecordAudioPageState(
        loadingBool: false,
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

      // Act
      bool actualLoadResultBool = actualRecordAudioPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, false);
    });
  });
}
