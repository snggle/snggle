import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/wallet_groups_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallet_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_list_item_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  initLocator();

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '04b5440e-e398-4520-9f9b-f0eea2d816e6.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      '04b5440e-e398-4520-9f9b-f0eea2d816e6': <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'AXRN5EO2mnHdhasGFuMNn+TkfJsytY+wNMCWsejh2Xy4gPwKBdDH/h7+OmMuK05GsLR9jO8dXGt4FpfpAX1okYMsgJW2HiONc27mokH3xFo2yAN8LP/z0fyLwV65ST/3NpENZ/1P+yVuVhBCy//91ZMzR1rjtZRvMROvml1WophQ4eCvKrfB/XIZJ4HK97wsUgc+dNppy1tW7r7PY/zIb8EuLqhfIgdXosbENVmOAWgylQdN',
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee.snggle': 'UAT9B0YwJ1bjxMeO1mXBB8P8qak1a4oxsiXpu2M773eZkqTcHMMl+O7kE2Icshxleb5NW0g0YX/w1fcxbNuoPevOOdhsUZcCemLqZn31P/ElcwxBiS0Cz0Cg9YdG9Tk/PUlC7Lu5rtaYvvtlJ8YAC3Csn5jvJD11+NNe/iSiRkCJBa6xjCbWl1MITQpCPstBzHC38qotIQGHdUN4zXZ8YdDMH9nlZreX2/0Q71KKV4T3A0pr',
        'ef4fdf35-4e57-49e3-8d60-97967eef30de.snggle': 'lc1b8jyIefNGl5yUkFVnLas6XK5XYBn2Y4hDi1BVBu0wqkxMMRuuwGxdxk9ddMo1wQN+IucZ3qVZzCH9r4jQG8/gbet1JwdiMy4Je21jXrQ/jb8TodNwrZiAroZKsr1LYm7Cwh2tSP0zHY9h6Qe5zSeDHNXKtPFYPD0HNcKJ1TIyX+OdOoF7wJGCqGwMW785jDb+HWmZAtLYUeRqZLE6L4pxeGRMU2JcjzrSx6swEhfN2CrvPHnUtrcei+RTfb5+vX2R88zIjTqXaLvn1HIv6RDM1netGRzH/Wt8s5MuGTzF/dwyiAzQFAm3LpdtuPHivnoyCBhomSaqOK0YZ8EBfWbfV81jRLF/mIN1fBJvza4Wf9HO',
        'ef4fdf35-4e57-49e3-8d60-97967eef30de': <String, dynamic>{
          '4d02947e-c838-4a77-bef3-0ffbdb1c7525.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
          'ef63ccfc-c3da-4212-9dc1-693a9e75e90b.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo'
        }
      },
    },
  };

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
    DatabaseParentKey.wallets.name:'NbgmOO3N9JdpjABdq841WLgdOBEhorR1ai1GL0AWGvQ14NBihc9elMPP6havtEnfuCKLvBURf3wBX50mBJw86xOxrXVmlbbuLOQc+f9wYlEzTQokXnklPtQX2l/22blH+OeIR1TgYsHSarQWjhUpcbQZ4kbLF1MTo9ZPuO2vn97RgN60GfugjahpdOG2nGMp6A6e9aj/5EVAdlBPera0lkDJmdqwJU+shS6uEbVKENi7aOMZbOkTbb6ye/AeMHIzbb3gZ+gaKLu6XTm/BI02+TnQyE+whXJosZH/Q6gDTglToB4H0ZbKmdPY7RWwi5uvf6jUobovgt+VqfqrsT/JiP2d1pXNuzOmiLBndKFuBH1ibZ8W5CwDCOLKWAm321NYqQ0l7Vrd0eucKn3yPcgbaRV+0EGip9lBa6j2YScPC5CiZ0rvZLl5f2wC8cm2NUSFYJadCVmbPRAFZwAXerM0YJD2LAb+Y1zBQZ509EMsQkNPe6Qz8V3XaaIbnrt9qtCoH+VxhsIqSQ3w2QRFQc6pReEz9UICPo+EWeDQ4oRTusjdAUIs9G4RghBEKt9fIJBPJW7Ts3Ru1yz2OtUn3BL/+hlxMFhdopY3WUBQ/Dgg8kURJP2hMIh9dyYIuxUNCa1wdW4/MjrDxG8r5xxLOS8q5i0JVOJ7O/EBUYDtgD2nXuPs6OTPikdgbw7zEiF1l0UNGCTPuYXBos5OM8gyFTkKrmjcuit03Fk6TlGr2yh0+oIalyNSZxVHj18UbKaLf8CssycV4sab76eo0k5NXYRDHDEXkQE/Olaal5rkU1QDzSnwOjB+jT+kpEwYc9IUQ07oGxTFeryztAhB7iGAPz05yOYyJ3iiPV+wOYZM1xTr/eAKYwM3ciaRH6w9VhSVdkYSK/paB2pb9Ill5hC5B4cFNosJMKLib2izMDBgRjtNBmroyOxZ/O7NJFjDWoJFevVeGGLR8O5NcFLTRoPOysLyjRsB6yqvZtEVZ+NlXr8zJNYYmSMVqjj93vnGCep2iHquMRP+TanWojgj3cSIQIe5/pBfikulSH0miPjFzUACSrV6T3t15GAQYx8nof4G/7uNBrZcUooLgdx3fllV6xicyx369lNHfxPdkiMql/7DePWfPUyAjeCmpG7joIL+TLwIWNb6PYdfi52he7hKq5aoZBqCn//3mF0rLNUzqbMLJyGE35gXWpCB5gtdU2TpwutbL3ibz4VA01+g4F1AZnejN7vPTUXm1yXjFK29qoeZR1khWUUvPEtWFcStAjoKa4moaTvJdLuoazxGciMRNBInDZZV3Eb0LfkaKHB5TBPaFo08HErnzLOMKrANeqcrHvvInaXKVBTjENqfY/56IKqHbvFvZsGiJaqqFoUgP5kVJAAR0eeZn5Ic1NuoRQHFVaEnT56tKRNXlfBZCV8uUjfbqvJQteKZ7oTmK+gk97A0MIiI5BDBFi68TkDEOCxAA1/JYtT4WWj15iPVXUNSDfq2H6nAc3pkRs4WVEGxCAQ+aXWr0Lc66gi21eoS2KjeXUe+ATY7GdK8g6nvAPLfU1rH6lXlvHADofOfPaiZv9LgZnhDyUPYHsMkTljl10EIqPmrWy1H+w==',
    DatabaseParentKey.walletGroups.name:'TqXA05o8031umAcMiSOtk0Lnyg3byGVYUwbRP5bD7mxPKztAs0gL8OMCkU+q3/HokHq1o0fC/RmcwMTVd6JDc5vLa6f4EjWFs8Tj/RT0rWYE8w549TWGyf1d2AkQNSkODyQ5IwT1Ezp0xOg8l1h2mFSTFKMOdtoE1T34JrfDDE0tsFaVTvTyqk2izYRhMsgKusSb3QIYkOuE57f7NroO+imEBYfn7qjh1JiGPdVSF8e8RohzJO10TqvUCw6JaclUm9m3Y7EqAvP18l6VTKjyqnWmivKNnPG4Si4Qxc59xBnbfGrGLbbNBbWCZCvSW0iX1Brc2g==',
  };
  // @formatter:on

  WalletModel walletModel1 = WalletModel(
    pinnedBool: true,
    index: 0,
    address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
    derivationPath: "m/44'/118'/0'/0/0",
    network: 'kira',
    uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  WalletModel walletModel2 = WalletModel(
    pinnedBool: true,
    index: 1,
    address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  WalletModel updatedWalletModel2 = WalletModel(
    pinnedBool: true,
    index: 1,
    address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
    name: 'Updated Wallet 123',
  );

  WalletGroupModel walletGroupModel1 = WalletGroupModel(
    id: 'ef4fdf35-4e57-49e3-8d60-97967eef30de',
    name: 'Test Group 1',
    pinnedBool: true,
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  WalletGroupModel updatedWalletGroupModel1 = WalletGroupModel(
    id: 'ef4fdf35-4e57-49e3-8d60-97967eef30de',
    name: 'Updated Wallet Group 123',
    pinnedBool: false,
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  late String testSessionUUID;
  late SecretsService actualSecretsService;
  late WalletsService actualWalletsService;
  late WalletGroupsService actualWalletGroupsService;

  late WalletListPageCubit actualWalletListPageCubit;

  setUpAll(() {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    WalletsRepository actualWalletsRepository = WalletsRepository();
    actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository, secretsService: actualSecretsService);

    WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();
    actualWalletGroupsService = WalletGroupsService(
      walletGroupsRepository: actualWalletGroupsRepository,
      secretsService: actualSecretsService,
      walletsService: actualWalletsService,
    );

    actualWalletListPageCubit = WalletListPageCubit(
      vaultModel: VaultModel(index: 1, uuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6', pinnedBool: true, name: 'Test Vault 1'),
      containerPathModel: ContainerPathModel.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
      networkConfigModel: NetworkConfigModel.kira,
      vaultPasswordModel: PasswordModel.defaultPassword(),
      secretsService: actualSecretsService,
      walletsService: actualWalletsService,
      walletGroupsService: actualWalletGroupsService,
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
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: walletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single wallet', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await actualWalletsService.saveWallet(updatedWalletModel2);

        // Act
        await actualWalletListPageCubit.refreshSingle(WalletListItemModel(encryptedBool: true, walletModel: walletModel2));

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: walletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single wallet group', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await actualWalletGroupsService.saveGroup(updatedWalletGroupModel1);

        // Act
        await actualWalletListPageCubit.refreshSingle(WalletGroupListItemModel(
          encryptedBool: true,
          walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
          walletGroupModel: walletGroupModel1,
        ));

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectAll()', () {
      test('Should [emit ListState] with [all wallets SELECTED]', () async {
        // Act
        actualWalletListPageCubit.selectAll();
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 3,
            selectedItems: <AListItemModel>[
              WalletGroupListItemModel(
                encryptedBool: true,
                walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
                walletGroupModel: updatedWalletGroupModel1,
              ),
              WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
              WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
            ],
          ),
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all wallets UNSELECTED] if all wallets were selected before', () async {
        // Act
        actualWalletListPageCubit.selectAll();

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(selectedItems: <AListItemModel>[], allItemsCount: 3),
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified wallet selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(WalletListItemModel(encryptedBool: true, walletModel: walletModel1));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 3,
            selectedItems: <AListItemModel>[
              WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            ],
          ),
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified wallet group selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(WalletGroupListItemModel(
          encryptedBool: true,
          walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
          walletGroupModel: updatedWalletGroupModel1,
        ));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 3,
            selectedItems: <AListItemModel>[
              WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
              WalletGroupListItemModel(
                encryptedBool: true,
                walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
                walletGroupModel: updatedWalletGroupModel1,
              ),
            ],
          ),
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified wallet unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(WalletListItemModel(encryptedBool: true, walletModel: walletModel1));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 3,
            selectedItems: <AListItemModel>[
              WalletGroupListItemModel(
                encryptedBool: true,
                walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
                walletGroupModel: updatedWalletGroupModel1,
              ),
            ],
          ),
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified wallet group unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(WalletGroupListItemModel(
          encryptedBool: true,
          walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
          walletGroupModel: updatedWalletGroupModel1,
        ));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(selectedItems: <AListItemModel>[], allItemsCount: 3),
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualWalletListPageCubit.disableSelection();

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected wallets (pinnedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1,
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
          pinnedBool: false,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: false),
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1.copyWith(pinnedBool: false)),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2.copyWith(pinnedBool: false)),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected wallets (pinnedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: false),
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1.copyWith(pinnedBool: false)),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2.copyWith(pinnedBool: false)),
          ],
          pinnedBool: true,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.updateEncryptionStatus()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected wallets (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.updateEncryptionStatus(
          selectedItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
          encryptedBool: false,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: false,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
            ),
            WalletListItemModel(encryptedBool: false, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: false, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected wallets (encryptedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.updateEncryptionStatus(
          selectedItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: false,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
            ),
            WalletListItemModel(encryptedBool: false, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: false, walletModel: updatedWalletModel2),
          ],
          encryptedBool: true,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
            ),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.delete()', () {
      test('Should [emit ListState] without deleted wallet', () async {
        // Act
        await actualWalletListPageCubit.delete(WalletListItemModel(encryptedBool: true, walletModel: walletModel1));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <AListItemModel>[
            WalletGroupListItemModel(
              encryptedBool: true,
              walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
              walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
            ),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted wallet group', () async {
        // Act
        await actualWalletListPageCubit.delete(WalletGroupListItemModel(
          encryptedBool: true,
          walletAddressesPreview: <String>['kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5', 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl'],
          walletGroupModel: updatedWalletGroupModel1.copyWith(pinnedBool: true),
        ));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}