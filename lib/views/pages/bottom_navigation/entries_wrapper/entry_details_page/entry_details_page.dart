import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_page_type.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/entry_form/entry_form.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class EntryDetailsPage extends StatefulWidget {
  final EntryModel entryModel;

  const EntryDetailsPage({
    required this.entryModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryDetailsPageState();
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  final ScrollController scrollController = ScrollController();

  late final EntryDetailsPageCubit entryDetailsPageCubit = EntryDetailsPageCubit(
    entryModel: widget.entryModel,
  );

  bool _obscurePasswordBool = true;

  @override
  void initState() {
    super.initState();
    entryDetailsPageCubit.refresh();
  }

  @override
  void dispose() {
    scrollController.dispose();
    entryDetailsPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryDetailsPageCubit, EntryDetailsPageState>(
      bloc: entryDetailsPageCubit,
      builder: (BuildContext context, EntryDetailsPageState entryDetailsPageState) {
        return CustomScaffold(
          title: entryDetailsPageCubit.entryModel.name,
          actions: <Widget>[
            InkWell(
              onTap: _openEditEntryPage,
              child: const Padding(
                padding: EdgeInsets.only(right: 6),
                child: AssetIcon(AppIcons.menu_rename),
              ),
            ),
          ],
          body: GradientScrollbar(
            scrollController: scrollController,
            visibleBool: true,
            margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.contentHeight),
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: EntryForm(
                      websiteTextEditingController: entryDetailsPageCubit.websiteTextEditingController,
                      emailTextEditingController: entryDetailsPageCubit.emailTextEditingController,
                      usernameTextEditingController: entryDetailsPageCubit.usernameTextEditingController,
                      passwordTextEditingController: entryDetailsPageCubit.passwordTextEditingController,
                      readOnlyBool: true,
                      obscurePasswordBool: _obscurePasswordBool,
                      onTogglePasswordVisibility: () => setState(() => _obscurePasswordBool = !_obscurePasswordBool),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openEditEntryPage() async {
    bool modificationSavedBool =
        (await AutoRouter.of(context).push<bool>(
          EntryCreateEditRoute(
            entryPageType: EntryPageType.edit,
            entryModel: entryDetailsPageCubit.entryModel,
            obscurePasswordBool: _obscurePasswordBool,
            parentFilesystemPath: entryDetailsPageCubit.entryModel.filesystemPath,
          ),
        )) ??
        false;

    _obscurePasswordBool = true;

    if (modificationSavedBool == false || mounted == false) {
      return;
    }

    unawaited(entryDetailsPageCubit.refresh());
    await _showModificationSuccessDialog();
  }

  Future<void> _showModificationSuccessDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomDialog(
        title: 'Success',
        content: const Text(
          'The entry modification process has been completed.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Done',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
