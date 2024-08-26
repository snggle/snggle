import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_cubit.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_state.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';
import '../../../../../utils/test_network_templates.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late NetworkTemplateSelectPageCubit actualNetworkTemplateSelectPageCubit;

  // @formatter:off
  NetworkTemplateModel networkTemplateModel1 = TestNetworkTemplates.ethereum;
  // @formatter:on

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

    actualNetworkTemplateSelectPageCubit = NetworkTemplateSelectPageCubit();
  });

  group('Tests of NetworkTemplateSelectPageCubit process', () {
    group('Tests of NetworkTemplateSelectPageCubit initialization', () {
      test('Should [emit NetworkTemplateSelectPageState] with [loadingBool == TRUE]', () {
        // Act
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState.loading();

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.init()', () {
      test('Should [emit NetworkTemplateSelectPageState] with TransactionHistoryModel', () async {
        // Act
        await actualNetworkTemplateSelectPageCubit.refresh();
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.refresh()', () {
      test('Should [emit NetworkTemplateSelectPageState] with all templates existing in database', () async {
        // Act
        await actualNetworkTemplateSelectPageCubit.refresh();
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.search()', () {
      test('Should [emit NetworkTemplateSelectPageState] with search pattern set', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.search('Ethereum');
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          searchPattern: 'Ethereum',
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });

      test('Should [emit NetworkTemplateSelectPageState] with empty search pattern', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.search('');
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.selectAll()', () {
      test('Should [emit NetworkTemplateSelectPageState] with [all templates SELECTED]', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.selectAll();
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          selectionModel: SimpleSelectionModel<NetworkTemplateModel>(
            allItemsCount: 1,
            selectedItems: <NetworkTemplateModel>[networkTemplateModel1],
          ),
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );
        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.unselectAll()', () {
      test('Should [emit NetworkTemplateSelectPageState] with [all templates UNSELECTED] if all items were selected before', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.unselectAll();
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          selectionModel: const SimpleSelectionModel<NetworkTemplateModel>(
            allItemsCount: 1,
            selectedItems: <NetworkTemplateModel>[],
          ),
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.select()', () {
      test('Should [emit NetworkTemplateSelectPageState] with specified template selected', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.select(networkTemplateModel1);
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          selectionModel: SimpleSelectionModel<NetworkTemplateModel>(
            allItemsCount: 1,
            selectedItems: <NetworkTemplateModel>[networkTemplateModel1],
          ),
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.unselect()', () {
      test('Should [emit NetworkTemplateSelectPageState] with specified template unselected', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.unselect(networkTemplateModel1);
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          selectionModel: const SimpleSelectionModel<NetworkTemplateModel>(
            allItemsCount: 1,
            selectedItems: <NetworkTemplateModel>[],
          ),
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.disableSelection()', () {
      test('Should [emit NetworkTemplateSelectPageState] without SelectionModel set', () async {
        // Act
        actualNetworkTemplateSelectPageCubit.disableSelection();

        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            // @formatter:off
            DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[NetworkTemplateModel(addressEncoder: EthereumAddressEncoder(), curveType: CurveType.secp256k1, derivationPathName: null, derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}", derivator: Secp256k1Derivator(), networkIconType: NetworkIconType.ethereum, name: 'Ethereum', predefinedNetworkTemplateId: 817800260, walletType: WalletType.legacy)],
            // @formatter:on
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });

    group('Tests of NetworkTemplateSelectPageCubit.deleteSelected()', () {
      test('Should [emit NetworkTemplateSelectPageState] without deleted template', () async {
        // Act
        // Select wallet to delete
        actualNetworkTemplateSelectPageCubit.select(networkTemplateModel1);
        await actualNetworkTemplateSelectPageCubit.deleteSelected();
        NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = actualNetworkTemplateSelectPageCubit.state;

        // Assert
        NetworkTemplateSelectPageState expectedNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
          networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
            DefaultNetworkTemplates.ethereum: const <NetworkTemplateModel>[],
          },
        );

        expect(actualNetworkTemplateSelectPageState, expectedNetworkTemplateSelectPageState);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
