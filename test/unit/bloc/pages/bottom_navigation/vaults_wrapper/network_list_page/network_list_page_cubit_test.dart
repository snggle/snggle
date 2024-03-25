import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
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
import 'package:snggle/shared/models/selection_model.dart';
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
        'b944d651-5162-479b-a927-8fcd4f47e074.snggle': 'BEPaj2w7Fnj2+BlKhCsHK5aAifAgdm+ye4Eyx8apMOLci0SdTTp+/C9dJMszkcQ3SjqVsHUtJUXVKDZCWB28L+ooQb5hUKQeLIiGaO8B1pgY4KtLvV9P1JmjNy7TSDbdfH/ddpQ1Z60gm39vcDbhHMiCLU8rCrNeu3hhB9Tu2kkN+tBHjMn9rxwCuVnjIDjufAdzna8GXiF5yJTW6Nx6xW9zt0x0SyhPX4THfGd0QQIbVhQ1',
        'ebce2609-1d13-4d1e-aa83-925d55827c87.snggle': 'NMKLbqOpoFWNsCYD0EcdnC1R0eRqRzkJhkdAVqVzporYJatt97PM4hWPJqzhAL+9ZKnlb6ek1AkKcvAGlAUNgJCeUPxj3gFf2SIoieOy8zeT4N76dZxk+Yo21ZUS8L+Zuh/u7VtMgzMN/s2Ooh71cUmOB2mWkMEuW0uZLnCtI6QJS1Ty6WWKrzcz1oEj7k+QGJsVwrDAyKZO9d8n8y5Iy0iAC/1M6OGqtbWfQrKA9sI4ErCu',
        '6fafeb9b-dc37-434a-8330-ffbf6edd5d09.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo',
        'e527efe1-a05b-49f5-bfe9-d3532f5c9db9.snggle':  '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
        'e527efe1-a05b-49f5-bfe9-d3532f5c9db9': <String, dynamic>{
          'e5acac35-0ab2-4132-a9c5-877a805e361a.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
        }
      },
    },
  };

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.groups.name:'T+nA200ad4AB1ifG5L5vbs5kJ7vwGTep/RTz6hxnbCnih6dXacLPejKiU8laVeBlgFI0iGIk5YeMZe4gUMYeoAPbdV/AqsXGRCgkt4AdVFGYjUa4hn+LK+D63Ma8Pl/M2+zNzZdG9bA4PGzT/7Dr3RsDn6ZbLUizdHxnC4NLo9nXtjZxRXc/aX0BOv84PJ/2bp2y3DTXbUr0KMkjjc6wQW8ZRGFTtDl7TMX7JLkahJEepMMnzv6OZQ+AJgI63o9zx59WMrXCmiq3yCg6U1yadfDZcviTXL9kP4QKwn8w+DxGxbaz3YEie68HB6T0mfKrk1paShRhfcWbyIur33+rO6xcY+oZ4KJ+xOT8+d7pZrPrd+wasWeKfjMDvjyi48lbXTVPFPKmRh/jhVuLj6kSpi+MsTiyHSQH4drY2qgFoYIFLuwZnxzuNchMvELvrPr1RRAt/tBW6feQF+ITXDVU102ry9F3QfKMcnTuZop08ZY/248gwkXKJj45wLL1K97dGo/FmftJmrT3UjCPLNXpl/yd+v1etukoo7e4WxW8PMtlrYChWC5cS32C+gNQ+XXREOaNILZfllekVuTLa75yw48ZGMVx4+jMeX3N5WU5bB+SAJrkQPAJsLzpq4S2DVtIDXrOszk7s5o5gd860lsNo3+olx+r/dCKrQbGF62sPXjBX86yL5uIeH6/MgLSJVLgA74zjGpB5zOba5wndhjC/7A6HqB1CoJ5tzOCnV/ojf05xxYH66jShDGMLOkRa73UQBgsIEeErfBI9PEGIGqYZaMG6oRpNGk01TJIMqf5R8E2e15CynuGmTjwNN3zv6tQTo0iE9CAvWq2QLngpZebJLnHIiy3flsd5x7hxcVZkA3DOnc+VDnLi/YWq6mkeYEeh0429wj8NPZXw9usw9AY6ewPzQYKuBKLN9HxdJiCvzE9hymWgkZOCLr+0RtiTiMF8Ons8vMGnWE6hR/qwoLVlsrqmBFeyqfizhitCZcXBdQ9N+pNClJ/CAEgqGXN5s08qJJ1zcE8gzbt8yE8fhBk8mNguldj5cxyU+69/xwzR80IZpJb8LJyOnIbOuoDeg81swzGiEuxKI+02DDFwNONzGENG9qMceXTw1F094QBpvS1Y3vXQ2Zmrak6g9IsbnwJ738ECqJG+jaBTEXqEuU1SMm7IfC18kJd807RVoAIVxy7VFeRq7IvKMS1l2j3wFEVmImMHx08VUc/N46ALPhFqHqGLy0xjadQ/5UKL9bXXKUW2NYVJ/WrDQhJkJhqY6IaTZbvOrCi4WfeNepUbCXtDQs/k0ARrrweSN8gV8TYyL1d4831I9U4CBwzWcs1UvqZ6HijZf02o/OeLfxuPo9yU5ak4kHGEiYShq5bT0l8D4lRwGofvUa3i5r4ZZ7OGIm32p5AzryQ+E9h9nEq8RaHwuFMCahngTFM8bHOqDSE0xEFaY/4opgiRuBEck/L1tXOuc3y9QRvMd2IlqWSHUkDS9FNZKfOklCXqhQuPL4L+RZHy4zWXPu0ui2ltCekbONgOQKLNv68ohwx8cIwiLbdSJsyOJiFYetkfwbSobv0eNmhYCjwb8/KjXsZKrdMkDuHQf+a5sx9F94uN4bAIo6E0/QO4pbxob0slFFURjaFRVBV5K3pLWJ4qMW0L3UiqXdwKn4KldZWVkrz3bvlE9EyO5ev+4sDg9AoeBOvk7syDMpAglIPtROl+f9xxwG9LKJokdUd+JGemO4a9wqhaImx/yr7+D//d3mTagzTNxPoKfX6Lo3SKjlGFqF3NQzIL9uRyrZoU2V1PibMU2AwJuj7AlED2HIHv/omKt4E4qdTDaSzX3C5AcgU4GcsebU2Gbw8pecSig==',
  };
  // @formatter:on

  NetworkGroupModel networkGroupModel1 = NetworkGroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/b944d651-5162-479b-a927-8fcd4f47e074'),
    networkConfigModel: NetworkConfigModel.ethereum,
    listItemsPreview: <AListItemModel>[],
  );

  NetworkGroupModel networkGroupModel2 = NetworkGroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'ebce2609-1d13-4d1e-aa83-925d55827c87',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/ebce2609-1d13-4d1e-aa83-925d55827c87'),
    networkConfigModel: NetworkConfigModel.bitcoin,
    listItemsPreview: <AListItemModel>[],
  );

  NetworkGroupModel updatedNetworkGroupModel2 = NetworkGroupModel(
    pinnedBool: true,
    encryptedBool: true,
    uuid: 'ebce2609-1d13-4d1e-aa83-925d55827c87',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/ebce2609-1d13-4d1e-aa83-925d55827c87'),
    networkConfigModel: NetworkConfigModel.bitcoin,
    listItemsPreview: <AListItemModel>[],
  );

  NetworkGroupModel networkGroupModel3 = NetworkGroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e5acac35-0ab2-4132-a9c5-877a805e361a',
    filesystemPath: FilesystemPath.fromString(
      '04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9/e5acac35-0ab2-4132-a9c5-877a805e361a',
    ),
    networkConfigModel: NetworkConfigModel.cosmos,
    listItemsPreview: <AListItemModel>[],
  );

  NetworkGroupModel networkGroupModel4 = NetworkGroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: '6fafeb9b-dc37-434a-8330-ffbf6edd5d09',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/6fafeb9b-dc37-434a-8330-ffbf6edd5d09'),
    networkConfigModel: NetworkConfigModel.kira,
    listItemsPreview: <AListItemModel>[],
  );

  GroupModel groupModel = GroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
    name: 'SOME NETWORKS',
    listItemsPreview: <AListItemModel>[networkGroupModel3],
  );

  GroupModel updatedGroupModel = GroupModel(
    pinnedBool: false,
    encryptedBool: false,
    uuid: 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9',
    filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
    name: 'UPDATED GROUP',
    listItemsPreview: <AListItemModel>[networkGroupModel3],
  );

  late NetworkListPageCubit actualNetworkListPageCubit;

  group('Tests of NetworkListPageCubit process', () {
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

      actualNetworkListPageCubit = NetworkListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
      );
    });

    group('Tests of NetworkListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualNetworkListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of NetworkListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all items existing in database', () async {
        // Act
        await actualNetworkListPageCubit.refreshAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel2, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single NETWORK GROUP', () async {
        // Arrange
        // Update network group in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedNetworkGroupModel2);

        // Act
        await actualNetworkListPageCubit.refreshSingle(networkGroupModel2);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedNetworkGroupModel2, groupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        // Update group in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualNetworkListPageCubit.refreshSingle(groupModel);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all items SELECTED]', () async {
        // Act
        actualNetworkListPageCubit.toggleSelectAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          ),
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all items UNSELECTED] if all items were selected before', () async {
        // Act
        actualNetworkListPageCubit.toggleSelectAll();

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified NETWORK GROUP selected', () async {
        // Act
        actualNetworkListPageCubit.selectSingle(networkGroupModel1);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[networkGroupModel1],
          ),
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualNetworkListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[networkGroupModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified NETWORK GROUP unselected', () async {
        // Act
        actualNetworkListPageCubit.unselectSingle(networkGroupModel1);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualNetworkListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualNetworkListPageCubit.disableSelection();

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedNetworkGroupModel2, updatedGroupModel, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == false)', () async {
        // Act
        await actualNetworkListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedGroupModel, networkGroupModel1, updatedNetworkGroupModel2],
          pinnedBool: false,
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedNetworkGroupModel2.copyWith(pinnedBool: false),
            networkGroupModel1.copyWith(pinnedBool: false),
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualNetworkListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            networkGroupModel1.copyWith(pinnedBool: false),
            updatedNetworkGroupModel2.copyWith(pinnedBool: false),
          ],
          pinnedBool: true,
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedNetworkGroupModel2.copyWith(pinnedBool: true),
            networkGroupModel1.copyWith(pinnedBool: true),
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected ITEMS (encryptedBool == true)', () async {
        // Act
        await actualNetworkListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedNetworkGroupModel2.copyWith(pinnedBool: true),
            networkGroupModel1.copyWith(pinnedBool: true),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
            updatedNetworkGroupModel2.copyWith(pinnedBool: true, encryptedBool: true),
            networkGroupModel1.copyWith(pinnedBool: true, encryptedBool: true),
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected NETWORK GROUP (encryptedBool == false)', () async {
        // Act
        await actualNetworkListPageCubit.unlockSelection(
          selectedItem: updatedNetworkGroupModel2.copyWith(pinnedBool: true, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
            updatedNetworkGroupModel2.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel1.copyWith(pinnedBool: true, encryptedBool: true),
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualNetworkListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false),
            updatedNetworkGroupModel2.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel1.copyWith(pinnedBool: true, encryptedBool: true),
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted NETWORK GROUP', () async {
        // Act
        await actualNetworkListPageCubit.deleteItem(networkGroupModel1.copyWith(pinnedBool: true, encryptedBool: true));
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false),
            updatedNetworkGroupModel2.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualNetworkListPageCubit.deleteItem(updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false));
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedNetworkGroupModel2.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel4,
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

  group('Tests of NetworkListPageCubit groups process', () {
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

      actualNetworkListPageCubit = NetworkListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
      );
    });

    group('Tests of NetworkListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualNetworkListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of NetworkListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all items existing in database', () async {
        // Act
        await actualNetworkListPageCubit.refreshAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel2, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.moveItem()', () {
      test('Should [emit ListState] with NETWORK GROUP moved into GROUP', () async {
        // Act
        await actualNetworkListPageCubit.moveItem(networkGroupModel1, groupModel.filesystemPath);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                networkGroupModel3,
                networkGroupModel1.copyWith(
                  filesystemPath: FilesystemPath.fromString(
                    '04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9/b944d651-5162-479b-a927-8fcd4f47e074',
                  ),
                ),
              ],
            ),
            networkGroupModel2,
            networkGroupModel4,
          ],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualNetworkListPageCubit.groupItems(networkGroupModel2, networkGroupModel4, 'TEST GROUP');

        ListState actualListState = actualNetworkListPageCubit.state;

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

  group('Tests of NetworkListPageCubit navigation process', () {
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

      actualNetworkListPageCubit = NetworkListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
      );
    });

    group('Tests of NetworkListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualNetworkListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of NetworkListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all items existing in database', () async {
        // Act
        await actualNetworkListPageCubit.refreshAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel2, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualNetworkListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[networkGroupModel3],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualNetworkListPageCubit.navigateBack();

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel2, networkGroupModel1, networkGroupModel4],
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualNetworkListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[networkGroupModel3],
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