import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.wallets;

  // @formatter:off
  Map<String, String> filledWalletsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.wallets.name:'7MxmaVCoOM+ZXa52QtwVKCSaajmWAg++MrUpK4Mdevs5Kn3gGwWz+LefennY3RljJl0LhhzlXu1Z/4HdqYo7KyKJ4O0gUpaNLTvVhQk30zm8HW6bJIOUuYGaDz8m9/tIWbax2soWYuNkIyV1Ej8BQAiDxrMaT1muW5HERhF/3WlFBW9CsH1+CYmO26wpqXFcOEL5VBzYl84g28o2Xo/imtTAhCYkaIYpUfqBwjSrtEcuMcCQFcJVAEJbD7PjiMgWnj/NwF8nDM3kOl8veJpS3klEywfyOsuWrsqSMF6mzmF+6pMwzTMTNr4GLwDUwB+mSDl/AX3kc0SiJfN5ypa/NEEsRGdHX0kcOPw76TIGwC+qHbgFS7IiC+YK1pKdwLPQuBNHHScih1UlgSW3wkEQjyWoWBEA/TtccsNYoo4na2H+ph28GQQBZrV+r5Lok2ShjFYnSwPoMQztjnzTiWRcmMbU832fApYO5ctG63QNqzQYU+ZlExU4F56hKCKzzRuhWL4PcFIm9qaqY4gthHY6vPG8jhTCQ0RTrDwibUU9Mb/nn9jqvbvJKVlz5ZtWXjoJ6BVOsS5ULilrBjE+aXFsihNgX7JoJzm9bupkJ3N3I1Vo9pPKxZxw6FGtVokKC5l1ehGJe7baXmlgGgwyGdCyfR7zO66rzsmOxH/qL71ts0aVCtjJYA24xW79v0fzZyF12U+GTxhsnvyDRpeWVUQcqOn4+Z9h8kedaKrMaERoHmWTgL+ugdXAha9V04ETNvi5nt552mwzET9BJUNWKURPd29VnOzaYC4mMbHP904RB8nDDv3ssNPaaebo54ltkW04JVW8XHklUeDW5PVGe7PFfs81MreZ8zPkraXG2Bf6Wif71BLm/HYfJ/hbzCxdjTR9eWZFuGrq0E12uUtIVc0mk1pGa1Z+pEzAQ0jY5pCfUgVtFr8BHnkcrMxswbtuPAtwboY23amvQH7Mf5yhYlrpW3OE1s2bXR3H1LmBeiLDfhA/0YppfxlteN+sr6W0wF8PCEFCjco3/6ibqwW+33SEeJ5VAD4ApZB60JV7xAiP8NLQG8TMI76oZ+mQVlEtMSzD2n+XFQ/GM33xl1n8xq8CPw/TPfaDZol32/HAEWi+vJ0o8sjzLWm2Wr2X5GQ0iHfinEWbBVVyx2d3Zw0ddRmg8LbJ+GibareycdHffSFJnqN56Cfm6OCDwPVW25qrYngGXHY4JMuXAPzukrfeVI0tG9QlSyDN+dzgvH9A2mpTpDARMh2hvx77/5p2AoVQ3yKtMF51cgFAF4KjRzkbFLreGzp13dJozxmJxMOOwnCSRhFxzXbnqllx7AOh9MC8RKuOG7oWy9TJ/fDLIsyTLPF119RxUgU7hDxafsUl2Jr90wg/83j1l1cAW3Tkz28+bljGAsJpJzi86fAIl3jyE9c/vyKs2Q1XUxK9y3TFPy0IVEBsKVMbPj3chp283gIXFXOliZaiPhYyv4NUhROuZUWBDmvNoJiToQEfd9w02sQ8eId02wgEHr8wjQjGV4x7tcexHPCHvUKcLyX0q8lH7XPOrBZA0pqdGkdgofCzN6joCtHcAF3FXUUXyrsZK3qNrfMDkICoRiT9vAkebBzhj6gph1fgVyam65DqALovvM5FdXwtvKmXAKJDPVxkhahBRD4ONvBkSXV7Sdi5d5hTcBD3qCj4rjQobb7MkM77mjaMfcTa5C1YPyDhmhzIJqX6aj2pNyKw8TTpgFf3aY2q/Ktb43Phz+jfwMVR3g221tvKNyH/JtwbKUAR2SYo+ti6I/LRDZCVDMawkCPVUgitTfBEDEbi10M=',
  };

  Map<String, String> emptyWalletsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.wallets.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  setUp(() {
    testDatabase = TestDatabase(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of initial database state', () {
    test('Should [return Map of wallets] as ["wallets" key value EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWalletsDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualWalletsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

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
      testDatabase.updateSecureStorage(emptyWalletsDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualWalletsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{};

      expect(actualWalletsMap, expectedVaultsMap);
    });
  });

  group('Tests of WalletsRepository.getAll()', () {
    test('Should [return List of WalletEntity] if ["wallets" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWalletsDatabase);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[
        WalletEntity(
          pinnedBool: true,
          encryptedBool: true,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
        ),
        WalletEntity(
          pinnedBool: true,
          encryptedBool: false,
          index: 1,
          address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/3e7f3547-d78f-4dda-a916-3e9eabd4bfee'),
        ),
        WalletEntity(
          pinnedBool: false,
          encryptedBool: true,
          index: 0,
          address: 'kira15808n8vfcf3m88r5jxnq47gjel5lvmxadmsqt5',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'kira',
          uuid: '4d02947e-c838-4a77-bef3-0ffbdb1c7525',
          filesystemPath: FilesystemPath.fromString('5f5332fb-37c1-4352-9153-d43692615f0f/4d02947e-c838-4a77-bef3-0ffbdb1c7525'),
        ),
        WalletEntity(
          pinnedBool: false,
          encryptedBool: false,
          index: 1,
          address: 'kira1t7lspdwnhjwx23e2r3l04wn6uuhyt60ljkqdgl',
          derivationPath: "m/44'/118'/0'/0/1",
          network: 'kira',
          uuid: 'ef63ccfc-c3da-4212-9dc1-693a9e75e90b',
          filesystemPath: FilesystemPath.fromString('5f5332fb-37c1-4352-9153-d43692615f0f/ef63ccfc-c3da-4212-9dc1-693a9e75e90b'),
        ),
      ];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });

    test('Should [return EMPTY list] if ["wallets" key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyWalletsDatabase);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });

    test('Should [return EMPTY list] if ["wallets" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });
  });

  group('Tests of WalletsRepository.getById()', () {
    test('Should [return WalletEntity] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWalletsDatabase);

      // Act
      WalletEntity actualWalletEntity = await globalLocator<WalletsRepository>().getById('4e66ba36-966e-49ed-b639-191388ce38de');

      // Assert
      WalletEntity expectedWalletEntity = WalletEntity(
        pinnedBool: true,
        encryptedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
      );

      expect(actualWalletEntity, expectedWalletEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWalletsDatabase);

      // Assert
      expect(
        () => globalLocator<WalletsRepository>().getById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsRepository.save()', () {
    test('Should [UPDATE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWalletsDatabase);

      WalletEntity actualUpdatedWalletEntity = WalletEntity(
        pinnedBool: true,
        encryptedBool: false,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
        name: 'UPDATED WALLET',
      );

      // Act
      await globalLocator<WalletsRepository>().save(actualUpdatedWalletEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualWalletsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'ethereum',
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
      testDatabase.updateSecureStorage(emptyWalletsDatabase);

      WalletEntity actualNewWalletEntity = WalletEntity(
          pinnedBool: true,
          encryptedBool: false,
          index: 0,
          address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          derivationPath: "m/44'/118'/0'/0/0",
          network: 'ethereum',
          uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
          filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
          name: 'NEW WALLET');

      // Act
      await globalLocator<WalletsRepository>().save(actualNewWalletEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualWalletsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'ethereum',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de',
          'name': 'NEW WALLET'
        },
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });

    test('Should [SAVE wallet] if ["wallets" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      WalletEntity actualNewWalletEntity = WalletEntity(
        pinnedBool: true,
        encryptedBool: false,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
      );

      // Act
      await globalLocator<WalletsRepository>().save(actualNewWalletEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualWalletsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedWalletsMap = <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de': <String, dynamic>{
          'pinned': true,
          'encrypted': false,
          'index': 0,
          'address': 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
          'derivation_path': "m/44'/118'/0'/0/0",
          'network': 'ethereum',
          'uuid': '4e66ba36-966e-49ed-b639-191388ce38de',
          'filesystem_path': '04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de',
          'name': null
        }
      };

      expect(actualWalletsMap, expectedWalletsMap);
    });
  });

  group('Tests of WalletsRepository.deleteById()', () {
    test('Should [REMOVE wallet] if [wallet UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWalletsDatabase);

      // Act
      await globalLocator<WalletsRepository>().deleteById('4e66ba36-966e-49ed-b639-191388ce38de');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualWalletsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

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
      testDatabase.updateSecureStorage(emptyWalletsDatabase);

      // Assert
      expect(
        () => globalLocator<WalletsRepository>().deleteById('not_existing_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    testDatabase.close();
  });
}