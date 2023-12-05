import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Aes256 {
  static String encrypt(String password, String decryptedString) {
    List<int> randomBytes = SecureRandom(16).bytes;

    List<int> hashedPasswordBytes = sha256.convert(utf8.encode(password)).bytes;
    List<int> securePasswordBytes = sha256.convert(randomBytes + hashedPasswordBytes).bytes;

    Key key = Key.fromBase64(base64Encode(hashedPasswordBytes));
    Encrypter encrypter = Encrypter(AES(key));

    Uint8List initializationVectorBytes = Uint8List.fromList(securePasswordBytes.getRange(0, 16).toList());
    IV initializationVector = IV(initializationVectorBytes);
    List<int> encryptedDataBytes = encrypter.encrypt(decryptedString, iv: initializationVector).bytes;

    List<int> checksumBytes = securePasswordBytes.getRange(securePasswordBytes.length - 4, securePasswordBytes.length).toList();
    List<int> encryptedStringBytes = randomBytes + encryptedDataBytes + checksumBytes;
    String encryptedString = base64Encode(encryptedStringBytes);
    return encryptedString;
  }

  static String decrypt(String password, String encryptedString) {
    List<int> hashedPasswordBytes = sha256.convert(utf8.encode(password)).bytes;

    List<int> encryptedStringBytes = base64Decode(encryptedString);
    List<int> randomBytes = encryptedStringBytes.getRange(0, 16).toList();
    List<int> encryptedDataBytes = encryptedStringBytes.getRange(16, encryptedStringBytes.length - 4).toList();
    List<int> securePasswordBytes = sha256.convert(randomBytes + hashedPasswordBytes).bytes;

    Key key = Key.fromBase64(base64Encode(hashedPasswordBytes));
    Encrypter encrypter = Encrypter(AES(key));

    Uint8List initializationVectorBytes = Uint8List.fromList(securePasswordBytes.getRange(0, 16).toList());
    IV initializationVector = IV(initializationVectorBytes);

    String decryptedString = encrypter.decrypt(Encrypted(Uint8List.fromList(encryptedDataBytes)), iv: initializationVector);
    return decryptedString;
  }

  static bool isPasswordValid(String password, String encryptedString) {
    List<int> hashedPasswordBytes = sha256.convert(utf8.encode(password)).bytes;

    List<int> encryptedStringBytes = base64Decode(encryptedString);
    List<int> randomBytes = encryptedStringBytes.getRange(0, 16).toList();
    List<int> expectedChecksumBytes = encryptedStringBytes.getRange(encryptedStringBytes.length - 4, encryptedStringBytes.length).toList();

    List<int> securePasswordBytes = sha256.convert(randomBytes + hashedPasswordBytes).bytes;
    List<int> actualChecksumBytes = securePasswordBytes.getRange(securePasswordBytes.length - 4, securePasswordBytes.length).toList();

    return actualChecksumBytes.toString() == expectedChecksumBytes.toString();
  }
}
