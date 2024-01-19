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

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  Map<String, String> filledWalletsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(
      <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'index': 0,
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': false,
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': false,
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': true,
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': true,
        }
      },
    ),
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{}),
  };

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
            passwordProtectedBool: false),
        WalletModel(
          index: 1,
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          vaultUuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
          passwordProtectedBool: false,
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
        passwordProtectedBool: true,
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

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
          'password_protected': false,
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': false,
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': true,
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': true,
        }
      });

      TestUtils.printInfo('Should [return Map of wallets] as ["wallets" key EXISTS] in database');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);

      // ************************************************************************************************

      // Act
      await actualWalletsService.saveWallet(actualUpdatedWalletModel);
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'index': 0,
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': true,
          'name': 'Updated name',
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': false,
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': true,
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': true,
        }
      });

      TestUtils.printInfo('Should [return Map of wallets] with updated wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
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
          passwordProtectedBool: false);

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

      // Act
      String? actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedWalletsKeyValue = jsonEncode(<String, dynamic>{});

      TestUtils.printInfo('Should [return EMPTY map] as ["wallets" key value is EMPTY]');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);

      // ************************************************************************************************

      // Act
      await actualWalletsService.saveWallet(actualNewWalletModel);
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
        '8b52e5f2-d265-41d5-8567-47e9f879bd02': <String, dynamic>{
          'index': 2,
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'password_protected': false,
          'name': 'New wallet',
        },
      });

      TestUtils.printInfo('Should [return Map of wallets] with new wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
    });
  });

  group('Tests of WalletsService.deleteWalletById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));
      WalletsService actualWalletsService = WalletsService(walletsRepository: WalletsRepository());

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
          'password_protected': false,
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': false,
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': true,
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': true,
        }
      });

      TestUtils.printInfo('Should [return Map of wallets] as ["wallets" key EXISTS] in database');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);

      // ************************************************************************************************

      // Act
      await actualWalletsService.deleteWalletById('4e66ba36-966e-49ed-b639-191388ce38de');
      actualWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedWalletsKeyValue = jsonEncode(<String, dynamic>{
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'index': 1,
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'vault_uuid': '04b5440e-e398-4520-9f9b-f0eea2d816e6',
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': false,
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'index': 0,
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'password_protected': true,
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'index': 1,
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'vault_uuid': '5f5332fb-37c1-4352-9153-d43692615f0f',
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'password_protected': true,
        }
      });

      TestUtils.printInfo('Should [return Map of wallets] without removed wallet');
      expect(actualWalletsKeyValue, expectedWalletsKeyValue);
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
