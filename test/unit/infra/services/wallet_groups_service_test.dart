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
import 'package:snggle/infra/repositories/wallet_groups_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallet_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.walletGroups;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '04b5440e-e398-4520-9f9b-f0eea2d816e6.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      '04b5440e-e398-4520-9f9b-f0eea2d816e6': <String, dynamic>{
        '7f0e30fa-4464-4c86-a42b-4819fb085125.snggle': 'JN/Ts+wctmDCObc2li1P37On0RVV8nx0YxD4rLxS5FvSxhbMwe55zUAfHoKxKaIr9BtZqTWGIrgP/nAYSeEIfKvui64Tv/BUL/0qST93icgXzyTBRRsOiqAHBTc7Cvb4jCUcdPYiy7wpK0Ti1lmTqTTUch6YcOoQgFsI06KzHVUnqwXNR8laTd4E6lE0dW+b8GJnXgX8FYETjsyMj8+0VfjC0EPhdumBK0evWY1IufbW4NK3/4U22RJelyuD+GArsaBxCZKJYhm2O8TtaqZ3MvX0wk+erKlKtW2E5KQo0+jLKr672wLuVqQ+EzTWtIb7GzoEDeo/ndZV8E3BzLQltusZzO4Nqm1kLl0Kt8PLx9d+85N6',
        '7f0e30fa-4464-4c86-a42b-4819fb085125': <String, dynamic>{
          '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'BEPaj2w7Fnj2+BlKhCsHK5aAifAgdm+ye4Eyx8apMOLci0SdTTp+/C9dJMszkcQ3SjqVsHUtJUXVKDZCWB28L+ooQb5hUKQeLIiGaO8B1pgY4KtLvV9P1JmjNy7TSDbdfH/ddpQ1Z60gm39vcDbhHMiCLU8rCrNeu3hhB9Tu2kkN+tBHjMn9rxwCuVnjIDjufAdzna8GXiF5yJTW6Nx6xW9zt0x0SyhPX4THfGd0QQIbVhQ1',
          '3e7f3547-d78f-4dda-a916-3e9eabd4bfee.snggle': 'NMKLbqOpoFWNsCYD0EcdnC1R0eRqRzkJhkdAVqVzporYJatt97PM4hWPJqzhAL+9ZKnlb6ek1AkKcvAGlAUNgJCeUPxj3gFf2SIoieOy8zeT4N76dZxk+Yo21ZUS8L+Zuh/u7VtMgzMN/s2Ooh71cUmOB2mWkMEuW0uZLnCtI6QJS1Ty6WWKrzcz1oEj7k+QGJsVwrDAyKZO9d8n8y5Iy0iAC/1M6OGqtbWfQrKA9sI4ErCu',
        }
      },
      '5f5332fb-37c1-4352-9153-d43692615f0f.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
      '5f5332fb-37c1-4352-9153-d43692615f0f': <String, dynamic>{
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo'
      },
    },
  };

  Map<String, String> filledWalletGroupsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'6jzcZqsbTvXBniGZD/H4NXvnePv5J8Qp2h66Tiaiuat3VoHlOH8qZedSBdXHu7fvIeejFANAGim6oKMH1ahsjm7sQcnnMhU7LFOK6M4tbbJEBlevRP0Ds4l8janmKWsPyMh/7tiB38luWr/ekyz2PJZPhjf2EMuW/4KUt7c/G/iWrP883wSYZqb3G1uHdfBvB+4EyvSqqOFw35KRJLQKUEfC8MRg+PnoDOJq/ShlfixUojka2t3RRHh6JuRBjwAbixduVUokq+SpbpnNRxHgTIWQaSKQTYB/L9QEak7pmC8KHq56oI5E2gtW7wbhntW6SMljeAUcH7tAzSCCgIGeWTgznrISZO0py6/MsJ0wHEA6i1Do3I3rOIurp/HxgSI0Ku1koTjPEbpPHrLJSNHf4UOX+zqbZdIlawyfc9dwq45BVKJKBkp8axwArcYkJIzW3Mrqz2lf9WkDgZeEjvBh4FOTjUH38s+PGYzqITgvPoIjkHGILBpaGfIfrknNcLSlG18olv4TTpo7HPZymf1aSKn5rkaRLswlH8al14XMi6CYGFByVBn0q3Hi/j3MkkQcxR8+bvi5eLRnSp67kY6rSUe71RE=',
  };

  Map<String, String> emptyWalletGroupsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  late WalletGroupsService actualWalletGroupsService;

  setUp(() {
    String testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    SecretsService actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    WalletsRepository actualWalletsRepository = WalletsRepository();
    WalletsService actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository, secretsService: actualSecretsService);

    WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();
    actualWalletGroupsService = WalletGroupsService(
      walletGroupsRepository: actualWalletGroupsRepository,
      walletsService: actualWalletsService,
      secretsService: actualSecretsService,
    );
  });

  group('Tests of WalletGroupsService.getAll()', () {
    test('Should [return List of WalletGroupModel] if ["walletGroups" key HAS VALUES] and [path EXISTS]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));

      // Act
      List<WalletGroupModel> actualWalletGroupModelList = await actualWalletGroupsService.getAll('04b5440e-e398-4520-9f9b-f0eea2d816e6');

      // Assert
      List<WalletGroupModel> expectedWalletGroupModelList = <WalletGroupModel>[
        WalletGroupModel(
          id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
          name: 'Test Group 1',
          pinnedBool: true,
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
        WalletGroupModel(
          id: 'ee661af6-5b77-46a7-a54c-99bdec98d520',
          name: 'Test Group 2',
          pinnedBool: false,
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
      ];

      expect(actualWalletGroupModelList, expectedWalletGroupModelList);
    });

    test('Should [return EMPTY List] if ["walletGroups" key HAS VALUES] and [path NOT EXISTS]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));

      // Act
      List<WalletGroupModel> actualWalletGroupModelList = await actualWalletGroupsService.getAll('not/existing/path');

      // Assert
      List<WalletGroupModel> expectedWalletGroupModelList = <WalletGroupModel>[];

      expect(actualWalletGroupModelList, expectedWalletGroupModelList);
    });

    test('Should [return EMPTY list] if ["walletGroups" key is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletGroupsDatabase));

      // Act
      List<WalletGroupModel> actualWalletGroupModelList = await actualWalletGroupsService.getAll('');

      // Assert
      List<WalletGroupModel> expectedWalletGroupModelList = <WalletGroupModel>[];

      expect(actualWalletGroupModelList, expectedWalletGroupModelList);
    });
  });

  group('Tests of WalletGroupsService.getByPath()', () {
    test('Should [return WalletGroupModel] if [wallet group path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));

      // Act
      WalletGroupModel? actualWalletGroupModel = await actualWalletGroupsService.getByPath(
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125',
      );

      // Assert
      WalletGroupModel expectedWalletGroupModel = WalletGroupModel(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'Test Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      expect(actualWalletGroupModel, expectedWalletGroupModel);
    });

    test('Should [return NULL] if [wallet group path NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletGroupsDatabase));

      // Act
      WalletGroupModel? actualWalletGroupModel = await actualWalletGroupsService.getByPath('not/existing/path');

      // Assert
      expect(actualWalletGroupModel, isNull);
    });
  });

  group('Tests of WalletGroupsService.saveGroup()', () {
    test('Should [UPDATE wallet group] if [wallet group path EXISTS] in collection', () async {
      // Arrange
      WalletGroupModel actualNewWalletGroupModel = WalletGroupModel(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'Updated Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));

      // Act
      String? actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletGroupsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletGroupsKeyValue!,
      );
      Map<String, dynamic> actualWalletGroupsMap = jsonDecode(actualDecryptedWalletGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletGroupsMap = <String, dynamic>{
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125': <String, dynamic>{
          'pinned': true,
          'id': '7f0e30fa-4464-4c86-a42b-4819fb085125',
          'name': 'Test Group 1',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/ee661af6-5b77-46a7-a54c-99bdec98d520': <String, dynamic>{
          'pinned': false,
          'id': 'ee661af6-5b77-46a7-a54c-99bdec98d520',
          'name': 'Test Group 2',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
      };

      TestUtils.printInfo('Should [return Map of wallet groups] as ["walletGroups" key EXISTS] in database');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);

      // ************************************************************************************************

      // Act
      await actualWalletGroupsService.saveGroup(actualNewWalletGroupModel);
      actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletGroupsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletGroupsKeyValue!,
      );
      actualWalletGroupsMap = jsonDecode(actualDecryptedWalletGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletGroupsMap = <String, dynamic>{
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125': <String, dynamic>{
          'pinned': true,
          'id': '7f0e30fa-4464-4c86-a42b-4819fb085125',
          'name': 'Updated Group 1',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/ee661af6-5b77-46a7-a54c-99bdec98d520': <String, dynamic>{
          'pinned': false,
          'id': 'ee661af6-5b77-46a7-a54c-99bdec98d520',
          'name': 'Test Group 2',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
      };

      TestUtils.printInfo('Should [return Map of wallet groups] with updated group');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);
    });

    test('Should [SAVE wallet group] if [wallet group path NOT EXISTS] in collection', () async {
      // Arrange
      WalletGroupModel actualNewWalletGroupModel = WalletGroupModel(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'New Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletGroupsDatabase));

      // Act
      String? actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletGroupsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletGroupsKeyValue!);
      Map<String, dynamic> actualWalletGroupsMap = jsonDecode(actualDecryptedWalletGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletGroupsMap = <String, dynamic>{};

      TestUtils.printInfo('Should [return EMPTY map] as ["walletGroups" key value is EMPTY]');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);

      // ************************************************************************************************

      // Act
      await actualWalletGroupsService.saveGroup(actualNewWalletGroupModel);
      actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletGroupsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletGroupsKeyValue!);
      actualWalletGroupsMap = jsonDecode(actualDecryptedWalletGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletGroupsMap = <String, dynamic>{
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125': <String, dynamic>{
          'pinned': true,
          'id': '7f0e30fa-4464-4c86-a42b-4819fb085125',
          'name': 'New Group 1',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        }
      };

      TestUtils.printInfo('Should [return Map of wallet groups] with new group');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);
    });
  });

  group('Tests of WalletGroupsService.deleteByPath()', () {
    test('Should [REMOVE wallet group] if [wallet group path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));

      // Act
      String? actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletGroupsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletGroupsKeyValue!);
      Map<String, dynamic> actualWalletGroupsMap = jsonDecode(actualDecryptedWalletGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletGroupsMap = <String, dynamic>{
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125': <String, dynamic>{
          'pinned': true,
          'id': '7f0e30fa-4464-4c86-a42b-4819fb085125',
          'name': 'Test Group 1',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/ee661af6-5b77-46a7-a54c-99bdec98d520': <String, dynamic>{
          'pinned': false,
          'id': 'ee661af6-5b77-46a7-a54c-99bdec98d520',
          'name': 'Test Group 2',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
      };

      TestUtils.printInfo('Should [return Map of wallet groups] as ["walletGroups" key EXISTS] in database');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);

      // ************************************************************************************************

      // Act
      await actualWalletGroupsService.deleteByPath('04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125');
      actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedWalletGroupsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedWalletGroupsKeyValue!);
      actualWalletGroupsMap = jsonDecode(actualDecryptedWalletGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedWalletGroupsMap = <String, dynamic>{
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/ee661af6-5b77-46a7-a54c-99bdec98d520': <String, dynamic>{
          'pinned': false,
          'id': 'ee661af6-5b77-46a7-a54c-99bdec98d520',
          'name': 'Test Group 2',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        },
      };

      TestUtils.printInfo('Should [return Map of wallet groups] without removed group');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet group path NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletGroupsDatabase));

      // Assert
      expect(
        () => actualWalletGroupsService.deleteByPath('not/existing/path'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}