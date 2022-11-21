import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/bip32.dart';

void main() {
  group('Tests of Bip32.derivePrivateKey()', () {
    test('Should return derived private key for mnemonic with 12 words', () async {
      // @formatter:off
      // Arrange
      String actualDerivationPath = "m/44'/118'/0'/0/0";
      String actualMnemonic = 'brave pair belt judge visual tunnel dinner siren dentist craft effort decrease';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonic);
      
      // Act
      Uint8List actualPrivateKey = await Bip32.derivePrivateKey( mnemonicModel: actualMnemonicModel, derivationPath: actualDerivationPath);
      
      // Assert
      Uint8List expectedPrivateKey = Uint8List.fromList(<int>[34, 49, 131, 248, 99, 191, 215, 222, 55, 66, 120, 134, 13, 184, 225, 248, 177, 211, 170, 64, 142, 104, 97, 217, 214, 204, 10, 172, 69, 43, 39, 210]);
      // @formatter:on
      
      expect(actualPrivateKey, expectedPrivateKey);
    });

    test('Should return derived private key for mnemonic with 15 words', () async {
      // @formatter:off
      // Arrange
      String actualDerivationPath = "m/44'/118'/0'/0/0";
      String actualMnemonic = 'photo punch entry aspect plunge critic soon volcano mountain better easily middle diagram float brass';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonic);

      // Act
      Uint8List actualPrivateKey = await Bip32.derivePrivateKey( mnemonicModel: actualMnemonicModel, derivationPath: actualDerivationPath);

      // Assert
      Uint8List expectedPrivateKey = Uint8List.fromList(<int>[30, 168, 252, 19, 190, 219, 207, 55, 158, 195, 68, 211, 21, 125, 35, 109, 29, 113, 8, 51, 244, 66, 35, 203, 31, 9, 46, 59, 67, 21, 238, 77]);
      // @formatter:on

      expect(actualPrivateKey, expectedPrivateKey);
    });

    test('Should return derived private key for mnemonic with 18 words', () async {
      // @formatter:off
      // Arrange
      String actualDerivationPath = "m/44'/118'/0'/0/0";
      String actualMnemonic = 'day swallow exclude gas calm baby random empower region motor unknown rural evolve begin uphold eternal over portion';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonic);

      // Act
      Uint8List actualPrivateKey = await Bip32.derivePrivateKey( mnemonicModel: actualMnemonicModel, derivationPath: actualDerivationPath);

      // Assert
      Uint8List expectedPrivateKey = Uint8List.fromList(<int>[106, 81, 93, 31, 16, 250, 185, 202, 91, 160, 78, 190, 249, 21, 105, 22, 227, 28, 192, 125, 29, 212, 210, 37, 90, 196, 145, 247, 136, 2, 22, 246]);
      // @formatter:on

      expect(actualPrivateKey, expectedPrivateKey);
    });

    test('Should return derived private key for mnemonic with 21 words', () async {
      // @formatter:off
      // Arrange
      String actualDerivationPath = "m/44'/118'/0'/0/0";
      String actualMnemonic = 'trophy neutral craft leave angle client divide bag sheriff shell piece sponsor pipe clown tired wise normal roast off settle romance';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonic);

      // Act
      Uint8List actualPrivateKey = await Bip32.derivePrivateKey( mnemonicModel: actualMnemonicModel, derivationPath: actualDerivationPath);

      // Assert
      Uint8List expectedPrivateKey = Uint8List.fromList(<int>[178, 151, 52, 243, 53, 1, 224, 218, 160, 139, 144, 13, 130, 28, 237, 214, 98, 64, 10, 126, 108, 155, 130, 211, 186, 135, 145, 15, 125, 174, 19, 183]);
      // @formatter:on

      expect(actualPrivateKey, expectedPrivateKey);
    });

    test('Should return derived private key for mnemonic with 24 words', () async {
      // @formatter:off
      // Arrange
      String actualDerivationPath = "m/44'/118'/0'/0/0";
      String actualMnemonic = 'try crouch outer budget write celery walk library river pelican train like truly spike capital history program actor bring open person target present tube';
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString(actualMnemonic);

      // Act
      Uint8List actualPrivateKey = await Bip32.derivePrivateKey( mnemonicModel: actualMnemonicModel, derivationPath: actualDerivationPath);

      // Assert
      Uint8List expectedPrivateKey = Uint8List.fromList(<int>[242, 167, 218, 7, 140, 163, 102, 207, 161, 162, 244, 57, 102, 6, 210, 94, 248, 91, 215, 104, 26, 223, 26, 30, 42, 170, 28, 10, 13, 225, 25, 181]);
      // @formatter:on

      expect(actualPrivateKey, expectedPrivateKey);
    });
  });
}
