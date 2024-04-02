import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '04b5440e-e398-4520-9f9b-f0eea2d816e6.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      '04b5440e-e398-4520-9f9b-f0eea2d816e6': <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'BEPaj2w7Fnj2+BlKhCsHK5aAifAgdm+ye4Eyx8apMOLci0SdTTp+/C9dJMszkcQ3SjqVsHUtJUXVKDZCWB28L+ooQb5hUKQeLIiGaO8B1pgY4KtLvV9P1JmjNy7TSDbdfH/ddpQ1Z60gm39vcDbhHMiCLU8rCrNeu3hhB9Tu2kkN+tBHjMn9rxwCuVnjIDjufAdzna8GXiF5yJTW6Nx6xW9zt0x0SyhPX4THfGd0QQIbVhQ1',
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee.snggle': 'NMKLbqOpoFWNsCYD0EcdnC1R0eRqRzkJhkdAVqVzporYJatt97PM4hWPJqzhAL+9ZKnlb6ek1AkKcvAGlAUNgJCeUPxj3gFf2SIoieOy8zeT4N76dZxk+Yo21ZUS8L+Zuh/u7VtMgzMN/s2Ooh71cUmOB2mWkMEuW0uZLnCtI6QJS1Ty6WWKrzcz1oEj7k+QGJsVwrDAyKZO9d8n8y5Iy0iAC/1M6OGqtbWfQrKA9sI4ErCu',
      },
      '5f5332fb-37c1-4352-9153-d43692615f0f.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
      '5f5332fb-37c1-4352-9153-d43692615f0f': <String, dynamic>{
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo'
      },
    },
  };

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'WWn5m4f5r+veG0ZBsHTn+yfzYkexf1ClKj10Xjd1B6QJsgLpfRaltn33xLSCzRMJQze2ioV0BVhaHVafnDINIoi3jJIftfa1izjhxcVBDIrsAZsWCIzEXMIN2d2kq3FRH61PqlCTwRMcfYElXkZvxarH6SIypLNXsl/K25DMSma1zZgo+Pg5xgARaZV1PCE4XYlD2rkXRTFvvXABp5w+8VgHbd1G/opG3lwGKBETzsPOTUsnOrZ0PQg9mYSIt0WnVsewadKiMZY609Oh94l4txxNxG8cVA5G2jny9QqxDVflsIMx0m/XvjTmdSEBShz1ZLetgwSRPylFdfW+iBa4mTwro7joBJNI4xzXxslZkzNbwl9pPydxKBideN0JRI+RkE6znaug8j31wCkgp4knvCdGTB+Ycun6ZluqVwRYcVvKZhfv2Z7wWzPdTyVrZV6oC2i/O0IvYRFKWhO2DaTXWrWAqDxRKgt+S5dNzewERekZKqoL2t5SsReKRENy2PWNPfGMFRLAeD6HlGBRGimFjxUi43MLp+YXJluTSIqgOwrhNLbJ2sQT764nFVjB01s/w7PALek+X23Lb7zQ1+mOp6jjO+tU7nuziiUm+PCx5hKyzYDJIlWQOt5nWI/l6U4AxJ7K+ENOHyDYQY6JGasGXQxFc6EtqJW/3RJcZ18mxwwM3UEZrcw6tmyViBQCIAZeZmzOiqurpEMV93l51FVDSN3qYBW1LXel5dcFkd2i9QrPaqRjuKBLf8fLm0WWjT9QktoSSXonZzi0ItZaBpxUVMdv/2qiMG+3FbZtYXcnBnjOvdAZfzkiwTdYxmGerNZUUQsGPEVqMH7IIrt249v1rQaBl9KxYXYrW407iCDn4Fbth3MZjzancwFQjZPKtIFG08QKzT2Id48rBuLaXiDriznBbEq2Tw5cLxLWqsN2JYE0MeCOiwHMG3hmpCxWijtFrvK2WqtQIach1QUC6+n4MsgG3hEbsHMaKN9X1qJQE1gDcTNMsNzLlsCgXc5zJNjKETaVe42G+D1q4390KzTRfiHp43Rx7D9TtAXmzmjIYdUpxW5soMGrITziKumDYu1P/MiPI8lsK7IfVOj/dxcRC3Ni10NFFwlfJ6nHhiVyJiZ/4obwO8ZA/VJY5Uvh8iZU7Bqqo8i0+vTjpSJm9cp47bkGnKv0qzlIL9phx2e82OHK3gmt6XXHNayO7Gd95ipGn+15dpjGMTQEE9ZwOqPITddbDUmhfxU2lo2YotFX8R3PZL14IJsN+YCAhzrAJwMuEy20y0CiM54p7K9+hrxz/5mJd+VrJTLbWSFL1KgrnNPrJnSXlSeBC0AWr6Xj9Y+K+4FPtUs1rIKgkAHJhspxe4EilcCGBtwoyYdCr5ewUX1VnvFfRwF6frkPrXxQD3dkVD3Foge+P9OubTot5VKirMzgWDCNrxWn31sJW3E6DBvit5nSEz8pA7J5Kmk6/hzpppe6pNKo4cEbqdCxJoRw65Nk2FQ=',
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  late WalletsService actualWalletsService;

  setUp(() {
    String testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    SecretsService actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    actualWalletsService = WalletsService(walletsRepository: WalletsRepository(), secretsService: actualSecretsService);
  });

  group('Tests of WalletsService.getLastWalletIndex()', () {
    test('Should [return 1] if the largest wallet index for specified vault is equal 2', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      int actualLastWalletIndex = await actualWalletsService.getLastWalletIndex('04b5440e-e398-4520-9f9b-f0eea2d816e6');

      // Assert
      expect(actualLastWalletIndex, 1);
    });

    test('Should [return -1] as a default value (empty collection)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

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

      // Act
      List<WalletModel> actualWalletModelList = await actualWalletsService.getWalletList('04b5440e-e398-4520-9f9b-f0eea2d816e6');

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        WalletModel(
          pinnedBool: true,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
        WalletModel(
          pinnedBool: true,
          index: 1,
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return EMPTY list] if ["wallets" key is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

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
      await actualWalletsService.saveWallet(actualUpdatedWalletModel);
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
      WalletModel actualNewWalletModel = WalletModel(
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

  group('Tests of WalletsService.deleteWalletById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

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
      await actualWalletsService.deleteWalletById('4e66ba36-966e-49ed-b639-191388ce38de');
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

      // Assert
      expect(
        () => actualWalletsService.deleteWalletById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsService.moveWallet()', () {
    test('Should [update WalletModel path] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

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
      await actualWalletsService.moveWallet(
        '4e66ba36-966e-49ed-b639-191388ce38de',
        ContainerPathModel.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/new/directory'),
      );

      actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletsKeyValue!);
      actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/new/directory',
          'name': null
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

      TestUtils.printInfo('Should [return Map of wallets] without removed wallet');
      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Assert
      expect(
        () => actualWalletsService.moveWallet(
          'not-existing-uuid',
          ContainerPathModel.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/new/directory'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsService.getById()', () {
    test('Should [return WalletModel] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      WalletModel actualWalletModel = await actualWalletsService.getById('4e66ba36-966e-49ed-b639-191388ce38de');

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      expect(actualWalletModel, expectedWalletModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Assert
      expect(
        () => actualWalletsService.getById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}