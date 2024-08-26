import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_state.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';

void main() {
  NetworkTemplateModel networkTemplateModel1 = NetworkTemplateModel(
    name: 'Ethereum1',
    networkIconType: NetworkIconType.ethereum,
    derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    addressEncoder: EthereumAddressEncoder(),
    derivator: Secp256k1Derivator(),
    curveType: CurveType.secp256k1,
    walletType: WalletType.legacy,
    predefinedNetworkTemplateId: 817800260,
  );

  NetworkTemplateModel networkTemplateModel2 = NetworkTemplateModel(
    name: 'Ethereum2',
    networkIconType: NetworkIconType.ethereum,
    derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    addressEncoder: EthereumAddressEncoder(),
    derivator: Secp256k1Derivator(),
    curveType: CurveType.secp256k1,
    walletType: WalletType.legacy,
    predefinedNetworkTemplateId: 817800260,
  );

  NetworkTemplateModel networkTemplateModel3 = NetworkTemplateModel(
    name: 'Ethereum3',
    networkIconType: NetworkIconType.ethereum,
    derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    addressEncoder: EthereumAddressEncoder(),
    derivator: Secp256k1Derivator(),
    curveType: CurveType.secp256k1,
    walletType: WalletType.legacy,
    predefinedNetworkTemplateId: 817800260,
  );

  group('Tests of NetworkTemplateSelectPageState.networkTemplateModelList getter', () {
    test('Should [return List of NetworkTemplateModel] representing all templates as list', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        searchPattern: 'Ethereum',
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      List<NetworkTemplateModel> actualAllNetworkTemplateModelsList = actualNetworkTemplateSelectPageState.networkTemplateModelList;

      // Assert
      List<NetworkTemplateModel> expectedAllNetworkTemplateModelsList = <NetworkTemplateModel>[
        networkTemplateModel1,
        networkTemplateModel2,
        networkTemplateModel3
      ];

      expect(actualAllNetworkTemplateModelsList, expectedAllNetworkTemplateModelsList);
    });
  });

  group('Tests of NetworkTemplateSelectPageState.selectedNetworkTemplateModels getter', () {
    test('Should [return List of NetworkTemplateModel] representing selected templates', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        selectionModel: SimpleSelectionModel<NetworkTemplateModel>(
          allItemsCount: 3,
          selectedItems: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2],
        ),
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      List<NetworkTemplateModel> actualSelectedNetworkTemplateModelsList = actualNetworkTemplateSelectPageState.selectedNetworkTemplateModels;

      // Assert
      List<NetworkTemplateModel> expectedSelectedNetworkTemplateModelsList = <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2];

      expect(actualSelectedNetworkTemplateModelsList, expectedSelectedNetworkTemplateModelsList);
    });

    test('Should [return EMPTY list] if [selection ENABLED] but no items selected', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        selectionModel: const SimpleSelectionModel<NetworkTemplateModel>(
          allItemsCount: 3,
          selectedItems: <NetworkTemplateModel>[],
        ),
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      List<NetworkTemplateModel> actualSelectedNetworkTemplateModelsList = actualNetworkTemplateSelectPageState.selectedNetworkTemplateModels;

      // Assert
      List<NetworkTemplateModel> expectedSelectedNetworkTemplateModelsList = <NetworkTemplateModel>[];

      expect(actualSelectedNetworkTemplateModelsList, expectedSelectedNetworkTemplateModelsList);
    });

    test('Should [return EMPTY list] if [selection DISABLED]', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      List<NetworkTemplateModel> actualSelectedNetworkTemplateModelsList = actualNetworkTemplateSelectPageState.selectedNetworkTemplateModels;

      // Assert
      List<NetworkTemplateModel> expectedSelectedNetworkTemplateModelsList = <NetworkTemplateModel>[];

      expect(actualSelectedNetworkTemplateModelsList, expectedSelectedNetworkTemplateModelsList);
    });
  });

  group('Tests of NetworkTemplateSelectPageState.filteredNetworkTemplateModelMap getter', () {
    test('Should [return ALL templates as map] if [search filter NOT EXIST]', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> actualNetworkTemplateModelsMap =
          actualNetworkTemplateSelectPageState.filteredNetworkTemplateModelMap;

      // Assert
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> expectedNetworkTemplateModelsMap = <NetworkTemplateModel, List<NetworkTemplateModel>>{
        // @formatter:off
        DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
        // @formatter:on
      };

      expect(actualNetworkTemplateModelsMap, expectedNetworkTemplateModelsMap);
    });

    test('Should [return FILTERED templates as map] if [search filter EXIST]', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        searchPattern: 'eum2',
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> actualNetworkTemplateModelsMap =
          actualNetworkTemplateSelectPageState.filteredNetworkTemplateModelMap;

      // Assert
      Map<NetworkTemplateModel, List<NetworkTemplateModel>> expectedNetworkTemplateModelsMap = <NetworkTemplateModel, List<NetworkTemplateModel>>{
        // @formatter:off
        DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel2],
        // @formatter:on
      };

      expect(actualNetworkTemplateModelsMap, expectedNetworkTemplateModelsMap);
    });
  });

  group('Tests of NetworkTemplateSelectPageState.isSelectionEnabled getter', () {
    test('Should [return TRUE] if [SelectionModel NOT EMPTY]', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        searchPattern: 'Ethereum',
        selectionModel: SimpleSelectionModel<NetworkTemplateModel>(
          allItemsCount: 3,
          selectedItems: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2],
        ),
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      bool actualIsSelectionEnabledBool = actualNetworkTemplateSelectPageState.isSelectionEnabled;

      // Assert
      expect(actualIsSelectionEnabledBool, true);
    });

    test('Should [return FALSE] if [SelectionModel EMPTY]', () {
      // Assert
      NetworkTemplateSelectPageState actualNetworkTemplateSelectPageState = NetworkTemplateSelectPageState(
        searchPattern: 'Ethereum',
        networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{
          // @formatter:off
          DefaultNetworkTemplates.ethereum: <NetworkTemplateModel>[networkTemplateModel1, networkTemplateModel2, networkTemplateModel3],
          // @formatter:on
        },
      );

      // Act
      bool actualIsSelectionEnabledBool = actualNetworkTemplateSelectPageState.isSelectionEnabled;

      // Assert
      expect(actualIsSelectionEnabledBool, false);
    });
  });
}
