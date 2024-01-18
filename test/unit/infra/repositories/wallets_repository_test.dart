import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  Map<String, String> filledWalletsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(
      <String, dynamic>{
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
      },
    ),
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{}),
  };

  Map<String, String> emptyDatabase = <String, String>{};

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
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
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
      String? actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
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
      });

      TestUtils.printInfo('Should [return Map of wallets] as ["wallets" key EXISTS] in database');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);

      // ************************************************************************************************

      // Act
      await actualWalletsRepository.save(actualUpdatedWalletEntity);
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
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
      });

      TestUtils.printInfo('Should [return Map of wallets] with updated wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
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
      String? actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedWalletsKeyValue = jsonEncode(<String, dynamic>{});

      TestUtils.printInfo('Should [return EMPTY map] as ["wallets" key value is EMPTY]');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);

      // ************************************************************************************************

      // Act
      await actualWalletsRepository.save(actualNewWalletEntity);
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
        '8b52e5f2-d265-41d5-8567-47e9f879bd02': <String, dynamic>{
          'index': 2,
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'name': 'New wallet',
        },
      });

      TestUtils.printInfo('Should [return Map of wallets] with new wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
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

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      String? actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as ["wallets" key NOT EXISTS] in database');
      expect(actualWalletsKeyValue, null);

      // ************************************************************************************************

      // Act
      await actualWalletsRepository.save(actualNewWalletEntity);
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
        '8b52e5f2-d265-41d5-8567-47e9f879bd02': <String, dynamic>{
          'index': 2,
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'name': 'New wallet',
        },
      });

      TestUtils.printInfo('Should [return Map of wallets] with new wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
    });
  });

  group('Tests of WalletsRepository.deleteById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsRepository actualWalletsRepository = WalletsRepository();

      // Act
      String? actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
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
      });

      TestUtils.printInfo('Should [return Map of wallets] as ["wallets" key EXISTS] in database');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);

      // ************************************************************************************************

      // Act
      await actualWalletsRepository.deleteById('4e66ba36-966e-49ed-b639-191388ce38de');
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
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
      });

      TestUtils.printInfo('Should [return Map of wallets] without removed wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
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