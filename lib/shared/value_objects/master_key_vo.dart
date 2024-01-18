import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class MasterKeyVO extends Equatable {
  final Ciphertext _masterKeyCiphertext;

  const MasterKeyVO({required Ciphertext masterKeyCiphertext}) : _masterKeyCiphertext = masterKeyCiphertext;

  String getDecrypted(PasswordModel passwordModel) {
    String decryptedMasterKey = passwordModel.decrypt(ciphertext: _masterKeyCiphertext);
    return decryptedMasterKey;
  }

  // This method is used to generate a completely new [MasterKeyVO] from given [MnemonicModel].
  // It should only be used during the first app launch or when setting up a new password for the application.
  static Future<MasterKeyVO> create({required MnemonicModel mnemonicModel, required PasswordModel passwordModel}) async {
    Uint8List mnemonicSeed = await mnemonicModel.calculateSeed();
    Digest decryptedMasterKey = sha256.convert(mnemonicSeed);
    String decryptedMasterKeyHex = base64Encode(decryptedMasterKey.bytes);

    Ciphertext masterKeyCiphertext = passwordModel.encrypt(decryptedData: decryptedMasterKeyHex);
    return MasterKeyVO(masterKeyCiphertext: masterKeyCiphertext);
  }

  Ciphertext get masterKeyCiphertext => _masterKeyCiphertext;

  Ciphertext encrypt({required PasswordModel appPasswordModel, required String plaintextValue}) {
    String decryptedMasterKey = appPasswordModel.decrypt(ciphertext: _masterKeyCiphertext);
    return AESDHKEV1().encrypt(decryptedMasterKey, plaintextValue);
  }

  String decrypt({required PasswordModel appPasswordModel, required Ciphertext ciphertext}) {
    String decryptedMasterKey = appPasswordModel.decrypt(ciphertext: _masterKeyCiphertext);
    try {
      return AESDHKEV1().decrypt(decryptedMasterKey, ciphertext);
    } catch (e) {
      throw ArgumentError('Provided password is valid, but cannot decrypt data using MasterKey');
    }
  }

  @override
  List<Object?> get props => <Object?>[_masterKeyCiphertext];
}
