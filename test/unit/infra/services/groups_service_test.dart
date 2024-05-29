import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  String testSessionUUID = const Uuid().v4();

  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.groups;

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '0a73e366-264a-462f-b86c-40865933a8cd.snggle': 'qYlh/CC9ulfRa1VeRmaBWEofGajapZLklZdDceDmXXKptVBeih7grSPxKDoYJpg6fPiZ97oD+nFpLVLZT1s7OzTD7NEt40qEJqkd2ap49oIpxzwGCh7jsxvdnluAzcVP28xneFw/hpedLOedEzQvSU5rOgP3p179PzsOKKGCm/vxtjGPWkIV5fSRsRfrnxpYbmr0mdLo/EFIFivgcKzeg+E1v+5CtQoQaSoENFKtZtQ+BNbJ810NmmrhsmIIwcVbxKlFYjSZrrQrUQIDMoKnJ835adlOQV2DRjXt9Ufb5bYTb3u94o2NYs6hcXi1I5QmqUfWlCMXJDUIsx59EpW7D5KZ46+gNuQq+Z+zDfCMz07f5ng2',
      'c01a1d77-8952-43b5-99fb-fb3b7c680db2.snggle': 'yBa0jlUMTrrpxyE/bX5U8Up5+g41aMfPXlu9WZuG2pC6SqES3DyoDeJy4LuI8A06uhooe6/cDlGv+mMiQY322gd43R/g6O9VKi1OhgLcR80b0aR/EPc3Nidsa9cJXt6OU/b7AF76gNBT8CykPMQUUo8jgRNykoVbEDnMW2dQclMrHb5Y5/+7SwftjBT1hIJscgn46lJpeBfnsc/+F3MVC5CeOVcadfY+ExmNNIDJwEwYDGvkSB3r5KG+qQ+e4v2LihGAe4lgquitmudzQiMpoChmaPayl84cNv4yUav3zhaUIDaH9XoY8/IcFtXdAezhW6rBpzPqRdCK8BR3tBBI1rn9AyPC91gLcjxbHGuCp7u6ojhM',
      'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          '1480a241-8561-4b93-96f8-6256234cec26.snggle': 'rmW9Ho0uwdNpay+clLMjfnHU2G2oJC+62eyLiSzH1rtgBRQrYfPp17ALs3INyM7VMwrJDITY7TAxrbAsNvpkcafsmkkoUPFYjis47iMhLBcsL2O/jKpgdbTcomoU4Y+ccQaLAuz3nCREn53RRLrUoL+GhOo1dqD01CeovAVPPYYZMS/CAAh6kYk2rhb4vsQd60kdBA9MBAPRmBiute9UnLHYknJcoPqehz4taRNT0+wf1bXt3w8HMxc8v2QaxoXAKB429Un+qWo4bJ/aWK+PYMjF0m67H/zKXnOlcRD72RjodTjrUwZUXVLn9KkvBGJW/R2ignDezyOwBoGUoZm8ZwWSKxIqV4KFhmRi9lBdSwa8709D',
          '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
            'b944d651-5162-479b-a927-8fcd4f47e074.snggle': 'GstCuhSPckAEbNxJ4SF/VVv5F7A4IUS/2OVb4vkwXPnrykVStzc5IXpN3MDSHr0CzySdsdZv+Z2ynLKD/J8O5qJIiX6k23V2DlmwEvYT8LHnL+/hesSBBgcb3+ZakYZB+tfTL6jBWlDNruwhOpBMmWNdoBiXB/I4FF8+VZ0OLpfE3b1jJ3IKekNhyZpTuNC6ffmY4z1X+0DChXdtjIQnN8EChI2CBvPucNED5y0HOAZVfwm4THQwwO47bzY0FFLnVTwAB49vbPeA3+K60dCgFfTSYLIVZqpFQ3NamBQ/kDF4GF7RZ78kwPbY2hKd9i4byhE0UI/3KBtuiI9MtUYupl6E7pwODJNytxoSGZBAzIbSHFE/',
            'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
              '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'BEPaj2w7Fnj2+BlKhCsHK5aAifAgdm+ye4Eyx8apMOLci0SdTTp+/C9dJMszkcQ3SjqVsHUtJUXVKDZCWB28L+ooQb5hUKQeLIiGaO8B1pgY4KtLvV9P1JmjNy7TSDbdfH/ddpQ1Z60gm39vcDbhHMiCLU8rCrNeu3hhB9Tu2kkN+tBHjMn9rxwCuVnjIDjufAdzna8GXiF5yJTW6Nx6xW9zt0x0SyhPX4THfGd0QQIbVhQ1',
            },
          }
        },
      },
    },
  };

  Map<String, String> filledGroupsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.groups.name:'Dahf6fZt86Rk1JWB2bHFI1Gm6VwouPQQJZaYS7d3TOWODACEm/LB++EKMKT+Uu/5gMwBYtnbod9MH6dSbfwWNgkPjESjKcm0VPRVg4U0UgVAXQt0/ctApDgqsQ1uXU6sRUnGF7dW6ylAgIfTVFYoODmfoTEHQZnhvsatsgqVcskeACgpd08pfjbjbEsj+F0iAkhM8xV97kYKOtvATkYsy9zWz5mCML79F0fle6A7106h7KIEOxvXQ2bgxoMk6UmkLYkclHHd2n07FC2GkTBOUNXkUI89Nfx2I4sQBmd9OnoDqaghr8k/SHvg7shj6aLWu+JzHa/zxc/c3LmkiGGYJmeQA6c8lMjTv8Oouqv7GGZqjynZCwuu10rF8NhdJBXX5FmUK1TOgbD40vQB68Yt3eszx2/JUw59vUCCm6rFKRlC1EfxUkboOdNE3/FJVz6jf94N+C2bZRKDC9LBZL0tZWq+IjbxyhOeEHg3bQX3dkkjrOOUNCLAx7js+xgC5k+tgVc0XDiqFqa90Rj4fh41LZkxyRpL+jxsh5nRVXH5L1gTuP+0G7VFxW4k+u4yUEg8IygXy5JFPQuJx5zn7zi9FrCo2STMy13IofXdeCyXa1/EgNtg2fcndbaXIfzBIzrXax6Tz9hGzasb090DmKMMiKTuXZHafgzMT+KqsfL01BP3UDD3sqygC5OiymdrSaH/ItIcVrGt2H/LS4EnAYWEuu/WyPtJPxb9paxfMhVKj4Pk0Lh13XtT+pXDvD+IdQrAbCk7rMNHo1ofwtOXInpbmiTZY5/M99a3+XvKafI9eAdtWH8xPHRayQCbiI4hDo3jkl6TOzddRr4PKvPlOqIPiHkRR8JwSFjiHs8pGtmUKH41cS69bOF4mmi07kzQLbEKJkWZid2dGUhOqbc6z1/wRtD3S6ACVp29tHalOaIyh/T6C37RWGYZbCon5ORKCZFjjNqIzPlTQE+8UM91bsZ22w8YjfgHFPhmd9MgT4e8P0sHrsh2jHVId/nIU9z7VW8PrbXGPJHfVnIV5ZduGL921tT6WzAWUS55Jt/f9ZXqv2IPDm+gWCaOv2vN9kprgkdoC0i5VeocSN+bVb9zumAp/ERF9JJVcVe3BdEQxuLUqE0EmEa/7lO71DU26XmXL6M0CxjPodLOK7gfX6RAFequTJWlm20+6+Al8lwm5V6GyBeuHQ4P93Tztwk0WYfDFXXAbGpkYN5pmhDsyeb3L6AUjff7wIWWW63K7XSZUaYdcYCbPhp0thWYFzBg//ZfCGgCQr435/XetHaDxBPav4qiV+NHZ7QfgxEay4Io1OQY/xXdHG4fYw5KEMRbcgrubPK6RXP2q2yLIAcpvfst89xGPLUq8smo3z+IjNexx3eCRlxT2ZFIJPoT+1InrG2zV++IykWl9c8GB3FXQtcUFDbmEoS6n7w=',
    DatabaseParentKey.vaults.name:'BhInXa4ps9i/JlaiVgSrVsGp1mXDoUoQyLA0e/5iMetwNZ5WRnQlv8nrNjjkthbKGo9915CdHAsGQxYFs4bGLEjBja3rWVO1hWPUo/pnGevlfbeCgN5Y4NEQG6bz8RHHjaNLIeel/xj5unpaFt/eFg71fSsdUMrdlxd9vYPDTV2KPuDCrzq6PBikZQxwQ+RfXVhXtVRtmlza5KolYaaI2nBJpheKb6hm6P6XA9mTKLIB7i391bLDAZIndBkPpzvuC8HDXVPyAGi7ublguoPMG7qBLTNmt6Q83BMNAEDke/tgo5FTHUG5+HZ8ZqOphR0REd+xTis/gzxncdDheMkGFq/TAi0o+uM/N8s5E0alrjLa+1Mf',
    DatabaseParentKey.wallets.name: 'DtTL1lkRsCtec5BZoOn7CeRi5rF9WfTAUpno8tEfDxZEi7cDKoxBxwJalUv0nfClezacdypqvxSetuMI8V0jZO+u07w83K/x54mtuM+X8qUqzdqha8fIqdcZYV66iQUFmy0KH5seF7383bHuoEr1AFAMyLrWje+Em2LfBKKDtAXyJQFy1PlZ5tkodiMAQlfUqXS9KPXfmae6hSKQIebl2NPXdZWVYAQzxPivkaWh3w6lKeHoG0DRlwAHLD0O9AopRgOQ5hliPqSoWlelhFBWlGrMNh/hwMA27UErKawMswIYDMu9FvjqVMiAIXI7BUWqbf72SYBktXlkPY6WS7OE7Z4ezR9a6H1AwoK9L38SDrmwQ3MNiQU45PhstPbq1CpxTDP0AnY2pyNy/0vBgmJ5txFAVcI5hU+YjQsD3q51CNe4uO1kIvWlIFCFDmVhh8PqV+sSNswVUcL1KpKaEPVO1E4draDJalOFk9zV0X2KU1QUJ1NIjdvXTaNgwaY+bTRWgPDu5cHcPxSHHXX/7Tlr3tz+2m+ElqST1++fRQZD4YolLfyVHBIM9PqEYNDkzDpvZb6X1cXSJ8UZBnwSnet+Kd+zyH+uMhb5+zBPIFsbNvFoZGjD',
  };

  Map<String, String> emptyGroupsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.groups.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  setUp(() {
    globalLocator.allowReassignment = true;
    initLocator();

    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

    globalLocator.registerLazySingleton(() => actualSecretsRepository);
    globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);
  });

  group('Tests of initial database state', () {
    test('Should [return Map of groups] as ["groups" key value EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [return EMPTY map] as ["groups" key value is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyGroupsDatabase));

      // Act
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{};

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsService.getById()', () {
    test('Should [return GroupModel] if [group uuid EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getById('c01a1d77-8952-43b5-99fb-fb3b7c680db2');

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
        name: 'WORK',
        listItemsPreview: <AListItemModel>[
          VaultModel(
            encryptedBool: true,
            pinnedBool: true,
            index: 1,
            uuid: '92b43ace-5439-4269-8e27-e999907f4379',
            name: 'Test Vault 1',
            filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379'),
            listItemsPreview: <AListItemModel>[],
          ),
        ],
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [return NetworkGroupModel] if [group uuid EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getById('b944d651-5162-479b-a927-8fcd4f47e074');

      // Assert
      NetworkGroupModel expectedNetworkGroupModel = NetworkGroupModel(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkConfigModel: NetworkConfigModel.ethereum,
        listItemsPreview: <AListItemModel>[
          WalletModel(
            pinnedBool: true,
            encryptedBool: true,
            index: 0,
            address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
            derivationPath: "m/44'/118'/0'/0/0",
            network: 'kira',
            uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
            filesystemPath: FilesystemPath.fromString(
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074/4e66ba36-966e-49ed-b639-191388ce38de',
            ),
            name: 'WALLET 0',
          ),
        ],
      );

      expect(actualGroupModel, expectedNetworkGroupModel);
    });

    test('Should [return NULL] if [group uuid NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getById('non-existent-uuid');

      // Assert
      expect(actualGroupModel, null);
    });
  });

  group('Tests of GroupsService.getByPath()', () {
    test('Should [return GroupModel] if [group path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2');
      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getByPath(actualFilesystemPath);

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
        name: 'WORK',
        listItemsPreview: <AListItemModel>[
          VaultModel(
            encryptedBool: true,
            pinnedBool: true,
            index: 1,
            uuid: '92b43ace-5439-4269-8e27-e999907f4379',
            name: 'Test Vault 1',
            filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379'),
            listItemsPreview: <AListItemModel>[],
          ),
        ],
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [return NetworkGroupModel] if [group path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('b944d651-5162-479b-a927-8fcd4f47e074');
      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getByPath(actualFilesystemPath);

      // Assert
      NetworkGroupModel expectedNetworkGroupModel = NetworkGroupModel(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkConfigModel: NetworkConfigModel.ethereum,
        listItemsPreview: <AListItemModel>[
          WalletModel(
            pinnedBool: true,
            encryptedBool: true,
            index: 0,
            address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
            derivationPath: "m/44'/118'/0'/0/0",
            network: 'kira',
            uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
            filesystemPath: FilesystemPath.fromString(
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074/4e66ba36-966e-49ed-b639-191388ce38de',
            ),
            name: 'WALLET 0',
          ),
        ],
      );

      expect(actualGroupModel, expectedNetworkGroupModel);
    });

    test('Should [return NULL] if [group path NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('non-existent-path');

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getByPath(actualFilesystemPath);

      // Assert
      expect(actualGroupModel, null);
    });
  });

  group('Tests of GroupsService.getAllByPath()', () {
    test('Should [return List of GroupModel] if [given path HAS VALUES] (strict == TRUE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: true);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[
        GroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: '0a73e366-264a-462f-b86c-40865933a8cd',
          filesystemPath: FilesystemPath.fromString('0a73e366-264a-462f-b86c-40865933a8cd'),
          name: 'AIRDROPS',
          listItemsPreview: <AListItemModel>[],
        ),
        GroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
          name: 'WORK',
          listItemsPreview: <AListItemModel>[
            VaultModel(
              encryptedBool: true,
              pinnedBool: true,
              index: 1,
              uuid: '92b43ace-5439-4269-8e27-e999907f4379',
              name: 'Test Vault 1',
              filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379'),
              listItemsPreview: <AListItemModel>[],
            ),
          ],
        ),
      ];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return List of GroupModel] if [given path HAS VALUES] (strict == FALSE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: false);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[
        GroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: '0a73e366-264a-462f-b86c-40865933a8cd',
          filesystemPath: FilesystemPath.fromString('0a73e366-264a-462f-b86c-40865933a8cd'),
          name: 'AIRDROPS',
          listItemsPreview: <AListItemModel>[],
        ),
        GroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
          name: 'WORK',
          listItemsPreview: <AListItemModel>[
            VaultModel(
              encryptedBool: true,
              pinnedBool: true,
              index: 1,
              uuid: '92b43ace-5439-4269-8e27-e999907f4379',
              name: 'Test Vault 1',
              filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379'),
              listItemsPreview: <AListItemModel>[],
            ),
          ],
        ),
        NetworkGroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
          filesystemPath: FilesystemPath.fromString(
            'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          ),
          listItemsPreview: <AListItemModel>[
            WalletModel(
              pinnedBool: true,
              encryptedBool: true,
              index: 0,
              address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
              derivationPath: "m/44'/118'/0'/0/0",
              network: 'kira',
              uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
              filesystemPath: FilesystemPath.fromString(
                'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074/4e66ba36-966e-49ed-b639-191388ce38de',
              ),
              name: 'WALLET 0',
            ),
          ],
          networkConfigModel: NetworkConfigModel.ethereum,
        ),
        GroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: '1480a241-8561-4b93-96f8-6256234cec26',
          filesystemPath: FilesystemPath.fromString(
            'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26',
          ),
          name: 'ETHEREUM BASED',
          listItemsPreview: <AListItemModel>[
            NetworkGroupModel(
              pinnedBool: false,
              encryptedBool: false,
              uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
              filesystemPath: FilesystemPath.fromString(
                'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
              ),
              listItemsPreview: <AListItemModel>[],
              networkConfigModel: NetworkConfigModel.ethereum,
            ),
          ],
        ),
      ];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (strict == TRUE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyGroupsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: true);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (strict == FALSE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyGroupsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: false);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[];

      expect(actualGroupModelList, expectedGroupModelList);
    });
  });

  group('Tests of GroupsService.move()', () {
    test('Should [MOVE group] if [group EXISTS] in collection (GroupModel)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      await globalLocator<GroupsService>().move(
        GroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: '0a73e366-264a-462f-b86c-40865933a8cd',
          filesystemPath: FilesystemPath.fromString('0a73e366-264a-462f-b86c-40865933a8cd'),
          name: 'AIRDROPS',
          listItemsPreview: <AListItemModel>[],
        ),
        FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
      );

      // Act
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [MOVE group] if [group EXISTS] in collection (NetworkGroupModel)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      await globalLocator<GroupsService>().move(
        NetworkGroupModel(
          pinnedBool: false,
          encryptedBool: false,
          uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
          filesystemPath: FilesystemPath.fromString(
            'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          ),
          listItemsPreview: <AListItemModel>[],
          networkConfigModel: NetworkConfigModel.ethereum,
        ),
        FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
      );

      // Act
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'type': 'network',
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path': 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/b944d651-5162-479b-a927-8fcd4f47e074',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        }
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsService.moveByParentPath()', () {
    test('Should [MOVE groups] with provided parent path', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      await globalLocator<GroupsService>().moveByParentPath(
        FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'),
        FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379'),
      );

      // Act
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsService.save()', () {
    test('Should [UPDATE GroupModel] if [group UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      GroupModel updatedGroupModel = GroupModel(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
        name: 'UPDATED GROUP',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<GroupsService>().save(updatedGroupModel);
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': true,
          'encrypted': true,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'UPDATED GROUP',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [UPDATE NetworkGroupModel] if [group UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      NetworkGroupModel updatedNetworkGroupModel = NetworkGroupModel(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkConfigModel: NetworkConfigModel.kira,
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<GroupsService>().save(updatedNetworkGroupModel);
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Kira',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'kira'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        }
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [SAVE GroupModel] if [group UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyGroupsDatabase));

      GroupModel newGroupModel = GroupModel(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
        name: 'NEW GROUP',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<GroupsService>().save(newGroupModel);
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': true,
          'encrypted': true,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'NEW GROUP',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [SAVE NetworkGroupModel] if [group UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyGroupsDatabase));

      NetworkGroupModel newNetworkGroupModel = NetworkGroupModel(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkConfigModel: NetworkConfigModel.kira,
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<GroupsService>().save(newNetworkGroupModel);
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': true,
          'encrypted': true,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Kira',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'kira'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsService.deleteAllByParentPath()', () {
    test('Should [REMOVE groups] if [groups with path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      await globalLocator<GroupsService>().deleteAllByParentPath(
        FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'),
      );
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [REMOVE ALL groups] if [path EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      await globalLocator<GroupsService>().deleteAllByParentPath(const FilesystemPath.empty());
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{};

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsService.deleteById()', () {
    test('Should [REMOVE group] if [group UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledGroupsDatabase));

      // Act
      await globalLocator<GroupsService>().deleteById('0a73e366-264a-462f-b86c-40865933a8cd');
      String? actualEncryptedGroupsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedGroupsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedGroupsKeyValue!);
      Map<String, dynamic> actualGroupsMap = jsonDecode(actualDecryptedGroupsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyGroupsDatabase));

      // Assert
      expect(
        () => globalLocator<GroupsService>().deleteById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    TestUtils.clearCache(testSessionUUID);
  });
}