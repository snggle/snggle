import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
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
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo',
        'e527efe1-a05b-49f5-bfe9-d3532f5c9db9.snggle':  '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
        'e527efe1-a05b-49f5-bfe9-d3532f5c9db9': <String, dynamic>{
            '08d7e0ef-6932-414f-89d2-204303ef96e0.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
        }
      },
    },
  };

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.wallets.name: 'WW6H/FGSOeQazLtML4I0/2VsTAnTkVYwqlrmLreHFligmR+IePT3uUasaEXYEeAy2IJ+VWCZ0Og5zjXAeDJHLNcRGQoL1qJ3iLKJQMM0pe//70oP0Ijq/R1TGHRouK4/pGQ6BQ5ZsS/SvpAG+7DdVXJID55OWI4UoEIhENkBHqwDVm1IkYomo+VB/8VRj0qkzVlzILwCwixF4kOiaOiQH3qLkFpez8jQDFl/ioEgL0C3t+i8JdX8vxV01TxIl44tmFxAyKoNZ3BRTmSZxESCiuNR6ZLggk53ElAj6heg5LDiZS0JIs31zemMIQVWpbi9KBNFU1qw4cABQgqm+MlJpA6qVeHRzyfdZ8/zgJ2F5UfVi7QhcMTuGAVdek2w5ZZnMlQpFWdw8m7EXEsAAJMOYshp6UcNhX5QOhbE85hVbdBFJM8AqHoMfVzQjQu01E+U/Mx10HYTKfKHdx6cWDeDChRCFlvi/4xQ45GRGESC6Ubc4d7egKq8EaOX5OvDQ7nabySz3jLPFEzBLiD+qyggn3nu9/mizBnvq5QggnRI4S/qOWob4e7X6EPLDWPgH6JKOA/5p7TyFX/4q7u5ikX2PfVSVFUSzossJn48dBBDd1DL7DARMVk5N9FM291Q2vLzUZJLHNfkfVY92oqPnUMpx3tZ9Etnhffbdqvrw8Fv2pZiFZ7bqnqv+CF9CgfXhtuC1tnHD5BHUZewguxpmoSgNuXrNcpzSiV9T42D5wzjdLSx/+fH6v8LJHYpzbIA+PL7TVB6lcYMaKq1aXQMWMh7jP/DMUYnd7bOb55tgMhBB/fxDPGLx9zONEG9suCnDBaLB5YslIfRVy8xz6pA06DWhOHP2LWdppIEiV3drqf/EDLic0XEpS59mr3sB4uuYz2MKjJykWRCFWwjdb//McWkfxygVmTjgYb0V8l1/HYnmABQA7PnmXrAvqf1P89aLFn4yBpdpj9F9h74IslzHn0QDtpR30iymo9DWMTuMBayeUoF+zKnmoJwZmEAhaFbOf414CKFiWNbC6/tnM9PnAy+RxKaZTj60rNUv0IOXZZL4E4PrISi/rhxNb5xA12bZUIjk+1URMZwKGBUZ9xqD3kC240wVlKTIoDOQDwHGL5zvUGdoNURxX0aUiTa73wH9EnckA1sS0HQ3aO5rP9tWptkv4ROwLnHvCGZ8bU1lqyuDuG4PWm12r3iCSRniI8wPIJnYetSprmAFDzwwjaQXTTkv5hB7Hn9i+YoxN8ORf/gQrNTkfnFIrmZZqKJv7G5yOctuZK5F5IYKI8C8QEWJuUkhujD/6UzTKRTwPaWwvk0nrDBOJ+guRUymBJxVInxz77BonZYwjK+7rUUixn8kkU/dT7vE6JL6/CW16UqBcXFMF9I+4qsNQxAJIrGnNwLEnBcVtC1WwXwxYJIg9KbxFkVluoMhlMm9y0jqk7IqbHWDlpmXcVHdHJIMbRRML/pZVqdRNgWnSyPBugMYmUgm9UCAbhQiiKeoFxnjJa0JjxjzvAjTXiUhCCnxOppuAJyLJeVAwEE+dIdvMmiR+V1IYBsxMMytlnzfDE5U8T2J/kmTu4oipbi7Oo6BLv8enEIgk3E8xvOMExdJyePayFT+bdBL90lHokfG9kmLJhjh5gmuDssPLZJhb+8xaIPzQms2NuPQMwvM+ilQKjl8SgEkdklk5i5chGbkSqM0+9ffPnAra3lmW4EfqatcWmVvYUoYA0Ma8d8XsP1tqVvqYACQjb5VR9Inuskkkxv4vWatpeA1x15pi7ts3fyB7Z13sTxK82d4sQVqO+ZrvfcE/Or2HZOdrpC0gGiOBNfhmANXvy7+42Z+u9IHHAw6H6RkCpbe+7jy72amQ==',
    DatabaseParentKey.groups.name:'hBuawfq021xYOrgQP95pXk9XrWpl+sb66GTtaiqqvED+Zl2kPoEOMZfRlQzwpf1dLLAuJu86g1lPla0bpfABY4/WVLSPlHpwL/KwkFu2lcah2gEd95JdbzF6XfCuCYSDTc3C87EghlsZO6XevMAm4UlCtMMyyowwx6yI4y2gFvxJheYNT/pj/VhT1eqGGxec+SuyfJLbmtVHDONrAw5XDgfuUWy9e7vJ3jlRgS6AteXtz9tPMO8A0wqEQAbsotC7UlfJsF3Ow8qvhDjQTov9T2vuUcCnllNH9DvMIMtXskJwhMy0XtwLjcaQ4QTDG7OJjtGYMS5A4f+lfqfw7PYFia71hkSmg0ddz/n5ItLloWcwreDk',
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

  WalletModel walletModel3 = WalletModel(
    pinnedBool: false,
    encryptedBool: false,
    index: 2,
    address: 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
    derivationPath: "m/44'/118'/0'/0/0",
    network: 'kira',
    uuid: '08d7e0ef-6932-414f-89d2-204303ef96e0',
    filesystemPath: FilesystemPath.fromString(
      '04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9/08d7e0ef-6932-414f-89d2-204303ef96e0',
    ),
    name: 'WALLET 2',
  );

  WalletModel walletModel4 = WalletModel(
    pinnedBool: false,
    encryptedBool: false,
    index: 3,
    address: 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'),
    name: 'WALLET 3',
  );

  GroupModel groupModel = GroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
    name: 'WORK',
    listItemsPreview: <AListItemModel>[walletModel3],
  );

  GroupModel updatedGroupModel = GroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
    name: 'UPDATED WALLET',
    listItemsPreview: <AListItemModel>[walletModel3],
  );

  late WalletListPageCubit actualWalletListPageCubit;

  group('Tests of WalletListPageCubit process', () {
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
        depth: 0,
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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[walletModel1, walletModel2, groupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single WALLET', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await globalLocator<WalletsService>().save(updatedWalletModel2);

        // Act
        await actualWalletListPageCubit.refreshSingle(walletModel2);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, groupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualWalletListPageCubit.refreshSingle(groupModel);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
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
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all wallets UNSELECTED] if all items were selected before', () async {
        // Act
        actualWalletListPageCubit.toggleSelectAll();

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified WALLET selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[walletModel1],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[walletModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified WALLET unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedWalletModel2, walletModel1, updatedGroupModel],
          pinnedBool: false,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedWalletModel2.copyWith(pinnedBool: false),
            walletModel1.copyWith(pinnedBool: false),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedWalletModel2.copyWith(pinnedBool: false),
            walletModel1.copyWith(pinnedBool: false),
          ],
          pinnedBool: true,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedWalletModel2.copyWith(pinnedBool: true),
            walletModel1.copyWith(pinnedBool: true),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected items (encryptedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedWalletModel2.copyWith(pinnedBool: true),
            walletModel1.copyWith(pinnedBool: true),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
            updatedWalletModel2.copyWith(pinnedBool: true, encryptedBool: true),
            walletModel1.copyWith(pinnedBool: true, encryptedBool: true),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected WALLET (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.unlockSelection(
          selectedItem: updatedWalletModel2.copyWith(pinnedBool: true, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
            updatedWalletModel2.copyWith(pinnedBool: true, encryptedBool: false),
            walletModel1.copyWith(pinnedBool: true, encryptedBool: true),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false),
            updatedWalletModel2.copyWith(pinnedBool: true, encryptedBool: false),
            walletModel1.copyWith(pinnedBool: true, encryptedBool: true),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted WALLET', () async {
        // Act
        await actualWalletListPageCubit.deleteItem(walletModel1.copyWith(encryptedBool: true));
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false),
            updatedWalletModel2.copyWith(pinnedBool: true, encryptedBool: false),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualWalletListPageCubit.deleteItem(
          updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
        );
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedWalletModel2.copyWith(pinnedBool: true, encryptedBool: false),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(() {
      TestUtils.clearCache(testSessionUUID);
    });
  });

  group('Tests of WalletListPageCubit groups process', () {
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
        depth: 0,
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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[walletModel1, walletModel2, groupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.moveItem()', () {
      test('Should [emit ListState] with WALLET moved into GROUP', () async {
        // Act
        await actualWalletListPageCubit.moveItem(walletModel1, groupModel.filesystemPath);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            walletModel2,
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                walletModel1.copyWith(
                  filesystemPath: FilesystemPath.fromString(
                    '04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9/4e66ba36-966e-49ed-b639-191388ce38de',
                  ),
                ),
                walletModel3,
              ],
            ),
            walletModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualWalletListPageCubit.groupItems(walletModel2, walletModel4, 'TEST GROUP');

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        // Since created group has random UUID we cannot predict expected ListState and compare items one by one.
        // For that reason, we will only check if the group was created and if the number of items is correct.
        expect(actualListState.allItems.length, 2);
        expect(actualListState.allItems[0], isA<GroupModel>());
        expect(actualListState.allItems[1], isA<GroupModel>());
      });
    });

    tearDownAll(() {
      TestUtils.clearCache(testSessionUUID);
    });
  });

  group('Tests of WalletListPageCubit navigation process', () {
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
        depth: 0,
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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[walletModel1, walletModel2, groupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualWalletListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[walletModel3],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualWalletListPageCubit.navigateBack();

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[walletModel1, walletModel2, groupModel, walletModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualWalletListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[walletModel3],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(() {
      TestUtils.clearCache(testSessionUUID);
    });
  });
}