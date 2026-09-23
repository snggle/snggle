import 'dart:convert';
import 'dart:math';

import 'package:cryptography_utils/cryptography_utils.dart';

class Sip2GeneratedPassword {
  final String password;
  final int randomCharacterCount;
  final int checksumCharacterCount;

  const Sip2GeneratedPassword({
    required this.password,
    required this.randomCharacterCount,
    required this.checksumCharacterCount,
  });
}

class Sip2PasswordGenerator {
  static const String characterSet = '!+-0123456789=@ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  static const int _bitsPerChecksumCharacter = 6;
  static const int _byteBitLength = 8;
  static const int _checksumCharacterMask = 0x3f;
  static const int _hashWindowBitLength = 16;
  static const int _maxPasswordLengthWithOneChecksumCharacter = 20;

  final Random random;

  Sip2PasswordGenerator({
    required this.random,
  });

  Sip2GeneratedPassword generate(int passwordLength) {
    int checksumCharacterCount = _getChecksumCharacterCount(passwordLength);
    int randomCharacterCount = max(0, passwordLength - checksumCharacterCount);
    String randomPassword = _generateRandomPassword(randomCharacterCount);
    String checksum = _calculateChecksum(randomPassword, checksumCharacterCount);

    return Sip2GeneratedPassword(
      password: '$randomPassword$checksum',
      randomCharacterCount: randomCharacterCount,
      checksumCharacterCount: checksumCharacterCount,
    );
  }

  static int _getChecksumCharacterCount(int passwordLength) {
    if (passwordLength <= 0) {
      // TODO(Kamil): Exception?
      return 0;
    }
    if (passwordLength <= _maxPasswordLengthWithOneChecksumCharacter) {
      return 1;
    }
    return 2;
  }

  static String _calculateChecksum(String randomPassword, int checksumCharacterCount) {
    if (checksumCharacterCount <= 0) {
      return '';
    }

    List<int> hashBytes = Sha256().convert(utf8.encode(randomPassword)).byteList;
    StringBuffer checksumStringBuffer = StringBuffer();

    for (int checksumCharacterIndex = 0; checksumCharacterIndex < checksumCharacterCount; checksumCharacterIndex++) {
      int checksumCharacterValue = _readSixBitValue(hashBytes, checksumCharacterIndex);
      checksumStringBuffer.write(characterSet[checksumCharacterValue]);
    }

    return checksumStringBuffer.toString();
  }

  String _generateRandomPassword(int randomCharacterCount) {
    StringBuffer passwordStringBuffer = StringBuffer();

    for (int characterIndex = 0; characterIndex < randomCharacterCount; characterIndex++) {
      passwordStringBuffer.write(
        characterSet[random.nextInt(characterSet.length)],
      );
    }

    return passwordStringBuffer.toString();
  }

  static int _readSixBitValue(List<int> bytes, int checksumCharacterIndex) {
    int bitOffset = checksumCharacterIndex * _bitsPerChecksumCharacter;
    int byteOffset = bitOffset ~/ _byteBitLength;
    int bitOffsetInWindow = bitOffset - (byteOffset * _byteBitLength);
    int hashWindow = (bytes[byteOffset] << _byteBitLength) | bytes[byteOffset + 1];
    int rightShift = _hashWindowBitLength - bitOffsetInWindow - _bitsPerChecksumCharacter;

    return (hashWindow >> rightShift) & _checksumCharacterMask;
  }
}
