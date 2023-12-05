import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

class MasterKeyVO extends Equatable {
  final String _encryptedMasterKey;

  const MasterKeyVO({required String encryptedMasterKey}) : _encryptedMasterKey = encryptedMasterKey;

  // This method is used to generate a completely new [MasterKeyVO] from given [MnemonicModel].
  // It should only be used during the first app launch or when setting up a new password for the application.
  static Future<MasterKeyVO> create({required MnemonicModel mnemonicModel, required PasswordModel passwordModel}) async {
    Uint8List mnemonicSeed = await mnemonicModel.calculateSeed();
    Digest decryptedMasterKey = sha256.convert(mnemonicSeed);
    String decryptedMasterKeyHex = base64Encode(decryptedMasterKey.bytes);

    String encryptedMasterKey = passwordModel.encrypt(decryptedData: decryptedMasterKeyHex);
    return MasterKeyVO(encryptedMasterKey: encryptedMasterKey);
  }

  String get encryptedMasterKey => _encryptedMasterKey;

  String encrypt({required PasswordModel appPasswordModel, required String decryptedData}) {
    String decryptedMasterKey = appPasswordModel.decrypt(encryptedData: _encryptedMasterKey);
    return Aes256.encrypt(decryptedMasterKey, decryptedData);
  }

  String decrypt({required PasswordModel appPasswordModel, required String encryptedData}) {
    String decryptedMasterKey = appPasswordModel.decrypt(encryptedData: _encryptedMasterKey);
    try {
      return Aes256.decrypt(decryptedMasterKey, encryptedData);
    } catch (e) {
      throw ArgumentError('Provided password is valid, but cannot decrypt data using MasterKey');
    }
  }

  @override
  List<Object?> get props => <Object?>[_encryptedMasterKey];
}
