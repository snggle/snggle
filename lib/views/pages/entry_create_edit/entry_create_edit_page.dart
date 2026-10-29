import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/entry_create_edit/entry_page_type.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/entry_form/entry_form.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class EntryCreateEditPage extends StatefulWidget {
  final FilesystemPath parentFilesystemPath;
  final EntryModel? entryModel;
  final EntryPageType entryPageType;
  final bool? obscurePasswordBool;

  const EntryCreateEditPage({
    required this.entryPageType,
    required this.parentFilesystemPath,
    this.entryModel,
    this.obscurePasswordBool = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryCreateEditPageState();
}

class _EntryCreateEditPageState extends State<EntryCreateEditPage> {
  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();

  late bool _obscurePasswordBool;

  late final EntryCreateEditPageCubit entryCreateEditPageCubit = EntryCreateEditPageCubit(
    parentFilesystemPath: widget.parentFilesystemPath,
    entryModel: widget.entryModel,
    entryPageType: widget.entryPageType,
  );

  @override
  void initState() {
    super.initState();
    _obscurePasswordBool = widget.obscurePasswordBool ?? true;
    entryCreateEditPageCubit.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    keyboardValueNotifier.dispose();
    entryCreateEditPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryCreateEditPageCubit, EntryCreateEditPageState>(
      bloc: entryCreateEditPageCubit,
      builder: (BuildContext context, EntryCreateEditPageState state) {
        return CustomScaffold(
          title: switch (widget.entryPageType) {
            EntryPageType.create => 'CREATE ENTRY',
            EntryPageType.edit => 'EDIT ENTRY',
          },
          resizeToAvoidBottomInsetBool: true,
          body: KeyboardVisibilityBuilder(
            keyboardValueNotifier: keyboardValueNotifier,
            builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
              bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;

              return ScrollableLayout(
                scrollController: scrollController,
                bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
                tooltipVisibleBool: anyKeyboardVisibleBool == false,
                tooltipItems: <Widget>[
                  BottomTooltipItem(
                    label: 'Save',
                    assetIconData: AppIcons.menu_save,
                    onTap: _finishButtonEnabledBool ? _save : null,
                  ),
                ],
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      EntryForm(
                        nameTextEditingController: entryCreateEditPageCubit.nameTextEditingController,
                        websiteTextEditingController: entryCreateEditPageCubit.websiteTextEditingController,
                        emailTextEditingController: entryCreateEditPageCubit.emailTextEditingController,
                        emailFocusNode: entryCreateEditPageCubit.emailFocusNode,
                        emailInvalidBool: state.emailInvalidBool,
                        usernameTextEditingController: entryCreateEditPageCubit.usernameTextEditingController,
                        passwordTextEditingController: entryCreateEditPageCubit.passwordTextEditingController,
                        readOnlyBool: false,
                        entryNameEmptyBool: state.entryNameEmptyBool,
                        obscurePasswordBool: _obscurePasswordBool,
                        onTogglePasswordVisibility: () => setState(() => _obscurePasswordBool = !_obscurePasswordBool),
                      ),
                      SizedBox(height: anyKeyboardVisibleBool ? 40 : 100),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool get _finishButtonEnabledBool =>
      entryCreateEditPageCubit.state.entryNameEmptyBool == false && entryCreateEditPageCubit.state.emailInvalidBool == false;

  Future<void> _save() async {
    await CustomLoadingDialog.show<EntryModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: entryCreateEditPageCubit.save,
      onSuccess: (EntryModel? entryModel) async {
        if (entryModel != null) {
          AutoRouter.of(context).root.pop<bool>(true);
        }
      },
    );
  }
}
