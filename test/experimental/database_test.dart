import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:snuggle/shared/models/address_model.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip32.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';
import 'package:snuggle/shared/utils/crypto/secp256k1.dart';
import 'package:snuggle/shared/utils/crypto/sha256.dart';
import 'package:snuggle/shared/utils/storage_manager.dart';

import '../utils/test_utils.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  ////////////// MASTER KEY ///////////////
  // 1. Create master mnemonic
  MnemonicModel masterMnemonicModel = MnemonicModel.fromString(
      'nature light entire memory garden ostrich bottom ensure brand fantasy curtain coast also solve cannon wealth hole quantum fantasy purchase check drift cloth ecology');

  // 2. Create master seed from master mnemonic
  Uint8List masterSeed = await Bip39.mnemonicToSeed(mnemonic: masterMnemonicModel.value);

  // 3. Create hash / fingerprint from master seed. Is is used to encrypt all database
  String masterSeedHash = HEX.encode(Sha256.encrypt(HEX.encode(masterSeed)).bytes);

  // 4. Master seed is stored in database encrypted with AES256
  //    Master seed is encrypted using pin encrypted with SHA256
  String masterPin = '0000';
  String masterPinHash = HEX.encode(Sha256.encrypt(masterPin).bytes);
  String encryptedMasterSeedHash = Aes256.encrypt(masterPinHash, masterSeedHash);

  // 5. Print master seed details
  TestUtils.printInfo('Master seed details:');
  TestUtils.printTitle('Mnemonic: ', masterMnemonicModel.value);
  TestUtils.printTitle('Seed: ', HEX.encode(masterSeed));
  TestUtils.printTitle('Seed hash: ', HEX.encode(masterSeed));
  TestUtils.printTitle('Pin: ', masterPin);
  TestUtils.printTitle('Pin hash: ', masterPinHash);
  TestUtils.printTitle('Encrypted seed hash: ', encryptedMasterSeedHash);

  ////////////// VAULT //////////////

  // 1. Create mnemonic for vault
  MnemonicModel vaultMnemonicModel = MnemonicModel.fromString(
      'require point property company tongue busy bench burden caution gadget knee glance thought bulk assist month cereal report quarter tool section often require shield');

  // 2. Create vault seed from mnemonic
  Uint8List vaultSeed = await Bip39.mnemonicToSeed(mnemonic: vaultMnemonicModel.value);

  // 2. Create "secrets" object for vault
  //    Secrets object is encrypted using pin encrypted with SHA256
  String vaultPin = '1234';
  String vaultPinHash = HEX.encode(Sha256.encrypt(vaultPin).bytes);

  Map<String, dynamic> vaultSecrets = <String, dynamic>{'seed': vaultSeed};
  String vaultSecretsHash = Aes256.encrypt(vaultPinHash, jsonEncode(vaultSecrets));

  // 5. Print vault details
  TestUtils.printInfo('Vault details:');
  TestUtils.printTitle('Mnemonic: ', vaultMnemonicModel.value);
  TestUtils.printTitle('Seed: ', HEX.encode(vaultSeed));
  TestUtils.printTitle('Pin: ', vaultPin);
  TestUtils.printTitle('Pin hash: ', vaultPinHash);
  TestUtils.printTitle('Secrets: ', jsonEncode(vaultSecrets));
  TestUtils.printTitle('Secrets hash: ', vaultSecretsHash);

  ////////////// WALLET 1 //////////////
  // 1. Define wallet derivation path
  String walletDerivationPath1 = "m/44'/118'/0'/0/0";

  // 2. Generate wallet private key
  Uint8List walletPrivateKeyBytes1 = await Bip32.derivePrivateKey(mnemonicModel: vaultMnemonicModel, derivationPath: walletDerivationPath1);

  // 3. Generate wallet public key
  Uint8List walletPublicKeyBytes1 = Secp256k1.privateKeyBytesToPublic(walletPrivateKeyBytes1);

  // 4. Generate wallet address
  AddressModel walletAddressModel1 = AddressModel.fromPublicKey(walletPublicKeyBytes1, bech32Hrp: 'kira');

  // 5. Create "secrets" object for wallet
  //    Secrets object is encrypted using pin encrypted with SHA256
  String walletPin1 = '8399';
  String walletPinHash1 = HEX.encode(Sha256.encrypt(walletPin1).bytes);

  Map<String, dynamic> walletSecrets1 = <String, dynamic>{'private_key': walletPrivateKeyBytes1};
  String walletSecretsHash1 = Aes256.encrypt(walletPinHash1, jsonEncode(walletSecrets1));
  String walletSecretsHashWithVault1 = Aes256.encrypt(vaultPin, walletSecretsHash1);

  // 6. Print wallet1 details
  TestUtils.printInfo('Wallet1 details:');
  TestUtils.printTitle('Derivation key: ', walletDerivationPath1);
  TestUtils.printTitle('Private key: ', HEX.encode(walletPrivateKeyBytes1));
  TestUtils.printTitle('Public key: ', HEX.encode(walletPublicKeyBytes1));
  TestUtils.printTitle('Address: ', walletAddressModel1.bech32Address);
  TestUtils.printTitle('Secrets: ', jsonEncode(walletSecrets1));
  TestUtils.printTitle('Secrets hash: ', walletSecretsHash1);
  TestUtils.printTitle('Secrets hash with vault hash: ', walletSecretsHashWithVault1);

  ////////////// WALLET 2 //////////////
  // 1. Define wallet derivation path
  String walletDerivationPath2 = "m/44'/118'/0'/0/1";

  // 2. Generate wallet private key
  Uint8List walletPrivateKeyBytes2 = await Bip32.derivePrivateKey(mnemonicModel: vaultMnemonicModel, derivationPath: walletDerivationPath2);

  // 3. Generate wallet public key
  Uint8List walletPublicKeyBytes2 = Secp256k1.privateKeyBytesToPublic(walletPrivateKeyBytes2);

  // 4. Generate wallet address
  AddressModel walletAddressModel2 = AddressModel.fromPublicKey(walletPublicKeyBytes2, bech32Hrp: 'kira');

  // 5. Create "secrets" object for wallet
  //    Secrets object is encrypted using pin encrypted with SHA256
  String walletPin2 = '8399';
  String walletPinHash2 = HEX.encode(Sha256.encrypt(walletPin2).bytes);

  Map<String, dynamic> walletSecrets2 = <String, dynamic>{'private_key': walletPrivateKeyBytes2};
  String walletSecretsHash2 = Aes256.encrypt(walletPinHash2, jsonEncode(walletSecrets2));
  String walletSecretsHashWithVault2 = Aes256.encrypt(vaultPin, walletSecretsHash2);

  // 6. Print wallet1 details
  TestUtils.printInfo('Wallet2 details:');
  TestUtils.printTitle('Derivation key: ', walletDerivationPath2);
  TestUtils.printTitle('Private key: ', HEX.encode(walletPrivateKeyBytes2));
  TestUtils.printTitle('Public key: ', HEX.encode(walletPublicKeyBytes2));
  TestUtils.printTitle('Address: ', walletAddressModel2.bech32Address);
  TestUtils.printTitle('Secrets: ', jsonEncode(walletSecrets2));
  TestUtils.printTitle('Secrets hash: ', walletSecretsHash2);
  TestUtils.printTitle('Secrets hash with vault hash: ', walletSecretsHashWithVault2);

  ////////////// VAULTS COLLECTION //////////////
  // 1. Prepare database structure
  Map<String, dynamic> vaultsCollection = <String, dynamic>{
    '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
      'id': '92b43ace-5439-4269-8e27-e999907f4379',
      'name': 'Test Vault',
      'secrets': <String, dynamic>{
        'status': 'encrypted',
        'hash':
            '+aVBHyOzz5uKAaP16/KH7qXL9t5JULJqMDnrlqn9sx/dmrTo2lcJ1DIlUPXgBUaQ/zqZ0HAF877ZLfnwTVLre5xbc7c0iuMUtKpRcyiyLkRC7tMudvzhybwD5Sd14WfXAXQjRB2u+71vA4zNV4z/FT11sIZyqHYUCYB/zJqXjRwFj+NiMCMoc0Go3JJBA/HtMPaH+J1OBQUp58br3f0cwv/GDpjkFe7bw+P9igSWQduIohFZ8lOpbRNrsqbFu00t9EMijqO02AMBcnlUITuv4KSZKHO9wezuFAql2zeZ5dZK/OBHLu5pvjEONDx3LTXsBCUo6zEk5UcedNnj3S23TvchoXNSEn2Flf55ZA0947H86bRs',
      },
      'wallets': <String, dynamic>{
        'c3dfa23d-df27-4902-bf35-eb105dd4d11b': <String, dynamic>{
          'id': 'c3dfa23d-df27-4902-bf35-eb105dd4d11b',
          'name': 'Test Wallet1',
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'secrets': <String, dynamic>{
            'status': 'encrypted',
            'hash':
                'qDzuWBFHwllmji1AIEHRyszWYF8xZC49bc8PARu8DYv151YAQB82EZC1ke3oitdvGBZdxDcUpwESTpEv9p1kCtVrsLRLrlgCXEz2xGgipcpJ1rj503qeBohf4l5nv4u5Cy/xdPEwjtvHMMzhOyKooLp9H/6xCz37AodTQKMIwqcBrwUmMAzgdbCJxas7G0tn+1KWiw+c3wuZvXacUwoVTZ1rm7jIKHTTbWmQl0tfz0Qn1UZ4HHeoj/TDl8/X0mYou9IOFE0jboSdU0zg6lvKsynWyvvvDQDmAOhkvQqz0en2FsVo',
          },
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'id': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'address': 'kira1t92ph5puhuqw7pmda3r98avruqat9xxu4rne4a',
          'name': 'Test Wallet2',
          'secrets': <String, dynamic>{
            'status': 'encrypted',
            'hash':
                'ULC8F8b67eFgYOiERyNVBnfiVoRda1TKjePG6wZER/kephgervTRko2PbB2j60sQrHzKrxb5SVDFzGVieRI5Hc/0MWJqA8FLH9USZtmmCCiIYbIsiPBR+ySATVjpvL4JSiH8NipRuylmwvyDnQg2dsIt/lUyqikHjmCk+k6EZn97Bmp77QEjCpNUMx3GeHQQe2ZDLrrODHXg0Dv0WDVfcOgBaFU1IRVbHer8lzzO+mTz7/Q/I4zvgEonY9LXrvljPlxnFFEY0zLnix6l262HHevENvauRLVSZlulbA2Iryvm9EUzdo6SloIC6D2SXU5T4iPm/A==',
          },
        }
      },
    }
  };

  // 2. Parse database map to String
  String vaultsDatabaseString = jsonEncode(vaultsCollection);

  // 3. Encrypt database with master pin. That value will be stored in the database (flutter_secure_storage)
  String vaultsDatabaseHash = Aes256.encrypt(masterSeedHash, vaultsDatabaseString);

  // 4. Print vaults database details
  TestUtils.printInfo('Vaults database details: ');
  TestUtils.printTitle('Database string: ', vaultsDatabaseString);
  TestUtils.printTitle('Database hash: ', vaultsDatabaseHash);

  Map<String, dynamic> sampleConfig = <String, dynamic>{
    'dark_mode': true,
    'lang': 'PL',
  };
  StorageManager storageManager = StorageManager();
  await storageManager.write(key: 'master_seed', data: encryptedMasterSeedHash);
  await storageManager.write(key: 'vaults', data: vaultsDatabaseHash);
  await storageManager.write(key: 'config', data: jsonEncode(sampleConfig));

  TestUtils.printInfo('Show database');
  Map<String, String> database = await storageManager.readAll();
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String prettyDatabase = encoder.convert(jsonEncode(database));
  print(prettyDatabase);
}
