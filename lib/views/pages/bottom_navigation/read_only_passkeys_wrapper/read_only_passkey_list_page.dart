import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/passkeys_wrapper/passkeys_list_page/passkey_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/passkeys_wrapper/passkey_list_page/passkey_list_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_wrapper.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/list_item_actions_wrapper.dart';
import 'package:snggle/views/widgets/list/list_page_scaffold.dart';
import 'package:snggle/views/widgets/list/sliver_page_list.dart';

@RoutePage()
class ReadOnlyPasskeyListPage extends StatefulWidget {
  const ReadOnlyPasskeyListPage({super.key});

  @override
  State<ReadOnlyPasskeyListPage> createState() =>
      _ReadOnlyPasskeyListPageState();
}

class _ReadOnlyPasskeyListPageState
    extends State<ReadOnlyPasskeyListPage> {
  static const String defaultPageTitle = 'PASSKEYS';

  final DraggedItemNotifier draggedItemNotifier = DraggedItemNotifier();

  final PasskeyListPageCubit passkeyListPageCubit =
  PasskeyListPageCubit();

  @override
  void initState() {
    super.initState();
    passkeyListPageCubit.refreshAll();
  }

  @override
  void dispose() {
    passkeyListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold<PasskeyModel, PasskeyListPageCubit>(
      defaultPageTitle: defaultPageTitle,
      listCubit: passkeyListPageCubit,
      bodyBuilder: (BuildContext context, ListState listState) {
        return CustomScrollView(
          shrinkWrap: listState.isScrollDisabled,
          physics: listState.isScrollDisabled
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          slivers: <Widget>[
            if (listState.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: CustomBottomNavigationBar.contentHeight,
                    ),
                    child: Text(
                      'There are no saved Passkeys in Snggle',
                    ),
                  ),
                ),
              )
            else ...<Widget>[
              SliverPageList(
                addButtonVisibleBool: false,
                loadingBool: listState.loadingBool,
                items: listState.visibleItems,
                selectedItems: listState.selectedItems,
                creationButton: null,
                itemBuilder: (AListItemModel listItemModel) {
                  if (listItemModel is! PasskeyModel) {
                    return const SizedBox.shrink();
                  }

                  return HorizontalListItemAnimationWrapper(
                    key: Key(
                      'item${listItemModel.filesystemPath.fullPath}',
                    ),
                    childBuilder: (
                        AnimationController fadeAnimationController,
                        AnimationController slideAnimationController,
                        ) {
                      return ListItemActionsWrapper<
                          PasskeyModel,
                          PasskeyListPageCubit>(
                        allowItemRenamingBool: false,
                        defaultPageTitle: defaultPageTitle,
                        draggedItemNotifier: draggedItemNotifier,
                        listItemSize:
                        HorizontalListItemLayout.listItemSize,
                        listCubit: passkeyListPageCubit,
                        listItemModel: listItemModel,
                        onNavigate: _navigateToNextPage,
                        selectionPadding: const EdgeInsets.all(5),
                        child: PasskeyListItem(
                          passkeyModel: listItemModel,
                          fadeAnimationController:
                          fadeAnimationController,
                          slideAnimationController:
                          slideAnimationController,
                        ),
                      );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _navigateToNextPage(
      AListItemModel listItemModel,
      PasswordModel passwordModel,
      ) async {
    if (listItemModel is! PasskeyModel) {
      return;
    }

    globalLocator<PasswordController>().addPassword(
      passwordModel,
      listItemModel.filesystemPath,
    );

    await AutoRouter.of(context).push(
      PasskeyDetailsRoute(
        passkeyModel: listItemModel,
      ),
    );

    await passkeyListPageCubit.refreshAll();
  }
}