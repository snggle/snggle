import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  String testSessionUUID = const Uuid().v4();

  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.wallets;

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

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
    DatabaseParentKey.wallets.name:'7MxmaVCoOM+ZXa52QtwVKCSaajmWAg++MrUpK4Mdevs5Kn3gGwWz+LefennY3RljJl0LhhzlXu1Z/4HdqYo7KyKJ4O0gUpaNLTvVhQk30zm8HW6bJIOUuYGaDz8m9/tIWbax2soWYuNkIyV1Ej8BQAiDxrMaT1muW5HERhF/3WlFBW9CsH1+CYmO26wpqXFcOEL5VBzYl84g28o2Xo/imtTAhCYkaIYpUfqBwjSrtEcuMcCQFcJVAEJbD7PjiMgWnj/NwF8nDM3kOl8veJpS3klEywfyOsuWrsqSMF6mzmF+6pMwzTMTNr4GLwDUwB+mSDl/AX3kc0SiJfN5ypa/NEEsRGdHX0kcOPw76TIGwC+qHbgFS7IiC+YK1pKdwLPQuBNHHScih1UlgSW3wkEQjyWoWBEA/TtccsNYoo4na2H+ph28GQQBZrV+r5Lok2ShjFYnSwPoMQztjnzTiWRcmMbU832fApYO5ctG63QNqzQYU+ZlExU4F56hKCKzzRuhWL4PcFIm9qaqY4gthHY6vPG8jhTCQ0RTrDwibUU9Mb/nn9jqvbvJKVlz5ZtWXjoJ6BVOsS5ULilrBjE+aXFsihNgX7JoJzm9bupkJ3N3I1Vo9pPKxZxw6FGtVokKC5l1ehGJe7baXmlgGgwyGdCyfR7zO66rzsmOxH/qL71ts0aVCtjJYA24xW79v0fzZyF12U+GTxhsnvyDRpeWVUQcqOn4+Z9h8kedaKrMaERoHmWTgL+ugdXAha9V04ETNvi5nt552mwzET9BJUNWKURPd29VnOzaYC4mMbHP904RB8nDDv3ssNPaaebo54ltkW04JVW8XHklUeDW5PVGe7PFfs81MreZ8zPkraXG2Bf6Wif71BLm/HYfJ/hbzCxdjTR9eWZFuGrq0E12uUtIVc0mk1pGa1Z+pEzAQ0jY5pCfUgVtFr8BHnkcrMxswbtuPAtwboY23amvQH7Mf5yhYlrpW3OE1s2bXR3H1LmBeiLDfhA/0YppfxlteN+sr6W0wF8PCEFCjco3/6ibqwW+33SEeJ5VAD4ApZB60JV7xAiP8NLQG8TMI76oZ+mQVlEtMSzD2n+XFQ/GM33xl1n8xq8CPw/TPfaDZol32/HAEWi+vJ0o8sjzLWm2Wr2X5GQ0iHfinEWbBVVyx2d3Zw0ddRmg8LbJ+GibareycdHffSFJnqN56Cfm6OCDwPVW25qrYngGXHY4JMuXAPzukrfeVI0tG9QlSyDN+dzgvH9A2mpTpDARMh2hvx77/5p2AoVQ3yKtMF51cgFAF4KjRzkbFLreGzp13dJozxmJxMOOwnCSRhFxzXbnqllx7AOh9MC8RKuOG7oWy9TJ/fDLIsyTLPF119RxUgU7hDxafsUl2Jr90wg/83j1l1cAW3Tkz28+bljGAsJpJzi86fAIl3jyE9c/vyKs2Q1XUxK9y3TFPy0IVEBsKVMbPj3chp283gIXFXOliZaiPhYyv4NUhROuZUWBDmvNoJiToQEfd9w02sQ8eId02wgEHr8wjQjGV4x7tcexHPCHvUKcLyX0q8lH7XPOrBZA0pqdGkdgofCzN6joCtHcAF3FXUUXyrsZK3qNrfMDkICoRiT9vAkebBzhj6gph1fgVyam65DqALovvM5FdXwtvKmXAKJDPVxkhahBRD4ONvBkSXV7Sdi5d5hTcBD3qCj4rjQobb7MkM77mjaMfcTa5C1YPyDhmhzIJqX6aj2pNyKw8TTpgFf3aY2q/Ktb43Phz+jfwMVR3g221tvKNyH/JtwbKUAR2SYo+ti6I/LRDZCVDMawkCPVUgitTfBEDEbi10M=',
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.wallets.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
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
    test('Should [return Map of wallets] as ["wallets" key value EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': true,
          'encrypted': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'encrypted': true,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [return EMPTY map] as ["wallets" key value is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{};

      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsService.getLastIndex()', () {
    test('Should [return 1] if the largest wallet index for specified wallet is equal 2', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      int actualLastWalletIndex = await globalLocator<WalletsService>().getLastIndex(FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'));

      // Assert
      expect(actualLastWalletIndex, 1);
    });

    test('Should [return -1] as a default value (empty collection)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

      // Act
      int actualLastWalletIndex = await globalLocator<WalletsService>().getLastIndex(FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'));

      // Assert
      expect(actualLastWalletIndex, -1);
    });
  });

  group('Tests of WalletsService.getById()', () {
    test('Should [return WalletModel] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      WalletModel actualWalletModel = await globalLocator<WalletsService>().getById('4e66ba36-966e-49ed-b639-191388ce38de');

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        encryptedBool: true,
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
        name: 'WALLET 0',
      );

      expect(actualWalletModel, expectedWalletModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Assert
      expect(
        () => globalLocator<WalletsService>().getById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsService.getAllByParentPath()', () {
    test('Should [return List of WalletModel] [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        const FilesystemPath.empty(),
        firstLevelBool: false,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        WalletModel(
          encryptedBool: true,
          pinnedBool: true,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
          name: 'WALLET 0',
        ),
        WalletModel(
          encryptedBool: false,
          pinnedBool: true,
          index: 1,
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'),
          name: 'WALLET 1',
        ),
        WalletModel(
          encryptedBool: true,
          pinnedBool: false,
          index: 0,
          address: 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          filesystemPath: FilesystemPath.fromString('5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'),
          name: 'WALLET 0',
        ),
        WalletModel(
          encryptedBool: false,
          pinnedBool: false,
          index: 1,
          address: 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          filesystemPath: FilesystemPath.fromString('5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'),
          name: 'WALLET 1',
        ),
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return List of WalletModel] [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        firstLevelBool: true,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        WalletModel(
          encryptedBool: true,
          pinnedBool: true,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
          name: 'WALLET 0',
        ),
        WalletModel(
          encryptedBool: false,
          pinnedBool: true,
          index: 1,
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'),
          name: 'WALLET 1',
        ),
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return EMPTY list] if [given path IS EMPTY] (firstLevelBool == FALSE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        FilesystemPath.fromString('4e66ba36-966e-49ed-b639-191388ce38de'),
        firstLevelBool: false,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return EMPTY list] if [given path IS EMPTY] (firstLevelBool == TRUE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        FilesystemPath.fromString('4e66ba36-966e-49ed-b639-191388ce38de'),
        firstLevelBool: true,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[];

      expect(actualWalletModelList, expectedWalletModelList);
    });
  });

  group('Tests of WalletsService.move()', () {
    test('Should [MOVE wallet] if [wallet EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      await globalLocator<WalletsService>().move(
        WalletModel(
          encryptedBool: true,
          pinnedBool: true,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
          name: 'WALLET 0',
        ),
        FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9'),
      );

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'encrypted': true,
          'pinned': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/e527efe1-a05b-49f5-bfe9-d3532f5c9db9/4e66ba36-966e-49ed-b639-191388ce38de',
          'name': 'WALLET 0'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'encrypted': true,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsService.moveByParentPath()', () {
    test('Should [MOVE wallets] with provided parent path', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      await globalLocator<WalletsService>().moveByParentPath(
        FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
        FilesystemPath.fromString('5f5332fb-37c1-4352-9153-d43692615f0f'),
      );

      // Act
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'encrypted': true,
          'pinned': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/4e66ba36-966e-49ed-b639-191388ce38de',
          'name': 'WALLET 0'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'encrypted': false,
          'pinned': true,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'name': 'WALLET 1'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'encrypted': true,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsService.save()', () {
    test('Should [UPDATE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      WalletModel actualUpdatedWalletModel = WalletModel(
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
        name: 'UPDATED WALLET',
      );

      // Act
      await globalLocator<WalletsService>().save(actualUpdatedWalletModel);
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de',
          'name': 'UPDATED WALLET'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'encrypted': true,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [SAVE wallet] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

      WalletModel actualNewWalletModel = WalletModel(
        encryptedBool: false,
        pinnedBool: false,
        index: 2,
        address: 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
        derivationPath: "m/44'/118'/0'/0/2",
        network: 'kira',
        uuid: '8b52e5f2-d265-41d5-8567-47e9f879bd02',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/8b52e5f2-d265-41d5-8567-47e9f879bd02'),
        name: 'NEW WALLET',
      );

      // Act
      await globalLocator<WalletsService>().save(actualNewWalletModel);
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '8b52e5f2-d265-41d5-8567-47e9f879bd02': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 2,
          'address': 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx',
          'derivation_path': "m/44'/118'/0'/0/2",
          'network': 'kira',
          'uuid': '8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/8b52e5f2-d265-41d5-8567-47e9f879bd02',
          'name': 'NEW WALLET'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsService.deleteAllByParentPath()', () {
    test('Should [REMOVE wallets] if [wallet with path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      await globalLocator<WalletsService>().deleteAllByParentPath(FilesystemPath.fromString('5f5332fb-37c1-4352-9153-d43692615f0f'));
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': true,
          'encrypted': true,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'
        },
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [REMOVE ALL wallets] if [path EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      await globalLocator<WalletsService>().deleteAllByParentPath(const FilesystemPath.empty());
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{};

      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsService.deleteById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

      // Act
      await globalLocator<WalletsService>().deleteById('4e66ba36-966e-49ed-b639-191388ce38de');
      String? actualEncryptedWalletsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedWalletsKeyValue = actualMasterKeyVO.decrypt(
        appPasswordModel: actualAppPasswordModel,
        encryptedData: actualEncryptedWalletsKeyValue!,
      );
      Map<String, dynamic> actualWalletsMap = jsonDecode(actualDecryptedWalletsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 1,
          'address': 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'
        },
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525': <String, dynamic>{
          'pinned': false,
          'encrypted': true,
          'index': 0,
          'address': 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'kira',
          'uuid': '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'
        },
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'index': 1,
          'address': 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          'derivation_path': "m/44'/118'/0'/0/1",
          'network': 'kira',
          'uuid': 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          'filesystem_path': '5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyWalletsDatabase));

      // Assert
      expect(
        () => globalLocator<WalletsService>().deleteById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}