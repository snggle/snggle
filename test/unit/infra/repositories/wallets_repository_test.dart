import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
      encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'4k3KlhGTSoUehHhVcVFqBmtM4XUB4vJf8jpo2q7eP3Ij+CdOsprU3p9mzIO0S0/eT4dg1SHcJp4QprR+Do8Ez3QYkJCx1n0kztUIPt8ix3OGiIaBZcr8wtUkl0x7jHhUmN8el+o8uqPkNsBnkH3qXkyDmJyKbCmqpKTrETPzdYQeHfn5g3QU2eSVxPAwNHGyg+IKjB/9kve2FN9grGMB1/K0RyTswq5CiQtrlaD+AO07nekZu3vLWgaGn3c8WB/5CajAO5SgIBc+6LscWNeF8yuGDPr1qsoSI//nikln9RvSD9w+A979IYYpveme2kTrfBOPksWdzb05KUEUq3aKNkCyGAt9zN7s4XbqpP/BPd146Njypv+ujoD1wjqiVA9IFnMpYjV4HsWX5XzteyWqOatt22yheeX7ez8rw5fC58L1unhQuvPWp8f42zpRJhUbPPhoULVenqYrnZSRXlq+hYl0GpIiqSTIXNiGNQwOxbdeJBYWTABz7NnLyS1j757YIXjMN4c39MWz/764WkmPATziljPcBFMfOyVlaxhdVLLK8yzfNpURU7SYYMT+sVKHo/asMRE42nqbww42bOfe044BFzFw9moiBc+PSnfkIqkXdNgQCSnYhEgkhi/ZzzjHX7g02ab8rJcGvmoytmjoCkl5N5/Wb80HepIrgMalpLpU2nRHaBDoJ7dqoht5wjmHA1dWO916bV4AMqgVKu2JGQbqt+/dMVUryBI7cgWNQr56xYahrGtXXOxQYpIhTTpnT7PDX0gkc3OyKE2MeXC1MiOt1Qoe7y3WVVd35vSmhX+QGKNC3k2xt0BV/btFLrh549386X5Nol/85zjJPi+TlcXVrhG6J04lEj+JdES3pZ24hT88p4L45mbLf8emBF2baMFrdw/CHij/P/A9oK2bkkZ9sD7yJ+qu9423EyLpy9urWl8wNBbUB27ZTYPCZTWnzxvXBYUus+1GkHZ0W+bD36CYBZ/oqtm3n34L32HYactO/c2oDfTlbo+dTqBMFAWxmYa9ONv99EdrJGXbBv8lg1J44nPaQ76obblwObELtqqQMyOZckur1z5Q6MKXSaCGa6IFlXTqxl5lSVgHawQ2iGkaV68iYhK5WlOsASP3O30vZ5HhcxUhQRzCybY5iQDbOdBqABA1RMr26WAKfhKFabuHh37ItdcwIO6BFolsnnPtBFSGxsEr7i+K/kCdng9ubHwhHtC7M8goluNzLP3R+prLZx3H0K4zfD1mTbW3Ngr8rCmRmOULuSv/xysw4ejsWrpPXjNlJa7RSx71T/CWw9FPSpsZ4XiJnouFxxrll9+sVu+W',
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  group('Tests of WalletsRepository.getAll()', () {
    test('Should [return List of WalletEntity] if ["wallets" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      List<WalletEntity> actualWalletEntityList = await actualWalletsRepository.getAll();

      // Assert
      // @formatter:off
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[
        const WalletEntity(index: 0, uuid: '4e66ba36-966e-49ed-b639-191388ce38de', vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6', address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np', derivationPath: "m/44'/118'/0'/0/0"),
        const WalletEntity(index: 1, uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee', vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6', address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn', derivationPath: "m/44'/118'/0'/0/1"),
        const WalletEntity(index: 0, uuid: '4d02947e-c838-4a77-bef3-0ffbdb1c7525', vaultUuid: '5f5332fb-37c1-4352-9153-d43692615f0f', address: 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', derivationPath: "m/44'/118'/0'/0/0"),
        const WalletEntity(index: 1, uuid: 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b', vaultUuid: '5f5332fb-37c1-4352-9153-d43692615f0f', address: 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl', derivationPath: "m/44'/118'/0'/0/1"),
      ];
      // @formatter:on

      expect(actualWalletEntityList, expectedWalletEntityList);
    });

    test('Should [return EMPTY list] if ["wallets" key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      List<WalletEntity> actualWalletEntityList = await actualWalletsRepository.getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });

    test('Should [return EMPTY list] if ["wallets" key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      List<WalletEntity> actualWalletEntityList = await actualWalletsRepository.getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });
  });

  group('Tests of WalletsRepository.getById()', () {
    test('Should [return WalletEntity] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      WalletEntity actualWalletEntity = await actualWalletsRepository.getById('4e66ba36-966e-49ed-b639-191388ce38de');

      // Assert
      WalletEntity expectedWalletEntity = const WalletEntity(
        index: 0,
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
      );

      expect(actualWalletEntity, expectedWalletEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Assert
      expect(
        () => actualWalletsRepository.getById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsRepository.save()', () {
    test('Should [UPDATE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      WalletEntity actualUpdatedWalletEntity = const WalletEntity(
        index: 0,
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        name: 'Updated name',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

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
      await actualWalletsRepository.save(actualUpdatedWalletEntity);
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
      WalletEntity actualNewWalletEntity = const WalletEntity(
        index: 2,
        uuid: '8b52e5f2-d265-41d5-8567-47e9f879bd02',
        vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        address: 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
        derivationPath: "m/44'/118'/0'/0/2",
        name: 'New wallet',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

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
      await actualWalletsRepository.save(actualNewWalletEntity);
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

    test('Should [SAVE wallet] if ["wallets" key NOT EXISTS] in database', () async {
      // Arrange
      WalletEntity actualNewWalletEntity = const WalletEntity(
        index: 2,
        uuid: '8b52e5f2-d265-41d5-8567-47e9f879bd02',
        vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        address: 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
        derivationPath: "m/44'/118'/0'/0/2",
        name: 'New wallet',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as ["wallets" key NOT EXISTS] in database');
      expect(actualEncryptedWalletsKeyValue, null);

      // ************************************************************************************************

      // Act
      await actualWalletsRepository.save(actualNewWalletEntity);
      actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
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

  group('Tests of WalletsRepository.deleteById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

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
      await actualWalletsRepository.deleteById('4e66ba36-966e-49ed-b639-191388ce38de');
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
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Assert
      expect(
        () => actualWalletsRepository.deleteById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}