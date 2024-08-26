import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/network_templates_repository.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of NetworkTemplatesRepository.getAll()', () {
    test('Should [return List of NetworkTemplateEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<NetworkTemplateEntity> actualNetworkTemplateEntityList = await globalLocator<NetworkTemplatesRepository>().getAll();

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplateEntityList = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      expect(actualNetworkTemplateEntityList, expectedNetworkTemplateEntityList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<NetworkTemplateEntity> actualNetworkTemplateEntityList = await globalLocator<NetworkTemplatesRepository>().getAll();

      // Assert
      List<NetworkTemplateEntity> expectedNetworkTemplateEntityList = <NetworkTemplateEntity>[];

      expect(actualNetworkTemplateEntityList, expectedNetworkTemplateEntityList);
    });
  });

  group('Tests of NetworkTemplatesRepository.getById()', () {
    test('Should [return NetworkTemplateEntity] if [template EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      NetworkTemplateEntity actualNetworkTemplateEntity = await globalLocator<NetworkTemplatesRepository>().getById(817800260);

      // Assert
      NetworkTemplateEntity expectedNetworkTemplateEntity = const NetworkTemplateEntity(
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

      expect(actualNetworkTemplateEntity, expectedNetworkTemplateEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [template NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<NetworkTemplatesRepository>().getById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of NetworkTemplatesRepository.save()', () {
    test('Should [UPDATE template] if [template EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkTemplateEntity actualUpdatedNetworkTemplateEntity = const NetworkTemplateEntity(
        addressEncoderType: 'ethereum(false)',
        curveType: CurveType.secp256k1,
        derivationPathName: null,
        derivationPathTemplate: "m/999999'/999999'/999999'/{{y}}/{{i}}",
        derivatorType: 'secp256k1',
        networkIconType: NetworkIconType.ethereum,
        name: 'Ethereum',
        predefinedNetworkTemplateId: 817800260,
        walletType: WalletType.legacy,
      );

      // Act
      await globalLocator<NetworkTemplatesRepository>().save(actualUpdatedNetworkTemplateEntity);

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

      NetworkTemplateEntity actualNewNetworkTemplateEntity = const NetworkTemplateEntity(
        addressEncoderType: 'ethereum(false)',
        curveType: CurveType.secp256k1,
        derivationPathName: null,
        derivationPathTemplate: "m/999999'/999999'/999999'/{{y}}/{{i}}",
        derivatorType: 'secp256k1',
        networkIconType: NetworkIconType.ethereum,
        name: 'NEW ETHEREUM',
        predefinedNetworkTemplateId: 817800260,
        walletType: WalletType.legacy,
      );

      // Act
      await globalLocator<NetworkTemplatesRepository>().save(actualNewNetworkTemplateEntity);

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

  group('Tests of NetworkTemplatesRepository.deleteAll()', () {
    test('Should [REMOVE templates] if [templates EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      List<NetworkTemplateEntity> actualNetworkTemplateEntityList = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkTemplatesRepository>().deleteAll(actualNetworkTemplateEntityList);

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
