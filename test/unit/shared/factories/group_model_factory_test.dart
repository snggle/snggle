import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;

  setUp(() {
    // @formatter:off
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      secureStorageContent: <String, String>{
        SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
        SecureStorageKey.groups.name:'Dahf6fZt86Rk1JWB2bHFI1Gm6VwouPQQJZaYS7d3TOWODACEm/LB++EKMKT+Uu/5gMwBYtnbod9MH6dSbfwWNgkPjESjKcm0VPRVg4U0UgVAXQt0/ctApDgqsQ1uXU6sRUnGF7dW6ylAgIfTVFYoODmfoTEHQZnhvsatsgqVcskeACgpd08pfjbjbEsj+F0iAkhM8xV97kYKOtvATkYsy9zWz5mCML79F0fle6A7106h7KIEOxvXQ2bgxoMk6UmkLYkclHHd2n07FC2GkTBOUNXkUI89Nfx2I4sQBmd9OnoDqaghr8k/SHvg7shj6aLWu+JzHa/zxc/c3LmkiGGYJmeQA6c8lMjTv8Oouqv7GGZqjynZCwuu10rF8NhdJBXX5FmUK1TOgbD40vQB68Yt3eszx2/JUw59vUCCm6rFKRlC1EfxUkboOdNE3/FJVz6jf94N+C2bZRKDC9LBZL0tZWq+IjbxyhOeEHg3bQX3dkkjrOOUNCLAx7js+xgC5k+tgVc0XDiqFqa90Rj4fh41LZkxyRpL+jxsh5nRVXH5L1gTuP+0G7VFxW4k+u4yUEg8IygXy5JFPQuJx5zn7zi9FrCo2STMy13IofXdeCyXa1/EgNtg2fcndbaXIfzBIzrXax6Tz9hGzasb090DmKMMiKTuXZHafgzMT+KqsfL01BP3UDD3sqygC5OiymdrSaH/ItIcVrGt2H/LS4EnAYWEuu/WyPtJPxb9paxfMhVKj4Pk0Lh13XtT+pXDvD+IdQrAbCk7rMNHo1ofwtOXInpbmiTZY5/M99a3+XvKafI9eAdtWH8xPHRayQCbiI4hDo3jkl6TOzddRr4PKvPlOqIPiHkRR8JwSFjiHs8pGtmUKH41cS69bOF4mmi07kzQLbEKJkWZid2dGUhOqbc6z1/wRtD3S6ACVp29tHalOaIyh/T6C37RWGYZbCon5ORKCZFjjNqIzPlTQE+8UM91bsZ22w8YjfgHFPhmd9MgT4e8P0sHrsh2jHVId/nIU9z7VW8PrbXGPJHfVnIV5ZduGL921tT6WzAWUS55Jt/f9ZXqv2IPDm+gWCaOv2vN9kprgkdoC0i5VeocSN+bVb9zumAp/ERF9JJVcVe3BdEQxuLUqE0EmEa/7lO71DU26XmXL6M0CxjPodLOK7gfX6RAFequTJWlm20+6+Al8lwm5V6GyBeuHQ4P93Tztwk0WYfDFXXAbGpkYN5pmhDsyeb3L6AUjff7wIWWW63K7XSZUaYdcYCbPhp0thWYFzBg//ZfCGgCQr435/XetHaDxBPav4qiV+NHZ7QfgxEay4Io1OQY/xXdHG4fYw5KEMRbcgrubPK6RXP2q2yLIAcpvfst89xGPLUq8smo3z+IjNexx3eCRlxT2ZFIJPoT+1InrG2zV++IykWl9c8GB3FXQtcUFDbmEoS6n7w=',
        SecureStorageKey.vaults.name:'BhInXa4ps9i/JlaiVgSrVsGp1mXDoUoQyLA0e/5iMetwNZ5WRnQlv8nrNjjkthbKGo9915CdHAsGQxYFs4bGLEjBja3rWVO1hWPUo/pnGevlfbeCgN5Y4NEQG6bz8RHHjaNLIeel/xj5unpaFt/eFg71fSsdUMrdlxd9vYPDTV2KPuDCrzq6PBikZQxwQ+RfXVhXtVRtmlza5KolYaaI2nBJpheKb6hm6P6XA9mTKLIB7i391bLDAZIndBkPpzvuC8HDXVPyAGi7ublguoPMG7qBLTNmt6Q83BMNAEDke/tgo5FTHUG5+HZ8ZqOphR0REd+xTis/gzxncdDheMkGFq/TAi0o+uM/N8s5E0alrjLa+1Mf',
        SecureStorageKey.wallets.name: 'DtTL1lkRsCtec5BZoOn7CeRi5rF9WfTAUpno8tEfDxZEi7cDKoxBxwJalUv0nfClezacdypqvxSetuMI8V0jZO+u07w83K/x54mtuM+X8qUqzdqha8fIqdcZYV66iQUFmy0KH5seF7383bHuoEr1AFAMyLrWje+Em2LfBKKDtAXyJQFy1PlZ5tkodiMAQlfUqXS9KPXfmae6hSKQIebl2NPXdZWVYAQzxPivkaWh3w6lKeHoG0DRlwAHLD0O9AopRgOQ5hliPqSoWlelhFBWlGrMNh/hwMA27UErKawMswIYDMu9FvjqVMiAIXI7BUWqbf72SYBktXlkPY6WS7OE7Z4ezR9a6H1AwoK9L38SDrmwQ3MNiQU45PhstPbq1CpxTDP0AnY2pyNy/0vBgmJ5txFAVcI5hU+YjQsD3q51CNe4uO1kIvWlIFCFDmVhh8PqV+sSNswVUcL1KpKaEPVO1E4draDJalOFk9zV0X2KU1QUJ1NIjdvXTaNgwaY+bTRWgPDu5cHcPxSHHXX/7Tlr3tz+2m+ElqST1++fRQZD4YolLfyVHBIM9PqEYNDkzDpvZb6X1cXSJ8UZBnwSnet+Kd+zyH+uMhb5+zBPIFsbNvFoZGjD',
      },
      filesystemStorageContent: <String, dynamic>{
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
      }
    );
    // @formatter:on
  });

  group('Tests of GroupModelFactory.createNewGroup()', () {
    test('Should [return GroupModel] with [randomly generated UUID]', () async {
      // Act
      GroupModel actualGroupModel = globalLocator<GroupModelFactory>().createNewGroup(
        parentFilesystemPath: FilesystemPath.fromString('test/path'),
        name: 'NEW GROUP',
      );

      // Assert
      expect(actualGroupModel.pinnedBool, false);
      expect(actualGroupModel.encryptedBool, false);
      expect(actualGroupModel.uuid, isNotNull);
      expect(actualGroupModel.filesystemPath, isNotNull);
      expect(actualGroupModel.name, 'NEW GROUP');
    });
  });

  group('Tests of GroupModelFactory.createFromEntity()', () {
    test('Should [return GroupModel] with values from given GroupEntity', () async {
      // Arrange
      GroupEntity actualGroupEntity = GroupEntity(
        pinnedBool: false,
        encryptedBool: false,
        uuid: '1480a241-8561-4b93-96f8-6256234cec26',
        name: 'ETHEREUM BASED',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26',
        ),
      );

      // Act
      GroupModel actualGroupModel = await globalLocator<GroupModelFactory>().createFromEntity(actualGroupEntity);

      // Assert
      GroupModel expectedGroupModel = GroupModel(
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
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [return NetworkGroupModel] with values from given NetworkGroupEntity', () async {
      // Arrange
      NetworkGroupEntity actualNetworkGroupEntity = NetworkGroupEntity(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        name: 'Ethereum',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkId: 'ethereum',
      );

      // Act
      GroupModel actualGroupModel = await globalLocator<GroupModelFactory>().createFromEntity(actualNetworkGroupEntity);

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
  });

  tearDownAll(() {
    testDatabase.close();
  });
}