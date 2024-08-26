import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_content.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class NetworkTemplateListItemContextTooltip extends StatefulWidget {
  final NetworkTemplateModel networkTemplateModel;
  final NetworkTemplateSelectPageCubit networkTemplateSelectPageCubit;
  final VoidCallback onCloseToolbar;

  const NetworkTemplateListItemContextTooltip({
    required this.networkTemplateModel,
    required this.networkTemplateSelectPageCubit,
    required this.onCloseToolbar,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemContextTooltipState();
}

class _ListItemContextTooltipState extends State<NetworkTemplateListItemContextTooltip> {
  @override
  Widget build(BuildContext context) {
    return ContextTooltipContent(
      title: widget.networkTemplateModel.name,
      actions: <ContextTooltipItem>[
        ContextTooltipItem(
          assetIconData: AppIcons.menu_select,
          label: 'Select',
          onTap: _selectTransaction,
        ),
      ],
    );
  }

  void _selectTransaction() {
    widget.networkTemplateSelectPageCubit.select(widget.networkTemplateModel);
    widget.onCloseToolbar();
  }
}
