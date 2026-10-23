import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/passkeys_wrapper/passkeys_list_page/passkey_list_page_cubit.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/views/pages/bottom_navigation/passkeys_wrapper/passkey_list_page/passkey_list_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_wrapper.dart';
import 'package:snggle/views/widgets/list/list_page_scaffold.dart';
import 'package:snggle/views/widgets/list/sliver_page_list.dart';

@RoutePage()
class PasskeyListPage extends StatefulWidget {
  const PasskeyListPage({super.key});

  @override
  State<PasskeyListPage> createState() => _PasskeyListPageState();
}

class _PasskeyListPageState extends State<PasskeyListPage> {
  final PasskeyListPageCubit passkeyListPageCubit = PasskeyListPageCubit();

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
      defaultPageTitle: 'PASSKEYS',
      listCubit: passkeyListPageCubit,
      bodyBuilder: (BuildContext context, ListState listState) {
        return CustomScrollView(
          shrinkWrap: listState.isScrollDisabled,
          physics: listState.isScrollDisabled ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
          slivers: <Widget>[
            if (listState.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: CustomBottomNavigationBar.contentHeight,
                    ),
                    child: Text('No passkeys yet'),
                  ),
                ),
              )
            else ...<Widget>[
              SliverPageList(
                loadingBool: listState.loadingBool,
                items: listState.visibleItems,
                selectedItems: listState.selectedItems,
                addButtonVisibleBool: false,
                itemBuilder: (AListItemModel listItemModel) {
                  if (listItemModel is! PasskeyModel) {
                    return const SizedBox.shrink();
                  }

                  return HorizontalListItemAnimationWrapper(
                    key: Key(
                      'item${listItemModel.filesystemPath.fullPath}',
                    ),
                    childBuilder:
                        (
                          AnimationController fadeAnimationController,
                          AnimationController slideAnimationController,
                        ) {
                          return PasskeyListItem(
                            passkeyModel: listItemModel,
                            fadeAnimationController: fadeAnimationController,
                            slideAnimationController: slideAnimationController,
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
}
