import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/network_templates_service.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';

class NetworkTemplateSelectPageCubit extends Cubit<NetworkTemplateSelectPageState> {
  final NetworkTemplatesService _networkTemplatesService = globalLocator<NetworkTemplatesService>();

  NetworkTemplateSelectPageCubit() : super(NetworkTemplateSelectPageState.loading());

  Future<void> refresh() async {
    Map<NetworkTemplateModel, List<NetworkTemplateModel>> networkTemplateModelMap = await _networkTemplatesService.getAllAsMap();
    emit(NetworkTemplateSelectPageState(networkTemplateModelMap: networkTemplateModelMap, loadingBool: false));
  }

  void search(String pattern) {
    emit(state.copyWith(searchPattern: pattern));
  }

  Future<void> deleteSelected() async {
    List<NetworkTemplateModel> selectedTransactions = state.selectedNetworkTemplateModels;
    await _networkTemplatesService.deleteAll(selectedTransactions);
    await refresh();
  }

  void toggleSelection(NetworkTemplateModel networkTemplateModel) {
    if (state.selectionModel == null) {
      select(networkTemplateModel);
    } else {
      if (state.selectionModel!.selectedItems.contains(networkTemplateModel)) {
        unselect(networkTemplateModel);
      } else {
        select(networkTemplateModel);
      }
    }
  }

  void select(NetworkTemplateModel networkTemplateModel) {
    int allTransactionsCount = state.networkTemplateModelList.length;

    List<NetworkTemplateModel> selectedItems = List<NetworkTemplateModel>.from(state.selectedNetworkTemplateModels, growable: true)..add(networkTemplateModel);
    emit(state.copyWith(selectionModel: SimpleSelectionModel<NetworkTemplateModel>(selectedItems: selectedItems, allItemsCount: allTransactionsCount)));
  }

  void selectAll() {
    int allTransactionsCount = state.networkTemplateModelList.length;
    emit(state.copyWith(
      selectionModel: SimpleSelectionModel<NetworkTemplateModel>(
        allItemsCount: allTransactionsCount,
        selectedItems: state.networkTemplateModelList,
      ),
    ));
  }

  void unselectAll() {
    int allTransactionsCount = state.networkTemplateModelList.length;
    emit(state.copyWith(
      selectionModel: SimpleSelectionModel<NetworkTemplateModel>.empty(allItemsCount: allTransactionsCount),
    ));
  }

  void unselect(NetworkTemplateModel networkTemplateModel) {
    int allTransactionsCount = state.networkTemplateModelList.length;

    List<NetworkTemplateModel> selectedItems = List<NetworkTemplateModel>.from(state.selectedNetworkTemplateModels, growable: true)
      ..remove(networkTemplateModel);
    emit(state.copyWith(selectionModel: SimpleSelectionModel<NetworkTemplateModel>(selectedItems: selectedItems, allItemsCount: allTransactionsCount)));
  }

  void disableSelection() {
    emit(state.copyWith(forceOverrideBool: true, selectionModel: null));
  }
}
