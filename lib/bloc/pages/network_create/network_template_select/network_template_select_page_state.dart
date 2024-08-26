import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';

class NetworkTemplateSelectPageState extends Equatable {
  final Map<NetworkTemplateModel, List<NetworkTemplateModel>> networkTemplateModelMap;
  final bool loadingBool;
  final String searchPattern;
  final SimpleSelectionModel<NetworkTemplateModel>? selectionModel;

  const NetworkTemplateSelectPageState({
    required this.networkTemplateModelMap,
    this.loadingBool = false,
    this.searchPattern = '',
    this.selectionModel,
  });

  NetworkTemplateSelectPageState.loading() : this(loadingBool: true, networkTemplateModelMap: <NetworkTemplateModel, List<NetworkTemplateModel>>{});

  NetworkTemplateSelectPageState copyWith({
    bool forceOverrideBool = false,
    Map<NetworkTemplateModel, List<NetworkTemplateModel>>? networkTemplateModelMap,
    bool? loadingBool,
    String? searchPattern,
    SimpleSelectionModel<NetworkTemplateModel>? selectionModel,
  }) {
    return NetworkTemplateSelectPageState(
      networkTemplateModelMap: networkTemplateModelMap ?? this.networkTemplateModelMap,
      loadingBool: loadingBool ?? this.loadingBool,
      searchPattern: searchPattern ?? this.searchPattern,
      selectionModel: forceOverrideBool ? selectionModel : selectionModel ?? this.selectionModel,
    );
  }

  List<NetworkTemplateModel> get networkTemplateModelList {
    return networkTemplateModelMap.values.expand((List<NetworkTemplateModel> networkTemplateModels) => networkTemplateModels).toList();
  }

  List<NetworkTemplateModel> get selectedNetworkTemplateModels {
    return selectionModel?.selectedItems ?? <NetworkTemplateModel>[];
  }

  Map<NetworkTemplateModel, List<NetworkTemplateModel>> get filteredNetworkTemplateModelMap {
    if (searchPattern.isEmpty) {
      return networkTemplateModelMap;
    }

    return networkTemplateModelMap.map((NetworkTemplateModel parentNetworkTemplateModel, List<NetworkTemplateModel> childNetworkTemplateModels) {
      List<NetworkTemplateModel> filteredChildNetworkTemplateModels = childNetworkTemplateModels.where((NetworkTemplateModel networkTemplateModel) {
        return networkTemplateModel.name.toLowerCase().contains(searchPattern.toLowerCase());
      }).toList();

      return MapEntry<NetworkTemplateModel, List<NetworkTemplateModel>>(parentNetworkTemplateModel, filteredChildNetworkTemplateModels);
    });
  }

  bool get isSelectionEnabled {
    return selectionModel != null;
  }

  @override
  List<Object?> get props => <Object?>[networkTemplateModelMap, loadingBool, searchPattern, selectionModel];
}
