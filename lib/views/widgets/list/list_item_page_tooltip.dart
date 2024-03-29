import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class ListItemPageTooltip<T extends AListItemModel, C extends AListCubit<T>> extends StatefulWidget {
  final C listCubit;

  const ListItemPageTooltip({
    required this.listCubit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemPageTooltipState<T, C>();
}

class _ListItemPageTooltipState<T extends AListItemModel, C extends AListCubit<T>> extends State<ListItemPageTooltip<T, C>> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, ListState>(
      bloc: widget.listCubit,
      builder: (BuildContext buildContext, ListState listState) {
        SelectionModel? selectionModel = listState.selectionModel;
        if (selectionModel == null) {
          return const SizedBox();
        }

        return BottomTooltip(
          actions: <BottomTooltipItem>[
            BottomTooltipItem(
              iconData: selectionModel.areAllItemsSelected ? AppIcons.close_1 : AppIcons.check,
              label: selectionModel.areAllItemsSelected ? 'Clear' : 'All',
              onTap: _pressSelectAllButton,
            ),
            BottomTooltipItem(
              iconData: AppIcons.pin,
              label: 'Pin',
              onTap: selectionModel.canPinAll ? () => _pressPinButton(selectionModel, true) : null,
            ),
            BottomTooltipItem(
              iconData: AppIcons.unpin,
              label: 'Unpin',
              onTap: selectionModel.canUnpinAll ? () => _pressPinButton(selectionModel, false) : null,
            ),
            BottomTooltipItem(
              iconData: AppIcons.lock,
              label: 'Lock',
              onTap: selectionModel.canLockAll ? () => _pressLockButton(selectionModel) : null,
            ),
          ],
        );
      },
    );
  }

  void _pressSelectAllButton() {
    widget.listCubit.toggleSelectAll();
  }

  void _pressPinButton(SelectionModel selectionModel, bool pinnedBool) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: pinnedBool ? 'Pin' : 'Unpin',
        content: 'Are you sure you want to ${pinnedBool ? 'pin' : 'unpin'} selected items?',
        onConfirm: () {
          widget.listCubit.pinSelection(selectedItems: selectionModel.selectedItems, pinnedBool: pinnedBool);
          _closeTooltip();
        },
      ),
    );
  }

  void _pressLockButton(SelectionModel selectionModel) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Lock',
        content: 'Are you sure you want to lock selected items?',
        onConfirm: () {
          widget.listCubit.lockSelection(selectedItems: selectionModel.selectedItems, encryptedBool: true);
          _closeTooltip();
        },
      ),
    );
  }

  void _closeTooltip() {
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}