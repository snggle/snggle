import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'4k3KlhGTSoUehHhVcVFqBmtM4XUB4vJf8jpo2q7eP3Ij+CdOsprU3p9mzIO0S0/eT4dg1SHcJp4QprR+Do8Ez3QYkJCx1n0kztUIPt8ix3OGiIaBZcr8wtUkl0x7jHhUmN8el+o8uqPkNsBnkH3qXkyDmJyKbCmqpKTrETPzdYQeHfn5g3QU2eSVxPAwNHGyg+IKjB/9kve2FN9grGMB1/K0RyTswq5CiQtrlaD+AO07nekZu3vLWgaGn3c8WB/5CajAO5SgIBc+6LscWNeF8yuGDPr1qsoSI//nikln9RvSD9w+A979IYYpveme2kTrfBOPksWdzb05KUEUq3aKNkCyGAt9zN7s4XbqpP/BPd146Njypv+ujoD1wjqiVA9IFnMpYjV4HsWX5XzteyWqOatt22yheeX7ez8rw5fC58L1unhQuvPWp8f42zpRJhUbPPhoULVenqYrnZSRXlq+hYl0GpIiqSTIXNiGNQwOxbdeJBYWTABz7NnLyS1j757YIXjMN4c39MWz/764WkmPATziljPcBFMfOyVlaxhdVLLK8yzfNpURU7SYYMT+sVKHo/asMRE42nqbww42bOfe044BFzFw9moiBc+PSnfkIqkXdNgQCSnYhEgkhi/ZzzjHX7g02ab8rJcGvmoytmjoCkl5N5/Wb80HepIrgMalpLpU2nRHaBDoJ7dqoht5wjmHA1dWO916bV4AMqgVKu2JGQbqt+/dMVUryBI7cgWNQr56xYahrGtXXOxQYpIhTTpnT7PDX0gkc3OyKE2MeXC1MiOt1Qoe7y3WVVd35vSmhX+QGKNC3k2xt0BV/btFLrh549386X5Nol/85zjJPi+TlcXVrhG6J04lEj+JdES3pZ24hT88p4L45mbLf8emBF2baMFrdw/CHij/P/A9oK2bkkZ9sD7yJ+qu9423EyLpy9urWl8wNBbUB27ZTYPCZTWnzxvXBYUus+1GkHZ0W+bD36CYBZ/oqtm3n34L32HYactO/c2oDfTlbo+dTqBMFAWxmYa9ONv99EdrJGXbBv8lg1J44nPaQ76obblwObELtqqQMyOZckur1z5Q6MKXSaCGa6IFlXTqxl5lSVgHawQ2iGkaV68iYhK5WlOsASP3O30vZ5HhcxUhQRzCybY5iQDbOdBqABA1RMr26WAKfhKFabuHh37ItdcwIO6BFolsnnPtBFSGxsEr7i+K/kCdng9ubHwhHtC7M8goluNzLP3R+prLZx3H0K4zfD1mTbW3Ngr8rCmRmOULuSv/xysw4ejsWrpPXjNlJa7RSx71T/CWw9FPSpsZ4XiJnouFxxrll9+sVu+W',
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  group('Tests of WalletsService.getLastWalletIndex()', () {
    test('Should [return 1] if the largest wallet index for specified vault is equal 2', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      int actualLastWalletIndex = await actualWalletsService.getLastWalletIndex('04b5440e-e398-4520-9f9b-f0eea2d816e6');

      // Assert
      expect(actualLastWalletIndex, 1);
    });

    test('Should [return -1] as a default value (empty collection)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      int actualLastWalletIndex = await actualWalletsService.getLastWalletIndex('04b5440e-e398-4520-9f9b-f0eea2d816e6');

      // Assert
      expect(actualLastWalletIndex, -1);
    });
  });

  group('Tests of WalletsService.getWalletList()', () {
    test('Should [return List of WalletModel] assigned with specified vault if ["wallets" key HAS VALUES] ', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      List<WalletModel> actualWalletModelList = await actualWalletsService.getWalletList('04b5440e-e398-4520-9f9b-f0eea2d816e6');

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        WalletModel(
          index: 0,
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
        ),
        WalletModel(
          index: 1,
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
        ),
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return EMPTY list] if ["wallets" key is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      List<WalletModel> actualWalletModelList = await actualWalletsService.getWalletList('4e66ba36-966e-49ed-b639-191388ce38de');

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[];

      expect(actualWalletModelList, expectedWalletModelList);
    });
  });

  group('Tests of WalletsService.saveWallet()', () {
    test('Should [UPDATE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      WalletModel actualUpdatedWalletModel = WalletModel(
        index: 0,
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        name: 'Updated name',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'index': 0,
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
        }
      };

      TestUtils.printInfo('Should [return Map of wallets] as ["wallets" key EXISTS] in database');
      expect(actualWalletsMap, expectedWalletsMap);

      // ************************************************************************************************

      // Act
      await actualWalletsService.saveWallet(actualUpdatedWalletModel);
      actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'index': 0,
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'name': 'Updated name',
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
        }
      };

      TestUtils.printInfo('Should [return Map of wallets] with updated wallet');
      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [SAVE wallet] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      WalletModel actualNewWalletModel = WalletModel(
        index: 2,
        uuid: '8b52e5f2-d265-41d5-8567-47e9f879bd02',
        vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        address: 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
        derivationPath: "m/44'/118'/0'/0/2",
        name: 'New wallet',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{};

      TestUtils.printInfo('Should [return EMPTY map] as ["wallets" key value is EMPTY]');
      expect(actualWalletsMap, expectedWalletsMap);

      // ************************************************************************************************

      // Act
      await actualWalletsService.saveWallet(actualNewWalletModel);
      actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletsMap = <String, dynamic>{
        '8b52e5f2-d265-41d5-8567-47e9f879bd02': <String, dynamic>{
          'index': 2,
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'name': 'New wallet',
        },
      };

      TestUtils.printInfo('Should [return Map of wallets] with new wallet');
      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsService.deleteWalletById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'index': 0,
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
        }
      };

      TestUtils.printInfo('Should [return Map of wallets] as ["wallets" key EXISTS] in database');
      expect(actualWalletsMap, expectedWalletsMap);

      // ************************************************************************************************

      // Act
      await actualWalletsService.deleteWalletById('4e66ba36-966e-49ed-b639-191388ce38de');
      actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletsMap = <String, dynamic>{
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
        }
      };

      TestUtils.printInfo('Should [return Map of wallets] without removed wallet');
      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Assert
      expect(
        () => actualWalletsService.deleteWalletById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}