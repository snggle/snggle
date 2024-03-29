import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
      encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'WWn5m4f5r+veG0ZBsHTn+yfzYkexf1ClKj10Xjd1B6QJsgLpfRaltn33xLSCzRMJQze2ioV0BVhaHVafnDINIoi3jJIftfa1izjhxcVBDIrsAZsWCIzEXMIN2d2kq3FRH61PqlCTwRMcfYElXkZvxarH6SIypLNXsl/K25DMSma1zZgo+Pg5xgARaZV1PCE4XYlD2rkXRTFvvXABp5w+8VgHbd1G/opG3lwGKBETzsPOTUsnOrZ0PQg9mYSIt0WnVsewadKiMZY609Oh94l4txxNxG8cVA5G2jny9QqxDVflsIMx0m/XvjTmdSEBShz1ZLetgwSRPylFdfW+iBa4mTwro7joBJNI4xzXxslZkzNbwl9pPydxKBideN0JRI+RkE6znaug8j31wCkgp4knvCdGTB+Ycun6ZluqVwRYcVvKZhfv2Z7wWzPdTyVrZV6oC2i/O0IvYRFKWhO2DaTXWrWAqDxRKgt+S5dNzewERekZKqoL2t5SsReKRENy2PWNPfGMFRLAeD6HlGBRGimFjxUi43MLp+YXJluTSIqgOwrhNLbJ2sQT764nFVjB01s/w7PALek+X23Lb7zQ1+mOp6jjO+tU7nuziiUm+PCx5hKyzYDJIlWQOt5nWI/l6U4AxJ7K+ENOHyDYQY6JGasGXQxFc6EtqJW/3RJcZ18mxwwM3UEZrcw6tmyViBQCIAZeZmzOiqurpEMV93l51FVDSN3qYBW1LXel5dcFkd2i9QrPaqRjuKBLf8fLm0WWjT9QktoSSXonZzi0ItZaBpxUVMdv/2qiMG+3FbZtYXcnBnjOvdAZfzkiwTdYxmGerNZUUQsGPEVqMH7IIrt249v1rQaBl9KxYXYrW407iCDn4Fbth3MZjzancwFQjZPKtIFG08QKzT2Id48rBuLaXiDriznBbEq2Tw5cLxLWqsN2JYE0MeCOiwHMG3hmpCxWijtFrvK2WqtQIach1QUC6+n4MsgG3hEbsHMaKN9X1qJQE1gDcTNMsNzLlsCgXc5zJNjKETaVe42G+D1q4390KzTRfiHp43Rx7D9TtAXmzmjIYdUpxW5soMGrITziKumDYu1P/MiPI8lsK7IfVOj/dxcRC3Ni10NFFwlfJ6nHhiVyJiZ/4obwO8ZA/VJY5Uvh8iZU7Bqqo8i0+vTjpSJm9cp47bkGnKv0qzlIL9phx2e82OHK3gmt6XXHNayO7Gd95ipGn+15dpjGMTQEE9ZwOqPITddbDUmhfxU2lo2YotFX8R3PZL14IJsN+YCAhzrAJwMuEy20y0CiM54p7K9+hrxz/5mJd+VrJTLbWSFL1KgrnNPrJnSXlSeBC0AWr6Xj9Y+K+4FPtUs1rIKgkAHJhspxe4EilcCGBtwoyYdCr5ewUX1VnvFfRwF6frkPrXxQD3dkVD3Foge+P9OubTot5VKirMzgWDCNrxWn31sJW3E6DBvit5nSEz8pA7J5Kmk6/hzpppe6pNKo4cEbqdCxJoRw65Nk2FQ=',
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
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[
        const WalletEntity(
          pinnedBool: true,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
        const WalletEntity(
          pinnedBool: true,
          index: 1,
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
        const WalletEntity(
          pinnedBool: false,
          index: 0,
          address: 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          parentPath: '5f5332fb-37c1-4352-9153-d43692615f0f',
        ),
        const WalletEntity(
          pinnedBool: false,
          index: 1,
          address: 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          parentPath: '5f5332fb-37c1-4352-9153-d43692615f0f',
        ),
      ];

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
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
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
        pinnedBool: false,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
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
          'pinned': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
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
          'pinned': false,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'name': 'Updated name'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
        }
      };

      TestUtils.printInfo('Should [return Map of wallets] with updated wallet');
      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [SAVE wallet] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      WalletEntity actualNewWalletEntity = const WalletEntity(
        pinnedBool: false,
        index: 2,
        address: 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
        derivationPath: "m/44'/118'/0'/0/2",
        network: 'kira',
        uuid: '8b52e5f2-d265-41d5-8567-47e9f879bd02',
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
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
          'pinned': false,
          'index': 2,
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'network': 'kira',
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'name': 'New wallet'
        },
      };

      TestUtils.printInfo('Should [return Map of wallets] with new wallet');
      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [SAVE wallet] if ["wallets" key NOT EXISTS] in database', () async {
      // Arrange
      WalletEntity actualNewWalletEntity = const WalletEntity(
        pinnedBool: false,
        index: 2,
        address: 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
        derivationPath: "m/44'/118'/0'/0/2",
        network: 'kira',
        uuid: '8b52e5f2-d265-41d5-8567-47e9f879bd02',
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
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
          'pinned': false,
          'index': 2,
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'network': 'kira',
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'name': 'New wallet'
        }
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
          'pinned': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
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
          'pinned': true,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'parent_path': '5f5332fb-37c1-4352-9153-d43692615f0f'
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