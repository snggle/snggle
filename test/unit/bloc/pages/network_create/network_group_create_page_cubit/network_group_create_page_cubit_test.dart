import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/network_create/network_group_create/network_group_create_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';
import '../../../../../utils/test_network_templates.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late final NetworkGroupCreatePageCubit actualNetworkGroupCreatePageCubit;

  EmbeddedNetworkTemplateEntity embeddedNetworkTemplateEntity = const EmbeddedNetworkTemplateEntity(
    addressEncoderType: 'ethereum(false)',
    curveType: CurveType.secp256k1,
    derivationPathName: null,
    derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    derivatorType: 'secp256k1',
    networkIconType: NetworkIconType.ethereum,
    name: 'Ethereum',
    predefinedNetworkTemplateId: 817800260,
    walletType: WalletType.legacy,
  );

  setUpAll(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      databaseMock: DatabaseMock.fullDatabaseMock,
    );

    actualNetworkGroupCreatePageCubit = NetworkGroupCreatePageCubit(parentFilesystemPath: FilesystemPath.fromString('vault1'));
  });

  group('Tests of NetworkGroupCreatePageCubit.createNetworkGroup()', () {
    test('Should [return List of NetworkGroupEntity] (before creating network group)', () async {
      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [return create network group] and save it in database', () async {
      // Act
      await actualNetworkGroupCreatePageCubit.createNetworkGroup('NEW NETWORK GROUP', TestNetworkTemplates.ethereum);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        NetworkGroupEntity(id: 10, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'NEW NETWORK GROUP', filesystemPathString: 'vault1/network10'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });
}