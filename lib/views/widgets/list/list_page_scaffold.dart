import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

class ListPageScaffold<T extends AListItemModel, C extends AListCubit<T>> extends StatefulWidget {
  final String defaultPageTitle;
  final C listCubit;
  final Widget Function(BuildContext context, ListState listState) bodyBuilder;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? padding;

  const ListPageScaffold({
    required this.defaultPageTitle,
    required this.listCubit,
    required this.bodyBuilder,
    this.boxDecoration,
    this.padding,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListPageScaffoldState<T, C>();
}

class _ListPageScaffoldState<T extends AListItemModel, C extends AListCubit<T>> extends State<ListPageScaffold<T, C>> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<C, ListState>(
        bloc: widget.listCubit,
        builder: (BuildContext context, ListState listState) {
          String pageTitle = listState.loadingBool ? '' : listState.groupModel?.name ?? widget.defaultPageTitle;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: CustomScaffold(
              key: Key('grid${listState.filesystemPath.fullPath}'),
              title: pageTitle,
              popAvailableBool: listState.canPop == false,
              popButtonVisible: listState.canPop,
              customPopCallback: listState.canPop ? () => _handleCustomPop(listState) : null,
              padding: widget.padding,
              boxDecoration: widget.boxDecoration,
              body: widget.bodyBuilder(context, listState),
            ),
          );
        },
      ),
    );
  }

  void _handleCustomPop(ListState listState) {
    if (listState.isSelectionEnabled) {
      _cancelSelection();
    } else if (listState.canPop) {
      widget.listCubit.navigateBack();
    }
  }

  void _cancelSelection() {
    widget.listCubit.disableSelection();
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
