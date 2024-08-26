import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/create_network_template_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/networks/create_ethereum_template_form_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

import '../../../../../../../utils/database_mock.dart';
import '../../../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late final CreateEthereumTemplateFormCubit actualCreateEthereumTemplateFormCubit;

  setUpAll(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      databaseMock: DatabaseMock.fullDatabaseMock,
    );

    actualCreateEthereumTemplateFormCubit = CreateEthereumTemplateFormCubit();
  });

  group('Tests of CreateEthereumTemplateFormCubit initial state', () {
    test('Should [return CreateNetworkTemplateFormState] with default LegacyDerivationPathSelectMenuItem', () {
      // Act
      CreateNetworkTemplateFormState actualCreateNetworkTemplateFormState = actualCreateEthereumTemplateFormCubit.state;

      // Assert
      CreateNetworkTemplateFormState expectedCreateNetworkTemplateFormState = const CreateNetworkTemplateFormState(
        selectedDerivationPath: LegacyDerivationPathSelectMenuItem(
          title: 'BIP 44',
          exampleAddress: '0x000...000',
          derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
        ),
      );

      expect(actualCreateNetworkTemplateFormState, expectedCreateNetworkTemplateFormState);
    });
  });

  group('Tests of CreateEthereumTemplateFormCubit.changeDerivationPath()', () {
    test('Should [return CreateNetworkTemplateFormState] with updated LegacyDerivationPathSelectMenuItem', () {
      // Arrange
      LegacyDerivationPathSelectMenuItem actualLegacyDerivationPathSelectMenuItem = const LegacyDerivationPathSelectMenuItem(
        title: 'Ledger',
        exampleAddress: '0x000...000',
        derivationPathTemplate: "m/44'/60'/0'/{{i}}",
        derivationPathName: 'Ledger',
      );

      // Act
      actualCreateEthereumTemplateFormCubit.changeDerivationPath(actualLegacyDerivationPathSelectMenuItem);
      CreateNetworkTemplateFormState actualCreateNetworkTemplateFormState = actualCreateEthereumTemplateFormCubit.state;

      // Assert
      CreateNetworkTemplateFormState expectedCreateNetworkTemplateFormState = const CreateNetworkTemplateFormState(
        selectedDerivationPath: LegacyDerivationPathSelectMenuItem(
          title: 'Ledger',
          exampleAddress: '0x000...000',
          derivationPathTemplate: "m/44'/60'/0'/{{i}}",
          derivationPathName: 'Ledger',
        ),
      );

      expect(actualCreateNetworkTemplateFormState, expectedCreateNetworkTemplateFormState);
    });
  });

  group('Tests of CreateEthereumTemplateFormCubit.buildNetworkTemplateModel()', () {
    test('Should [return NetworkTemplateModel] with selected values', () async {
      // Arrange
      actualCreateEthereumTemplateFormCubit.nameTextEditingController.text = 'NEW NETWORK TEMPLATE';

      // Act
      NetworkTemplateModel actualNetworkTemplateModel = await actualCreateEthereumTemplateFormCubit.buildNetworkTemplateModel();

      // Assert
      NetworkTemplateModel expectedNetworkTemplateModel = NetworkTemplateModel(
        name: 'NEW NETWORK TEMPLATE',
        networkIconType: NetworkIconType.ethereum,
        derivationPathName: 'Ledger',
        derivationPathTemplate: "m/44'/60'/0'/{{i}}",
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );

      expect(actualNetworkTemplateModel, expectedNetworkTemplateModel);
    });
  });

  group('Tests of CreateEthereumTemplateFormCubit.save()', () {
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

    test('Should [return create network template] and save it in database', () async {
      // Act
      NetworkTemplateModel? actualNetworkTemplateModel = await actualCreateEthereumTemplateFormCubit.save();

      List<NetworkTemplateEntity> actualNetworkTemplatesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkTemplates.where().findAll();
      });

      // Assert
      NetworkTemplateModel expectedNetworkTemplateModel = NetworkTemplateModel(
        name: 'NEW NETWORK TEMPLATE',
        networkIconType: NetworkIconType.ethereum,
        derivationPathName: 'Ledger',
        derivationPathTemplate: "m/44'/60'/0'/{{i}}",
        addressEncoder: EthereumAddressEncoder(),
        derivator: Secp256k1Derivator(),
        curveType: CurveType.secp256k1,
        walletType: WalletType.legacy,
        predefinedNetworkTemplateId: 817800260,
      );
      List<NetworkTemplateEntity> expectedNetworkTemplatesDatabaseValue = <NetworkTemplateEntity>[
        // @formatter:off
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        const NetworkTemplateEntity(addressEncoderType: 'ethereum(false)', curveType: CurveType.secp256k1, derivationPathName: 'Ledger', derivationPathTemplate: "m/44'/60'/0'/{{i}}", derivatorType: 'secp256k1', networkIconType: NetworkIconType.ethereum, name: 'NEW NETWORK TEMPLATE', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy),
        // @formatter:on
      ];

      expect(actualNetworkTemplateModel, expectedNetworkTemplateModel);
      expect(actualNetworkTemplatesDatabaseValue, expectedNetworkTemplatesDatabaseValue);
    });

    test('Should [return null] and [emit CreateNetworkTemplateFormState] with [nameErrorBool==TRUE] if name already exists in database', () async {
      // Act
      NetworkTemplateModel? actualNetworkTemplateModel = await actualCreateEthereumTemplateFormCubit.save();

      // Assert
      CreateNetworkTemplateFormState expectedCreateNetworkTemplateFormState = const CreateNetworkTemplateFormState(
        nameErrorBool: true,
        selectedDerivationPath: LegacyDerivationPathSelectMenuItem(
          title: 'Ledger',
          exampleAddress: '0x000...000',
          derivationPathTemplate: "m/44'/60'/0'/{{i}}",
          derivationPathName: 'Ledger',
        ),
      );

      expect(actualNetworkTemplateModel, null);
      expect(actualCreateEthereumTemplateFormCubit.state, expectedCreateNetworkTemplateFormState);
    });
  });
}
