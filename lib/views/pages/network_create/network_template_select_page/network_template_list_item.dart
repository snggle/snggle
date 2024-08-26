import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/network_create/network_template_select/network_template_select_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_select_page/network_template_list_item_context_tooltip.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

class NetworkTemplateListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final NetworkTemplateModel networkTemplateModel;
  final NetworkTemplateSelectPageCubit networkTemplateSelectPageCubit;
  final VoidCallback? onNavigate;

  const NetworkTemplateListItem({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.networkTemplateModel,
    required this.networkTemplateSelectPageCubit,
    this.onNavigate,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkTemplateListItemState();
}

class _NetworkTemplateListItemState extends State<NetworkTemplateListItem> {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    String? derivationPathName = widget.networkTemplateModel.derivationPathName;

    Widget child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          if (widget.selectionEnabledBool) ...<Widget>[
            CustomCheckbox(selectedBool: widget.selectedBool, size: 14),
            const SizedBox(width: 10),
          ],
          SizedBox(
            width: 14,
            height: 14,
            child: AssetIcon(
              widget.networkTemplateModel.networkIconType.networkTemplatesListIcon,
              size: 14,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              widget.networkTemplateModel.name,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.darkGrey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${widget.networkTemplateModel.baseDerivationPath} ${derivationPathName?.isNotEmpty == true ? '(${derivationPathName})' : ''}',
            style: textTheme.labelMedium?.copyWith(color: AppColors.middleGrey, letterSpacing: 0.68),
          ),
        ],
      ),
    );

    if (widget.selectionEnabledBool) {
      return GestureDetector(
        onTap: _toggleSelection,
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    } else {
      return ContextTooltipWrapper(
        controller: actionsPopupController,
        content: NetworkTemplateListItemContextTooltip(
          networkTemplateModel: widget.networkTemplateModel,
          networkTemplateSelectPageCubit: widget.networkTemplateSelectPageCubit,
          onCloseToolbar: _closeToolbar,
        ),
        child: InkWell(
          onTap: widget.onNavigate,
          onLongPress: _openToolbar,
          child: child,
        ),
      );
    }
  }

  void _toggleSelection() {
    widget.networkTemplateSelectPageCubit.toggleSelection(widget.networkTemplateModel);
  }

  void _closeToolbar() {
    actionsPopupController.hideMenu();
  }

  void _openToolbar() {
    actionsPopupController.showMenu();
  }
}
