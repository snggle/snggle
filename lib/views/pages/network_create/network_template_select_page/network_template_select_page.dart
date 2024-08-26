import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_cubit.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/network_create/network_template_select_page/create_template_floating_button.dart';
import 'package:snggle/views/pages/network_create/network_template_select_page/sliver_network_template_section.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_search_bar.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class NetworkTemplateSelectPage extends StatefulWidget {
  final FilesystemPath parentFilesystemPath;

  const NetworkTemplateSelectPage({
    required this.parentFilesystemPath,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkTemplateSelectPageState();
}

class _NetworkTemplateSelectPageState extends State<NetworkTemplateSelectPage> {
  final NetworkTemplateSelectPageCubit networkTemplateSelectPageCubit = NetworkTemplateSelectPageCubit();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    networkTemplateSelectPageCubit.refresh();
  }

  @override
  void dispose() {
    networkTemplateSelectPageCubit.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkTemplateSelectPageCubit, NetworkTemplateSelectPageState>(
      bloc: networkTemplateSelectPageCubit,
      builder: (BuildContext context, NetworkTemplateSelectPageState state) {
        SimpleSelectionModel<NetworkTemplateModel>? selectionModel = state.selectionModel;

        return CustomScaffold(
          title: 'Create Network',
          subtitle: 'Select the appropriate template to use',
          popAvailableBool: state.isSelectionEnabled == false,
          customPopCallback: state.isSelectionEnabled ? () => _handleCustomPop(state) : null,
          floatingActionButton: state.selectionModel == null ? CreateTemplateFloatingButton(onPressed: _navigateToCreateTemplatePage) : null,
          body: ScrollableLayout(
            scrollController: scrollController,
            bottomMarginVisibleBool: false,
            tooltipVisibleBool: state.selectionModel != null,
            tooltipItems: selectionModel != null
                ? <Widget>[
                    BottomTooltipItem(
                        assetIconData: selectionModel.areAllItemsSelected ? AppIcons.menu_unselect_all : AppIcons.menu_select_all,
                        label: selectionModel.areAllItemsSelected ? 'Clear' : 'All',
                        onTap: selectionModel.areAllItemsSelected ? networkTemplateSelectPageCubit.unselectAll : networkTemplateSelectPageCubit.selectAll),
                    BottomTooltipItem(
                      assetIconData: AppIcons.menu_delete,
                      label: 'Delete',
                      onTap: selectionModel.selectedItems.isEmpty ? null : _pressDeleteButton,
                    ),
                  ]
                : null,
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomSearchBar(
                      onChanged: networkTemplateSelectPageCubit.search,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 6)),
                for (MapEntry<NetworkTemplateModel, List<NetworkTemplateModel>> networkEntry in state.filteredNetworkTemplateModelMap.entries) ...<Widget>[
                  SliverNetworkTemplateSection(
                    parentFilesystemPath: widget.parentFilesystemPath,
                    predefinedNetworkTemplateModel: networkEntry.key,
                    childNetworkTemplateModels: networkEntry.value,
                    networkTemplateSelectPageCubit: networkTemplateSelectPageCubit,
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCustomPop(NetworkTemplateSelectPageState networkTemplateSelectPageState) {
    if (networkTemplateSelectPageState.isSelectionEnabled) {
      networkTemplateSelectPageCubit.disableSelection();
    }
  }

  Future<void> _navigateToCreateTemplatePage() async {
    await AutoRouter.of(context).push<void>(const NetworkTemplateCreateRoute());
    await networkTemplateSelectPageCubit.refresh();
  }

  void _pressDeleteButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Delete',
        content: 'Are you sure you want to delete selected items?',
        onConfirm: () {
          networkTemplateSelectPageCubit
            ..deleteSelected()
            ..disableSelection();
        },
      ),
    );
  }
}
