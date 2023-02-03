import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';

void main() {
  group('Tests of MnemonicModel.isValid', (){
    test('Should return true for valid mnemonic with 12 words', () {
      // Arrange
      String actualMnemonicString = 'brave pair belt judge visual tunnel dinner siren dentist craft effort decrease';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Assert
      expect(actualMnemonicModel.isValid, true);
    });

    test('Should return true for valid mnemonic with 15 words', () {
      // Arrange
      String actualMnemonicString = 'photo punch entry aspect plunge critic soon volcano mountain better easily middle diagram float brass';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Assert
      expect(actualMnemonicModel.isValid, true);
    });

    test('Should return true for valid mnemonic with 18 words', () {
      // Arrange
      String actualMnemonicString = 'day swallow exclude gas calm baby random empower region motor unknown rural evolve begin uphold eternal over portion';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Assert
      expect(actualMnemonicModel.isValid, true);
    });

    test('Should return true for valid mnemonic with 21 words', () {
      // Arrange
      String actualMnemonicString = 'trophy neutral craft leave angle client divide bag sheriff shell piece sponsor pipe clown tired wise normal roast off settle romance';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Assert
      expect(actualMnemonicModel.isValid, true);
    });
    
    test('Should return true for valid mnemonic with 24 words', () {
      // Arrange
      String actualMnemonicString = 'try crouch outer budget write celery walk library river pelican train like truly spike capital history program actor bring open person target present tube';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Assert
      expect(actualMnemonicModel.isValid, true);
    });

    test('Should return false for invalid mnemonic', () {
      // Arrange
      String actualMnemonicString = 'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about abandon';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Assert
      expect(actualMnemonicModel.isValid, false);
    });
  });
  
  group('Tests of MnemonicModel.generate()', () {
    test('Should return mnemonic with 24 words', () {
      // Act
      MnemonicModel actualMnemonicModel = MnemonicModel.generate();

      // Assert
      // Because the mnemonic is generated randomly, it is not possible to predict the result.
      // Therefore, the test checks only the length and correctness of generated mnemonic.
      expect(actualMnemonicModel.mnemonicList.length, 24);
      expect(actualMnemonicModel.isValid, true);
    });
  });

  group('Tests of MnemonicModel.calculateSeed()', () {
    test('Should return valid seed for mnemonic with 12 words', () async {
      // @formatter:off
      // Arrange
      String actualMnemonicString = 'brave pair belt judge visual tunnel dinner siren dentist craft effort decrease';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Act
      Uint8List actualSeed = await actualMnemonicModel.calculateSeed();
      
      // Assert
      Uint8List expectedSeed = Uint8List.fromList(<int>[50, 50, 236, 255, 181, 6, 142, 209, 15, 62, 230, 26, 121, 64, 29, 140, 230, 202, 233, 72, 144, 243, 121, 8, 40, 255, 105, 106, 215, 130, 27, 160, 143, 210, 214, 28, 103, 135, 132, 183, 20, 95, 183, 221, 50, 112, 100, 208, 64, 12, 72, 187, 224, 72, 133, 177, 34, 179, 158, 145, 39, 0, 185, 30]);
      // @formatter:on

      expect(actualSeed, expectedSeed);
    });

    test('Should return valid seed for mnemonic with 15 words', () async {
      // @formatter:off
      // Arrange
      String actualMnemonicString = 'photo punch entry aspect plunge critic soon volcano mountain better easily middle diagram float brass';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Act
      Uint8List actualSeed = await actualMnemonicModel.calculateSeed();
      
      // Assert
      Uint8List expectedSeed = Uint8List.fromList(<int>[174, 94, 53, 82, 168, 214, 109, 59, 12, 24, 122, 165, 226, 44, 54, 117, 137, 40, 216, 231, 217, 229, 68, 255, 12, 75, 105, 249, 9, 144, 191, 69, 37, 9, 230, 186, 38, 86, 222, 95, 176, 85, 208, 19, 182, 51, 137, 10, 164, 173, 81, 247, 99, 34, 82, 120, 115, 216, 116, 239, 240, 16, 194, 182]);
      // @formatter:on

      expect(actualSeed, expectedSeed);
    });

    test('Should return valid seed for mnemonic with 18 words', () async {
      // @formatter:off
      // Arrange
      String actualMnemonicString = 'day swallow exclude gas calm baby random empower region motor unknown rural evolve begin uphold eternal over portion';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Act
      Uint8List actualSeed = await actualMnemonicModel.calculateSeed();

      // Assert
      Uint8List expectedSeed = Uint8List.fromList(<int>[58, 234, 146, 231, 210, 218, 157, 149, 178, 144, 104, 0, 61, 251, 97, 43, 101, 158, 82, 143, 193, 167, 70, 204, 241, 2, 97, 227, 102, 129, 178, 25, 139, 200, 135, 110, 147, 171, 41, 28, 15, 13, 220, 32, 101, 230, 179, 206, 224, 249, 61, 197, 153, 169, 170, 58, 63, 241, 61, 110, 183, 160, 240, 9]);
      // @formatter:on

      expect(actualSeed, expectedSeed);
    });

    test('Should return valid seed for mnemonic with 21 words', () async {
      // @formatter:off
      // Arrange
      String actualMnemonicString = 'trophy neutral craft leave angle client divide bag sheriff shell piece sponsor pipe clown tired wise normal roast off settle romance';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Act
      Uint8List actualSeed = await actualMnemonicModel.calculateSeed();
      
      // Assert
      Uint8List expectedSeed = Uint8List.fromList(<int>[4, 144, 182, 104, 159, 194, 71, 248, 194, 58, 69, 78, 53, 83, 2, 51, 16, 70, 11, 60, 146, 66, 22, 153, 47, 1, 248, 47, 183, 156, 221, 229, 190, 22, 167, 227, 136, 129, 157, 67, 107, 95, 201, 38, 225, 18, 7, 196, 31, 68, 216, 98, 222, 84, 107, 24, 105, 7, 105, 37, 218, 41, 197, 242]);
      // @formatter:on

      expect(actualSeed, expectedSeed);
    });

    test('Should return valid seed for mnemonic with 24 words', () async {
      // @formatter:off
      // Arrange
      String actualMnemonicString = 'try crouch outer budget write celery walk library river pelican train like truly spike capital history program actor bring open person target present tube';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonicString);

      // Act
      Uint8List actualSeed = await actualMnemonicModel.calculateSeed();
      
      // Assert
      Uint8List expectedSeed = Uint8List.fromList(<int>[139, 136, 223, 255, 41, 232, 189, 140, 5, 197, 113, 109, 207, 165, 220, 41, 249, 206, 112, 65, 208, 151, 11, 194, 123, 37, 73, 69, 214, 201, 223, 154, 87, 253, 140, 29, 66, 240, 183, 5, 145, 127, 64, 206, 39, 251, 69, 183, 61, 95, 131, 84, 223, 114, 166, 30, 215, 90, 37, 106, 221, 132, 153, 4]);
      // @formatter:on

      expect(actualSeed, expectedSeed);
    });
  });
}