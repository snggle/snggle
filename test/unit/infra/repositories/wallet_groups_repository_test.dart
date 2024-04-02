import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/wallet_groups_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.walletGroups;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
      encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledWalletGroupsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'6jzcZqsbTvXBniGZD/H4NXvnePv5J8Qp2h66Tiaiuat3VoHlOH8qZedSBdXHu7fvIeejFANAGim6oKMH1ahsjm7sQcnnMhU7LFOK6M4tbbJEBlevRP0Ds4l8janmKWsPyMh/7tiB38luWr/ekyz2PJZPhjf2EMuW/4KUt7c/G/iWrP883wSYZqb3G1uHdfBvB+4EyvSqqOFw35KRJLQKUEfC8MRg+PnoDOJq/ShlfixUojka2t3RRHh6JuRBjwAbixduVUokq+SpbpnNRxHgTIWQaSKQTYB/L9QEak7pmC8KHq56oI5E2gtW7wbhntW6SMljeAUcH7tAzSCCgIGeWTgznrISZO0py6/MsJ0wHEA6i1Do3I3rOIurp/HxgSI0Ku1koTjPEbpPHrLJSNHf4UOX+zqbZdIlawyfc9dwq45BVKJKBkp8axwArcYkJIzW3Mrqz2lf9WkDgZeEjvBh4FOTjUH38s+PGYzqITgvPoIjkHGILBpaGfIfrknNcLSlG18olv4TTpo7HPZymf1aSKn5rkaRLswlH8al14XMi6CYGFByVBn0q3Hi/j3MkkQcxR8+bvi5eLRnSp67kY6rSUe71RE=',
  };

  Map<String, String> emptyWalletGroupsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  group('Tests of WalletGroupsRepository.getAll()', () {
    test('Should [return List of WalletGroupEntity] if ["walletGroups" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Act
      List<WalletGroupEntity> actualWalletGroupEntityList = await actualWalletGroupsRepository.getAll();

      // Assert
      List<WalletGroupEntity> expectedWalletGroupEntityList = <WalletGroupEntity>[
        const WalletGroupEntity(
          id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
          name: 'Test Group 1',
          pinnedBool: true,
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
        const WalletGroupEntity(
          id: 'ee661af6-5b77-46a7-a54c-99bdec98d520',
          name: 'Test Group 2',
          pinnedBool: false,
          parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        ),
      ];

      expect(actualWalletGroupEntityList, expectedWalletGroupEntityList);
    });

    test('Should [return EMPTY list] if ["walletGroups" key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Act
      List<WalletGroupEntity> actualWalletGroupEntityList = await actualWalletGroupsRepository.getAll();

      // Assert
      List<WalletGroupEntity> expectedWalletGroupEntityList = <WalletGroupEntity>[];

      expect(actualWalletGroupEntityList, expectedWalletGroupEntityList);
    });

    test('Should [return EMPTY list] if ["walletGroups" key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Act
      List<WalletGroupEntity> actualWalletGroupEntityList = await actualWalletGroupsRepository.getAll();

      // Assert
      List<WalletGroupEntity> expectedWalletGroupEntityList = <WalletGroupEntity>[];

      expect(actualWalletGroupEntityList, expectedWalletGroupEntityList);
    });
  });

  group('Tests of WalletGroupsRepository.getByPath()', () {
    test('Should [return WalletGroupEntity] if [wallet group path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Act
      WalletGroupEntity actualWalletGroupEntity = await actualWalletGroupsRepository.getByPath(
        '04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125',
      );

      // Assert
      WalletGroupEntity expectedWalletGroupEntity = const WalletGroupEntity(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'Test Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      expect(actualWalletGroupEntity, expectedWalletGroupEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet group path NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Assert
      expect(
        () => actualWalletGroupsRepository.getByPath('not/existing/path'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletGroupsRepository.save()', () {
    test('Should [UPDATE wallet group] if [wallet group path EXISTS] in collection', () async {
      // Arrange
      WalletGroupEntity actualUpdatedWalletGroupEntity = const WalletGroupEntity(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'Updated Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

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
      await actualWalletGroupsRepository.save(actualUpdatedWalletGroupEntity);
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
      WalletGroupEntity actualNewWalletGroupEntity = const WalletGroupEntity(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'New Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

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
      await actualWalletGroupsRepository.save(actualNewWalletGroupEntity);
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

    test('Should [SAVE wallet group] if ["walletGroups" key NOT EXISTS] in database', () async {
      // Arrange
      WalletGroupEntity actualNewWalletGroupEntity = const WalletGroupEntity(
        id: '7f0e30fa-4464-4c86-a42b-4819fb085125',
        name: 'New Group 1',
        pinnedBool: true,
        parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Act
      String? actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as ["walletGroups" key NOT EXISTS] in database');
      expect(actualEncryptedWalletGroupsKeyValue, null);

      // ************************************************************************************************

      // Act
      await actualWalletGroupsRepository.save(actualNewWalletGroupEntity);
      actualEncryptedWalletGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

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
          'name': 'New Group 1',
          'parent_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        }
      };

      TestUtils.printInfo('Should [return Map of wallet groups] with new group');
      expect(actualWalletGroupsMap, expectedWalletGroupsMap);
    });
  });

  group('Tests of WalletGroupsRepository.deleteByPath()', () {
    test('Should [REMOVE wallet group] if [wallet group path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletGroupsDatabase));
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

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
      await actualWalletGroupsRepository.deleteByPath('04b5440e-e398-4520-9f9b-f0eea2d816e6/7f0e30fa-4464-4c86-a42b-4819fb085125');
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
      WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();

      // Assert
      expect(
        () => actualWalletGroupsRepository.deleteByPath('not/existing/path'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}
