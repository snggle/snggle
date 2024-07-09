import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;

  // @formatter:off
  Map<String, String> filledVaultsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.vaults.name:'HrSAuzL39JquAN92Hq+TidSF6T4RaXf5TX8++/LNiUp6AjprjtjphbmRZkJ8XV0Gtu3ToaG7W9NIUuwAadgcJuk/1mjJM1Fi2kHI4czI7Ljg9wAARGIUpnSb5CZniFRymA9JujPoea8SkaVhSM9YL/xUa8K7lanwRn21IiOMQJ++ljk+LfbMRi0ebEPMTGnayCj2hDrOKcSYAehHrZ6ECYFDSUthhDrUZEmxbUqNVBHUJiJqW/etEgZYckKRfQxzFB2qhriBRutYhAWK4HGTBAIPjcZT7ydWAOp5v5MkbHkCE+ic9KdJk1aOoj+5BBLuEkXF2ao1zHqwBXq3jb/pgu2ZI0DyhNPY4lCQw7dnFT6ZflP3FNitnbGzWAu8FlP0Pll6gcuxRiV8H/R4QDdMOCxZZfWuIMJmLZbYGq2TClC/duRR/3oa7tPLHNYRN6tDszJfzQC/pldijozd8pW5NBElodHGjPFdLSgM+iG/lChwqMQ74iGxHOr9zLHCF6ldB4wXIUMdDGVOx255A1YtzI9uqilGshjhYPL6OXhkEspKuTqBZuABoEWQA2MCOmWO7jQdgTOB0xa6B438w95XaTpb1mH09rrjjYEspk18jLH0GsYabWrW/2kWh2xnwVHGtW9uMpkDPqFAYMpbVWliQhTbexUrOBwjV6GWFCCJ3eDRdkNH97FGoEmxOYTVYTVJEWQeBDNZUBLCyvN0IBpiLKFtDAc8grgLjtLpZZt0Jv090Aoh/VCrrhTHuN5oSNQtEUUULha/ZoDF7bqtFCF6boANi6hjAmjKaGz3pN/jKKCkDdoar9T1SU6yFFUS9YUIWHbhesOXrILEiPcpyHmg4t31wpaOZtnR3Tc7dkHIyr3iID//7i/DVPxws0wMV+nEsi48LL/SbkUJwXEK/dM2BIVDK1Y=',
    SecureStorageKey.wallets.name: 'rGYdF3j8KhnKg/BL+8ss82On/2WHDui2Vsof+R4246/wLjWhb6rHWPh2r/ddeyYzFgYfXDsV3ewAkXJ0vyoXf4UvAg1rUixEyAWhY8dfLJl2KT2EagbxBb8TyaDV9JDMnyi+TwvFuKN76eP9ZXG7tTiIYa9p+n3kmM0XfSQzTQk5qinlSReoEn19aaa4c57KTgSSmZmR8sDJpbt59a9Rhq9y7CDfhbQuR8Xu1ma1b4Wd6gfnx7XYYepGCWHYi3ZQadI5p7QuIv/52S/fRsvQ6vM2564u5dnxyHXwxHncmJqQgl4z9XKwkmwo1rO5mmrYQ62VDpRhxiCsViYpOqsLRwmgwhf3dcclm1IG2rGsn9t5sxrSFJZLdCJTJlYviQEbod/8cI974znkvwayScDlJNJ9Ku6pzbMnharaoOQB8pm2O8om79gBUu3ZiA09H1jIvxX2bPj4q3MnB+OnAhmY/Hk6T4u3bR0dk9PBRQ1uM5VbY4eobNvfo3fSBdjhx6h9jPosJyNJQOFBhFLbvKwcoeaPeMCclWLX6Zd5PlxeP143i/hvBYvAzzSQKoKEHjczcSylV2o5QFGFMFzV+dUT9vXk2Z+98htYJuwecUPPqih7Fx9OU4Qn8WN2bRwjdXNDwaebD081Esk9LKnIQy8W0TeXAP7rs4326xWc2tZCg0O2dSi1K7lv2erb32ZNbT5Ys173TqHOryKxvE8OsP/NtpwWkqRbb5H6SEVtbERnK6D1ljx0CDEsNgFMzLezp6o2NtVzhETTWRxYJMksD9iHCNp4MZ9Mocrn7iipX+vMGUsdCdUpdljTeYfBPsklaxnQ+v9J6tgI+aOfdAhTYA1yfgxK8Sxxmp3NLyjGdG6RIHmOjrqFeAjLN+haZF7C501KTETmYSynfYGJjOLgF1zy1/TR+kg9y8Lly76WL2xWx7RFvBopfPeaaeSTym1xwxumKdmfIbms/AxaPGz7NmYbGMk8w2Y=',
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.vaults.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  setUp(() {
    // @formatter:off
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      filesystemStorageContent: <String, dynamic>{
        'secrets': <String, dynamic>{
          '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
          'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
          'e527efe1-a05b-49f5-bfe9-d3532f5c9db9': <String, dynamic>{
            '438791a4-b537-4589-af4f-f56b6449a0bb.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
          },
        },
      }
    );
    // @formatter:on
  });

  group('Tests of VaultModelFactory.createNewVault()', () {
    test('Should [return VaultModel] with [randomly generated UUID] and [index EQUALS 0] if there are no vaults in the database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyVaultsDatabase);

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultModelFactory>().createNewVault(const FilesystemPath.empty());

      // Assert
      expect(actualVaultModel.index, 0);
      expect(actualVaultModel.uuid, isNotNull);
    });

    test('Should [return VaultModel] with [randomly generated UUID] and [index EQUALS 4] if the previous largest vault index is equal 3', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultModelFactory>().createNewVault(const FilesystemPath.empty());

      // Assert
      expect(actualVaultModel.index, 4);
      expect(actualVaultModel.uuid, isNotNull);
    });
  });

  group('Tests of VaultModelFactory.createFromEntity()', () {
    test('Should [return VaultModel] with values from given VaultEntity', () async {
      // Arrange
      VaultEntity actualVaultEntity = VaultEntity(
        pinnedBool: false,
        encryptedBool: false,
        index: 10,
        uuid: '7d871464-f352-432d-ad70-b001b38a17c9',
        name: 'TEST VAULT',
        filesystemPath: FilesystemPath.fromString('7d871464-f352-432d-ad70-b001b38a17c9'),
      );

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultModelFactory>().createFromEntity(actualVaultEntity);

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        pinnedBool: false,
        encryptedBool: false,
        index: 10,
        uuid: '7d871464-f352-432d-ad70-b001b38a17c9',
        name: 'TEST VAULT',
        filesystemPath: FilesystemPath.fromString('7d871464-f352-432d-ad70-b001b38a17c9'),
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualVaultModel, expectedVaultModel);
    });
  });

  tearDownAll(() {
    testDatabase.close();
  });
}
