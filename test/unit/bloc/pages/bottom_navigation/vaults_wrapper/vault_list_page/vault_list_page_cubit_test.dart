import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
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
      '37c1345a-fa7e-42b3-a7db-53a3308300c7.snggle': '9qqRbFOUuzjic5e8IBZiDhj1TYGD82zgfVskgYBN/ppNUcLvz5/fgcpxgENLJY/H7fflNEfo/KgLqC1npYq95uweVeZy4KCFSt6yhMORk0HK5owUFfj65uQXw8itFMpfvjq2VkecyDByfz1Mvdd/irmxQOC8W9k54tDgstivs31m0ZULlxwwOG5vaHx9ZGtIdDdel0wSYxBNIWfxvfkNEosIujZd/v3S+6GYX4EqKjRFC05h',
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'L0qHxmfOFe+9h74DtBK+PYnT/qfMYLR1FLjEh0HlO+HGnmr94D8BLzxS2jn1h8udjJN2xoKrBadxbieQcWcKiOXe1qaPobOpNAp3/yu9Rs54m0gQPZYYXyLpIknFvVV1hiVUTG8UusPlSJnQqInzj5q1t0nRjvLpbKB+wNyZHfi1esrj5xn5hfR4tOGldR1Qp/CVeoul9O9ufwko0ObSqqtgNklFYPR+A4qljEEYKiNyv946',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'CZ96LFNk1SuswWVkcX3jR5fnmEE1GbaXnAjiYVx1U63P0LHV/3n7Xgd2Qw79z7OuB1788dYvUdWMMOyAv00okB9DgQcAJIJzR2GjbGHSoPbulCTVCk/1O1w2KBFvvRlYKSpxTof1tsr8/KGR5bdlL7a7rqKBZNkWodwYnuDoWBPQCnEtyD8P1YoJofCCtaTbjiuLWCkiu/u/AkgPhhTD8vRM5zC64n07HiwZpsfA+OYJjwG0',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'CGi4mcSabNRPg+PUjuk170aFtHb1QdocoNmHdWZcX3gjjn6Hysc7t5f/khR6LGRJjXdnFPdxMUAvom5tTpo94JTmyz3hVcmv39Pnevazb2O8uzlW49YaVjDc3Zk28OI8q6q1tc1ADLLesiOHDE1BoiYeLV8=',
      },
      'e527efe1-a05b-49f5-bfe9-d3532f5c9db9.snggle': 'am5KJVWm97P0RBMLBPR90VWBq0JAD8SrKPVFeDNTpMC9YMaRSrOXZvpOpMyIHuTuZ+tdjqzqISXu1ortipy4+c0MOt856yrCxwLVRWR7uAyEyS0Jq0atePB1R/f+5Vv5g7wE0PUxjFKNVMShtQ48XKE+YMVh3fbqi7wJBjm5IQbergKCnSGUK57wCWctlNa2MXLnCg==',
      'e527efe1-a05b-49f5-bfe9-d3532f5c9db9': <String, dynamic>{
        '438791a4-b537-4589-af4f-f56b6449a0bb.snggle': 'v9dqwspRaZwWPf4SnIPsQclu55+3m/zc4IKd7/1FGWBjOF1nNRMeC1wgUF2PkvkP3U+mJkU95WrLHxQbYDXkR7aFXtN9hBDt7Q2+MBhma1pOFYGzhzKrZGWiFAhdWOEV3a52Ep/Y6yMw/dJgf0HhauPBPfeekB+9KxogtVXiTVZQNqQJ7luw00l2blf9sf9oh/Nb4U/PKZZtCWe3fn+Bc4vg2WjYQISoDKUG7fVgBuj1V9CC',
        '438791a4-b537-4589-af4f-f56b6449a0bb': <String, dynamic>{
          '3e7f3547-d78f-4dda-a916-3e9eabd4bfee.snggle': 'CGi4mcSabNRPg+PUjuk170aFtHb1QdocoNmHdWZcX3gjjn6Hysc7t5f/khR6LGRJjXdnFPdxMUAvom5tTpo94JTmyz3hVcmv39Pnevazb2O8uzlW49YaVjDc3Zk28OI8q6q1tc1ADLLesiOHDE1BoiYeLV8=',
        }
      },
    },
  };

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'GiMJ0lPeKX/8cY7br09M+0arX3ikofUyHhh9M4fzVI64AyavV1XTwL3AWmP4dCQOIVRgIgm2M5CfRX/JN0d/uzIpVVQyLhZRJYCbr633tt+BNVh652kPKPfbVFpPcMnWJ9NyGk7oJ3mTRjmtWVBEooRZ6CzuWdBXH91N65jHAy2xbtKpcdkjNdQ0tEbEpnEEn4RwJcsGcJ6lrvQZv3vdvgyj2jWmiBCz6Nu4jOyNiJ7GMlMn/6ykQm27Lfg6/3RQUKHn2tAJxgZuTebCDsiaACQzXf58FghUojqRVpb6AJRowLYiwdd+UOHydKTBRBXlr2uPbHRu9PKg6129WseEligEG4nBi3fcNtf8Cy9FD7JOsqV1zb3UIV4gYPvULAdIFLT0MqFxKbL0XG68TITOAZj07EJzWaobaEZfe+7bzaggXi+eFQ8ucFVuOB7LsfRTvtmHRRja3C7Kpt9tjFSlRuPfT7egW5zA4UBsCOwYtGc0BMNJeSnrLuQT+Uk7BzbnMElTTZxWBamb+L75jWv3Hr45rsfdIN9T9DRhOG3VE33kJSV3mD9M56dkBOm10PsL3PehUFw+0BJA+4rbiXZ0ciFu1ojRUlTazriO6eQPMTJDfR70/vLFEN7KCCRCClPSRibyTFUjJeBdQ+lzBpctYyfUz9welPcsp+dLcwvyGt1asVE3PhpXvBbv3NW57GXNAz799H6Pr4rZwMgMS+NJi3sADJIVON4qrwF8Jj7PdX2gzgcA6abph9xidTtxESAS3/IxbpqrVUBetnjqRthDALhoN4yVsDOKm7LiwhIoqEj9T5TmtAG2L0GN/B2gFL6n//ncHXSF2QqmmrGpMtBqhikvU3PUKuO6KtSiLePOnuN4mf53m46fQQb+yF7XOFotHKFrKCeJQWlU782yJXrwmI8/TUYjFDWAVwqDqdvOjNxE2xvEORExAsLCzJgbIPhm/EdtEZSP79JhfBimKVkoYXGfkPkPKmKkGY4S1MfbX0z8Qz4x8pEKpaWOGW0hf/P15FHGTNTXUm81FxAZj05Rdj7ucvKV7Ag4/TU2j9xeJWjB1XzhnVRWR/lVQGbR+sJ2b9NpFOkHTRh1pXBUkR13DrJnh5pi80PBnH4q6eavpeJbxBKIgD6TINJHT8A1qwoyofI+O41U3WRzf4cyK6tV3gB8vgIXu2lztY9BUpzMVEn+9CBK',
    DatabaseParentKey.wallets.name: '/i0RGBKFRiOiJupe5Nth8cyjO+7fNuJXZPYDN9wUH5myO34P0oSwxdGlvnzXchL7ag/lRYMDMiAkciTwhwQY7290UPatMtthKK/FSttmY9gNSKTnhEJg4pfkcaQ65UZxh9hB9s3OdUoFk+Rs3RFcm1VcQsLVADeJrMk4nAJq3q/h9ogJOhjpbGrhBzwJS7gu34PE4RqZc66lzy9pW0UmwdAKn87ZfNuKatnvqO7/sQODLA3gTc62ZwzJL+krlW+nd19WzaGmrcugKb64SSaeNk0ftww4OyIbICUU1lIWqeFb0Mx1//mLx3pcHTmAXRnGP8tnb0ZsV3BRQr2/IsHTIiE7/gMz4lbfRiE7midD6FwK72sRdoZbk1kT07nStTuHKzxPvbD88yzL6Gb9yh7fef4N8Tzgyczp7k7tyc0zJUxTpz0tMTKEXvqhod6dPNJ3xAR08QUCTsHpBPFubzJuo4zy1o0DkSBZyHXK9uxfdEh4ixtsSFp6yw52vlY4xATK4gQcj1avVgeu3tLB0We9o94AKO/91Sbip2P06M0B8OcqCYpv8a2Ef6NPooG3oe3nSu+d3W3kVF3qFgvCm5rLXgJLaE+KYChBAsWZb4qQb6SdXxzO98hKLEPGu11WscnLm1DznCxn+SC5A+T8oY1hIw3tf3FKnJbts3n9GmkNlp+JKt/TmebY0ocVsQqLqBagjB7Mm4e5tu32Yax4qgYuO/4vYEuEZWIr1btNXlk8Z9WKadfIgrVDL/QGnlwQYzCg7TVPfhPb1LPYLaYPE56F+vJXjShwlqgf8V5eaRphJYmhF9Vr6BIsuMUoPzZPWy0ImQLI8S/vYmTMLRqaYuR9e+O4jvnxVh2A/7od7LarUfxUXCx/duFViLEFJ3z/jFRsBxCxQWgsFi5+rjpg7WpP8huDZgcB1BlKtr9fJiDB7YiXgKRSvCaRCp2FyVGG7yDyMrZylVIII8NstIfpzUy0Rrojc30=',
    DatabaseParentKey.groups.name: 'V1CXyYCBQ1W2D7foBSyWbm/mikejFO3c5JkDvxGrjIyIHJmZAuBFCGxbht32sQxzJzSFcHzfDbm3PWG6jhg6zLf9fEDW2e6DKyIwtaSQIJ9WfUcmavlFVG7T12V6VmpyvQIQVBiYNcyy+6zgILjnm4l3jtLHpK+/lS4Z+yzFdy2akXRsOO650clrFyeBeOV7maqfeYVpDXk5g1o4DG2DWufHVA5SxO/N5rON2tXawifdJQsWpBgKBElszopj/EXlfBBg8UtTa2x33PKqXI98pQjJPEZDBEjk2tSI7jP5HfNXsZr+',
  };
  // @formatter:on

  VaultModel vaultModel1 = VaultModel(
    index: 1,
    pinnedBool: true,
    encryptedBool: true,
    uuid: '92b43ace-5439-4269-8e27-e999907f4379',
    filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
    name: 'Test Vault 1',
    listItemsPreview: <AListItemModel>[],
  );

  VaultModel vaultModel2 = VaultModel(
    index: 2,
    pinnedBool: true,
    encryptedBool: true,
    uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
    filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
    name: 'Test Vault 2',
    listItemsPreview: <AListItemModel>[
      WalletModel(
        encryptedBool: false,
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        name: 'WALLET 0',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093/4e66ba36-966e-49ed-b639-191388ce38de'),
      ),
    ],
  );

  VaultModel updatedVaultModel2 = VaultModel(
    index: 2,
    pinnedBool: true,
    encryptedBool: true,
    uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
    filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
    name: 'UPDATED VAULT',
    listItemsPreview: <AListItemModel>[
      WalletModel(
        encryptedBool: false,
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        name: 'WALLET 0',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093/4e66ba36-966e-49ed-b639-191388ce38de'),
      ),
    ],
  );

  VaultModel vaultModel3 = VaultModel(
    index: 3,
    pinnedBool: true,
    encryptedBool: true,
    uuid: '438791a4-b537-4589-af4f-f56b6449a0bb',
    filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb'),
    name: 'Test Vault 3',
    listItemsPreview: <AListItemModel>[],
  );

  VaultModel vaultModel4 = VaultModel(
    index: 4,
    pinnedBool: true,
    encryptedBool: true,
    uuid: '37c1345a-fa7e-42b3-a7db-53a3308300c7',
    filesystemPath: FilesystemPath.fromString('37c1345a-fa7e-42b3-a7db-53a3308300c7'),
    name: 'Test Vault 4',
    listItemsPreview: <AListItemModel>[],
  );

  GroupModel groupModel = GroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9',
    filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
    name: 'WORK',
    listItemsPreview: <AListItemModel>[vaultModel3],
  );

  GroupModel updatedGroupModel = GroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9',
    filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
    name: 'WORK',
    listItemsPreview: <AListItemModel>[vaultModel3],
  );

  late VaultListPageCubit actualVaultListPageCubit;

  group('Tests of VaultListPageCubit basic operations', () {
    setUpAll(() {
      globalLocator.allowReassignment = true;
      initLocator();

      TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
        rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
        databaseParentKey: DatabaseParentKey.secrets,
      );

      SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

      globalLocator.registerLazySingleton(() => actualSecretsRepository);
      globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

      actualVaultListPageCubit = VaultListPageCubit(
        depth: 0,
        filesystemPath: const FilesystemPath.empty(),
      );
    });

    group('Tests of VaultListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualVaultListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of VaultListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all vaults existing in database', () async {
        // Act
        await actualVaultListPageCubit.refreshAll();
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel2, vaultModel4, groupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single VAULT', () async {
        // Arrange
        VaultModel actualVaultListItemModel = vaultModel2;

        // Update vault in database to check if it will be updated in the state
        await globalLocator<VaultsService>().save(updatedVaultModel2);

        // Act
        await actualVaultListPageCubit.refreshSingle(actualVaultListItemModel);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, groupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        GroupModel actualGroupModel = groupModel;

        // Update group in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualVaultListPageCubit.refreshSingle(actualGroupModel);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all items SELECTED]', () async {
        // Act
        actualVaultListPageCubit.toggleSelectAll();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          ),
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all items UNSELECTED] if all items were selected before', () async {
        // Act
        actualVaultListPageCubit.toggleSelectAll();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 4),
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified VAULT selected', () async {
        // Act
        actualVaultListPageCubit.selectSingle(vaultModel1);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[vaultModel1],
          ),
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualVaultListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[vaultModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified VAULT unselected', () async {
        // Act
        actualVaultListPageCubit.unselectSingle(vaultModel1);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[updatedGroupModel], allItemsCount: 4),
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualVaultListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 4),
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualVaultListPageCubit.disableSelection();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel4, updatedVaultModel2, updatedGroupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[vaultModel1, updatedVaultModel2, updatedGroupModel],
          pinnedBool: true,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            vaultModel1.copyWith(pinnedBool: true),
            vaultModel4,
            updatedVaultModel2.copyWith(pinnedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected vaults (pinnedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            vaultModel1.copyWith(pinnedBool: true),
            updatedVaultModel2.copyWith(pinnedBool: true),
          ],
          pinnedBool: false,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel4,
            updatedGroupModel.copyWith(pinnedBool: false),
            vaultModel1.copyWith(pinnedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected items (encryptedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            vaultModel1.copyWith(pinnedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel4,
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            vaultModel1.copyWith(pinnedBool: false, encryptedBool: true),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected VAULT (encryptedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.unlockSelection(
          selectedItem: vaultModel1.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel4,
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            vaultModel1.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel4,
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            vaultModel1.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted VAULT', () async {
        // Act
        await actualVaultListPageCubit.deleteItem(vaultModel1);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel4,
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualVaultListPageCubit.deleteItem(updatedGroupModel);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel4,
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(() {
      TestUtils.clearCache(testSessionUUID);
    });
  });

  group('Tests of VaultListPage groups process', () {
    setUpAll(() {
      globalLocator.allowReassignment = true;
      initLocator();

      TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
        rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
        databaseParentKey: DatabaseParentKey.secrets,
      );

      SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

      globalLocator.registerLazySingleton(() => actualSecretsRepository);
      globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

      actualVaultListPageCubit = VaultListPageCubit(
        depth: 0,
        filesystemPath: const FilesystemPath.empty(),
      );
    });

    group('Tests of VaultListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualVaultListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of VaultListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all vaults existing in database', () async {
        // Act
        await actualVaultListPageCubit.refreshAll();
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel2, vaultModel4, groupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.moveItem()', () {
      test('Should [emit ListState] with VAULT moved into GROUP', () async {
        // Act
        await actualVaultListPageCubit.moveItem(vaultModel1, groupModel.filesystemPath);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel2,
            vaultModel4,
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                vaultModel1.copyWith(filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9/92b43ace-5439-4269-8e27-e999907f4379')),
                vaultModel3,
              ],
            ),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualVaultListPageCubit.groupItems(vaultModel2, vaultModel4, 'TEST GROUP');

        ListState actualListState = actualVaultListPageCubit.state;

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

  group('Tests of VaultListPage navigation process', () {
    setUpAll(() {
      globalLocator.allowReassignment = true;
      initLocator();

      TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
        rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
        databaseParentKey: DatabaseParentKey.secrets,
      );

      SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

      globalLocator.registerLazySingleton(() => actualSecretsRepository);
      globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

      actualVaultListPageCubit = VaultListPageCubit(
        depth: 0,
        filesystemPath: const FilesystemPath.empty(),
      );
    });

    group('Tests of VaultListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualVaultListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of VaultListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all vaults existing in database', () async {
        // Act
        await actualVaultListPageCubit.refreshAll();
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel2, vaultModel4, groupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualVaultListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            vaultModel3.copyWith(listItemsPreview: <AListItemModel>[
              WalletModel(
                encryptedBool: false,
                pinnedBool: true,
                index: 0,
                address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
                derivationPath: "m/44'/118'/0'/0/1",
                network: 'ethereum',
                uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
                name: 'WALLET 0',
                filesystemPath: FilesystemPath.fromString(
                  'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb/3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
                ),
              ),
            ]),
          ],
          filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualVaultListPageCubit.navigateBack();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, vaultModel2, vaultModel4, groupModel],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualVaultListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            vaultModel3.copyWith(listItemsPreview: <AListItemModel>[
              WalletModel(
                encryptedBool: false,
                pinnedBool: true,
                index: 0,
                address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
                derivationPath: "m/44'/118'/0'/0/1",
                network: 'ethereum',
                uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
                name: 'WALLET 0',
                filesystemPath: FilesystemPath.fromString(
                  'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb/3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
                ),
              ),
            ]),
          ],
          filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(() {
      TestUtils.clearCache(testSessionUUID);
    });
  });
}