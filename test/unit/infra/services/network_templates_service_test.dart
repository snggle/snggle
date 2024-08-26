import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/network_templates_service.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of NetworkTemplatesService.isNameUnique()', () {
    test('Should [return TRUE] if [name NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool nameUniqueBool = await globalLocator<NetworkTemplatesService>().isNameUnique('Not existing Ethereum');

      // Assert
      expect(nameUniqueBool, true);
    });

    test('Should [return FALSE] if [name EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool nameUniqueBool = await globalLocator<NetworkTemplatesService>().isNameUnique('Ethereum');

      // Assert
      expect(nameUniqueBool, false);
    });
  });

  group('Tests of NetworkTemplatesService.getAllAsMap()', () {
    test('Should [return Map of NetworkTemplateModel] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> actualNetworkTemplateModelMap = await globalLocator<NetworkTemplatesService>().getAllAsMap();

      // Assert
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> expectedNetworkTemplateModelMap = <NetworkTemplateModel, List<NetworkTemplateModel>>{
        // @formatter:off
        DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
        // @formatter:on
      };

      expect(actualNetworkTemplateModelMap, expectedNetworkTemplateModelMap);
    });

    test('Should [return map with empty values] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> actualNetworkTemplateModelMap = await globalLocator<NetworkTemplatesService>().getAllAsMap();

      // Assert
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> expectedNetworkTemplateModelMap = <NetworkTemplateModel, List<NetworkTemplateModel>>{
        DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[],
      };

      expect(actualNetworkTemplateModelMap, expectedNetworkTemplateModelMap);
    });
  });

  group('Tests of NetworkTemplatesService.getById()', () {
    test('Should [return NetworkTemplateModel] if [template EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      NetworkTemplateModel actualNetworkTemplateModel = await globalLocator<NetworkTemplatesService>().getById(817800260);

      // Assert
      NetworkTemplateModel expectedNetworkTemplateModel = NetworkTemplateModel(
        addressEncoder: EthereumAddressEncoder(),
        curveType: CurveType.secp256k1,
        derivationPathName: null,
        derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
        derivator: Secp256k1Derivator(),
        networkIconType: NetworkIconType.ethereum,
        name: 'Ethereum',
        predefinedNetworkTemplateId: 817800260,
        walletType: WalletType.legacy,
      );

      expect(actualNetworkTemplateModel, expectedNetworkTemplateModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [template NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<NetworkTemplatesService>().getById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of NetworkTemplatesService.save()', () {
    test('Should [UPDATE template] if [template EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkTemplateModel actualUpdatedNetworkTemplateModel = NetworkTemplateModel(
        addressEncoder: EthereumAddressEncoder(),
        curveType: CurveType.secp256k1,
        derivationPathName: null,
        derivationPathTemplate: "m/999999'/999999'/999999'/{{y}}/{{i}}",
        derivator: Secp256k1Derivator(),
        networkIconType: NetworkIconType.ethereum,
        name: 'Ethereum',
        predefinedNetworkTemplateId: 817800260,
        walletType: WalletType.legacy,
      );

      // Act
      await globalLocator<NetworkTemplatesService>().save(actualUpdatedNetworkTemplateModel);

      List<NetworkTemplateEntity> actualNetworkTemplatesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkTemplates.where().findAll();
      });

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplatesDatabaseValue = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/999999'/999999'/999999'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      expect(actualNetworkTemplatesDatabaseValue, expectedNetworkTemplatesDatabaseValue);
    });

    test('Should [SAVE template] if [template NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkTemplateModel actualNewNetworkTemplateModel = NetworkTemplateModel(
        addressEncoder: EthereumAddressEncoder(),
        curveType: CurveType.secp256k1,
        derivationPathName: null,
        derivationPathTemplate: "m/999999'/999999'/999999'/{{y}}/{{i}}",
        derivator: Secp256k1Derivator(),
        networkIconType: NetworkIconType.ethereum,
        name: 'NEW ETHEREUM',
        predefinedNetworkTemplateId: 817800260,
        walletType: WalletType.legacy,
      );

      // Act
      await globalLocator<NetworkTemplatesService>().save(actualNewNetworkTemplateModel);

      List<NetworkTemplateEntity> actualNetworkTemplatesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkTemplates.where().findAll();
      });

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplatesDatabaseValue = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/999999'/999999'/999999'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'NEW ETHEREUM', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      expect(actualNetworkTemplatesDatabaseValue, expectedNetworkTemplatesDatabaseValue);
    });
  });

  group('Tests of NetworkTemplatesService.deleteAll()', () {
    test('Should [REMOVE templates] if [templates EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      List<NetworkTemplateModel> actualNetworkTemplateModelList = <NetworkTemplateModel>[
        // @formatter:off
        NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkTemplatesService>().deleteAll(actualNetworkTemplateModelList);

      List<NetworkTemplateEntity> actualNetworkTemplatesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkTemplates.where().findAll();
      });

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplatesDatabaseValue = <NetworkTemplateEntity>[];

      expect(actualNetworkTemplatesDatabaseValue, expectedNetworkTemplatesDatabaseValue);
    });
  });

  tearDown(testDatabase.close);
}
