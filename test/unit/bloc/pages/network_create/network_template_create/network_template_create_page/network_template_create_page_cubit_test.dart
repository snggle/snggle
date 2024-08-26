import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_page/network_template_create_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late final NetworkTemplateCreatePageCubit actualNetworkTemplateCreatePageCubit;

  setUpAll(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      databaseMock: DatabaseMock.fullDatabaseMock,
    );

    actualNetworkTemplateCreatePageCubit = NetworkTemplateCreatePageCubit();
  });

  group('Tests of NetworkTemplateCreatePageCubit.save()', () {
    test('Should [return List of NetworkTemplateEntity] (before creating network template)', () async {
      List<NetworkTemplateEntity> actualNetworkTemplatesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkTemplates.where().findAll();
      });

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplatesDatabaseValue = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      expect(actualNetworkTemplatesDatabaseValue, expectedNetworkTemplatesDatabaseValue);
    });

    test('Should [return create network group] and save it in database', () async {
      // Arrange
      NetworkTemplateModel actualNewNetworkTemplateModel = NetworkTemplateModel(
        name: 'NEW ETHEREUM',
        networkIconType: NetworkIconType.ethereum,
        derivationPathTemplate: "m/99999'/99999'/99999'/{{y}}/{{i}}",
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );

      // Act
      await actualNetworkTemplateCreatePageCubit.save(actualNewNetworkTemplateModel);

      List<NetworkTemplateEntity> actualNetworkTemplatesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkTemplates.where().findAll();
      });

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplatesDatabaseValue = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/99999'/99999'/99999'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'NEW ETHEREUM', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      expect(actualNetworkTemplatesDatabaseValue, expectedNetworkTemplatesDatabaseValue);
    });
  });
}