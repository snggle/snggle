import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_cubit.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_state.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/network_create/network_template_select_page/network_template_list_item.dart';
import 'package:snggle/views/pages/network_create/network_template_select_page/predefined_network_template_list_item.dart';

class SliverNetworkTemplateSection extends StatefulWidget {
  final FilesystemPath parentFilesystemPath;
  final NetworkTemplateModel predefinedNetworkTemplateModel;
  final List<NetworkTemplateModel> childNetworkTemplateModels;
  final NetworkTemplateSelectPageCubit networkTemplateSelectPageCubit;

  const SliverNetworkTemplateSection({
    required this.parentFilesystemPath,
    required this.predefinedNetworkTemplateModel,
    required this.childNetworkTemplateModels,
    required this.networkTemplateSelectPageCubit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SliverNetworkTemplateSectionState();
}

class _SliverNetworkTemplateSectionState extends State<SliverNetworkTemplateSection> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 10),
      sliver: MultiSliver(
        children: <Widget>[
          SliverToBoxAdapter(
            child: PredefinedNetworkTemplateListItem(
              onPressed: null,
              networkTemplateModel: widget.predefinedNetworkTemplateModel,
            ),
          ),
          SliverList.builder(
            itemCount: widget.childNetworkTemplateModels.length,
            itemBuilder: (BuildContext context, int index) {
              NetworkTemplateModel networkTemplateModel = widget.childNetworkTemplateModels[index];
              NetworkTemplateSelectPageState networkTemplateSelectPageState = widget.networkTemplateSelectPageCubit.state;

              return NetworkTemplateListItem(
                selectedBool: networkTemplateSelectPageState.selectedNetworkTemplateModels.contains(networkTemplateModel),
                selectionEnabledBool: networkTemplateSelectPageState.selectionModel != null,
                onNavigate: () => _navigateToNetworkGroupCreatePage(networkTemplateModel),
                networkTemplateModel: networkTemplateModel,
                networkTemplateSelectPageCubit: widget.networkTemplateSelectPageCubit,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToNetworkGroupCreatePage(NetworkTemplateModel networkTemplateModel) async {
    await AutoRouter.of(context).navigate(NetworkGroupCreateRoute(
      networkTemplateModel: networkTemplateModel,
      parentFilesystemPath: widget.parentFilesystemPath,
    ));
  }
}
