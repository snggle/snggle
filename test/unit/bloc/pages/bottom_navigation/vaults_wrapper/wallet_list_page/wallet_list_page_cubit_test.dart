import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  String testSessionUUID = const Uuid().v4();
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');

  // @formatter:off
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
    DatabaseParentKey.wallets.name:'OMqlo020DTiMFINZE10wtK0nNGKyjB8LmGGxqkk0Yl9wamQ9VnAphZ/0eqC4XuMw8ilP08bvX97WUboWsHehkMfYRX8Eumm+zXZpHRF8pisVCy80UFpveJAV9ueG8VTxoh8X6KZYKTc0pMN0WzkMvClU3wsT8+qJG8f9f+QUG4F5KcSLzmTvxRCKZcgObTK2EX2+SNtleYwN2VQNu2ERaqT0X447MCV/1MskH6fRY0SX3hQ0y3D9zlr8D2nf8BsjUUYt8Q96o31pvtQNO8ajh38m0cqTDzcAf+4an8VqXCEM8kLfXUFOQrmnpkJ+uzK0zJbpIBAursvDMLdKucbvkpr51SV5Ch2xoYC5brqrPTnQ0rnIohKgZQC0uyw6FbHcbGDPDRESacrI5mOxbySegRo4ouSoIXtk4+buQg0sh5IRTG3raV7DRI+PS2f/bPIU/Ufj8LTeRvK+hmZlXPYd9V38W7JNDedPydOZzFL5boIi9X45uLPhRdP2g7cjSKKqSFaPkTF75yY3Fj4H2ptn6gkGtmIV+juRlGxka5rKCfsC3NZg+VSB1beiblgXZ17rSrnfYOHhM8tu/Ba1wfXBF+sqhHWUKoIgebDsu4V5WqrMxZ4sG+USNUGfpi0Z7mLvNkluyM43D2RPFSaUwh16g+k94xRpRX9RizYqdZk2ssGdAukXppKFYlapNtW4FDNe7aFhtKvAfyDdYTf18a8fUq7QcJOXNxdfVMnSPmikyAhvapQGNjoZKN40NVmTdx2T1ou45IpV6xT+Ecg6gev4EGJ172r2wPfNFp/aSEm3DChJdgwb0hUkZDRgQP36MowlW8rni7336S/Wx3Y/R5k2DNvkzba3XQZILN4OFBM9UjTwR2dtV1BzKmipFmDZC42gJ7az2yyPgjtlUdINibtgpI5vCBBBtQU3U0ffhl9jBEACIQd1wWCpR+jgUIJpCxAoKUVDgoKBERSMHnBqAISktgZnKvy10jlFkAvg7PhfoWX5xKMdL1893nevIS0/0THZNUqKYcJYYMoJsP6qHGWdvSCarSzmVGVN5j7tuWsqRhqseCc+Kr5+LSIQW2Uyjd6xEByp4uYhlxrLWb9Dd2PVi9rjLbz/SEyn2ThEI+o7HnJpT5BjveA4Em5wkkLHe+gymPuU62+OhMYFZtwTPLVIP3KNcfT7U3R0JfhWAxuBgP8Q+Moa4Why8+OGf41I1ErObT6yYVY4TwNfbXDFwPwizi1beUAQ2F2kpqARnaUc363dS/Aooz8ZrJNwRyUlrjbS5lwM07s9syOvJ1RYOcbVLpOhrfuNmtd9t1dPDUNPODx2/iUcSOWa9dNUpGPmxQ0TTzJUNgKf57FCJZyeS7/i0k7CIXa3ifX5665YR3L6IqTIC4KuF4ocMIljPrTDQaf/sA7//G7NllQJ5fwAwEBHLmyEL2JdO2Igd3QMqTQzZv5OQixrUUzUFADpfYjZz4RXiZ1/nux+4rGqff+XR7Wap451JN9vMsmAw8yvacK1pNMSqc2wWfCtK717yJmaerH0xMibKRiST1J3DnHQ1xB++ydN9BAb0A6hWoc5MmfMh4SiyQ6wZTlhybTc1btAJ9WOm2FGSROtMVYeyQqOiQtFdkdhfOPU/HH4PYVyE3jo1XO4IKBTp6EJhojWTGS6KKSMQJfbxEMcjBvKS7sdqDjOa1scZZ1zlxRzqSkxNNQvCiZBYC3zJkyxITmA2aHsa3pXQpwTxlXPNDSsfUXIPyoGbOt2353F3vGILu/ElhNb8D+yjKUxp7gStrVVEg9K3aDsYveEaSjxDGsSUWt5p5KlZQ8xlrY=',
  };
  // @formatter:on

  WalletModel walletModel1 = WalletModel(
    pinnedBool: true,
    encryptedBool: true,
    index: 0,
    address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
    derivationPath: "m/44'/118'/0'/0/0",
    network: 'kira',
    uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
    name: 'WALLET 0',
  );

  WalletModel walletModel2 = WalletModel(
    pinnedBool: true,
    encryptedBool: false,
    index: 1,
    address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'),
    name: 'WALLET 1',
  );

  WalletModel updatedWalletModel2 = WalletModel(
    pinnedBool: true,
    encryptedBool: false,
    index: 1,
    address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'),
    name: 'UPDATED WALLET',
  );

  late WalletListPageCubit actualWalletListPageCubit;

  setUpAll(() {
    globalLocator.allowReassignment = true;
    initLocator();

    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

    globalLocator.registerLazySingleton(() => actualSecretsRepository);
    globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

    actualWalletListPageCubit = WalletListPageCubit(
      vaultModel: VaultModel(
        pinnedBool: true,
        encryptedBool: true,
        index: 1,
        uuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
        name: 'Test Vault 1',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        listItemsPreview: <AListItemModel>[],
      ),
      filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
      vaultPasswordModel: PasswordModel.defaultPassword(),
    );
  });

  group('Tests of WalletListPageCubit process', () {
    group('Tests of WalletListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualWalletListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of WalletListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all wallets existing in database', () async {
        // Act
        await actualWalletListPageCubit.refreshAll();
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single wallet', () async {
        // Arrange
        // Update wallet in database to check if it will be updated in the state
        await globalLocator<WalletsService>().save(updatedWalletModel2);

        // Act
        await actualWalletListPageCubit.refreshSingle(walletModel2);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all wallets SELECTED]', () async {
        // Act
        actualWalletListPageCubit.toggleSelectAll();
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all wallets UNSELECTED] if all wallets were selected before', () async {
        // Act
        actualWalletListPageCubit.toggleSelectAll();

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified wallet selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[walletModel1],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified wallet unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualWalletListPageCubit.disableSelection();

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected wallets (pinnedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[walletModel1, updatedWalletModel2],
          pinnedBool: false,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedWalletModel2.copyWith(pinnedBool: false),
            walletModel1.copyWith(pinnedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected wallets (pinnedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            walletModel1.copyWith(pinnedBool: false),
            updatedWalletModel2.copyWith(pinnedBool: false),
          ],
          pinnedBool: true,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected wallets (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[walletModel1, updatedWalletModel2],
          encryptedBool: false,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedWalletModel2.copyWith(encryptedBool: false),
            walletModel1.copyWith(encryptedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected wallets (encryptedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedWalletModel2.copyWith(encryptedBool: false),
            walletModel1.copyWith(encryptedBool: false),
          ],
          encryptedBool: true,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedWalletModel2.copyWith(encryptedBool: true),
            walletModel1.copyWith(encryptedBool: true),
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted wallet', () async {
        // Act
        await actualWalletListPageCubit.deleteItem(walletModel1.copyWith(encryptedBool: true));
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedWalletModel2.copyWith(encryptedBool: true),
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}