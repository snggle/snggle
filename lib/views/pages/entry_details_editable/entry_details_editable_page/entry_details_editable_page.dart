import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_create_edit_status.dart';
import 'package:snggle/views/pages/entry_details_editable/entry_details_editable_page/editable_entry_field.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class EntryDetailsEditablePage extends StatefulWidget {
  final FilesystemPath? parentFilesystemPath;
  final EntryModel? entryModel;
  final EntryPageType entryPageType;
  final bool? obscurePasswordBool;

  const EntryDetailsEditablePage({
    required this.entryPageType,
    this.parentFilesystemPath,
    this.entryModel,
    this.obscurePasswordBool = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryDetailsEditablePageState();
}

class _EntryDetailsEditablePageState extends State<EntryDetailsEditablePage> {
  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();

  late bool _obscurePasswordBool;

  late final EntryDetailsEditablePageCubit entryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
    parentFilesystemPath: widget.parentFilesystemPath,
    entryModel: widget.entryModel,
    entryPageType: widget.entryPageType,
  );

  @override
  void initState() {
    super.initState();
    _obscurePasswordBool = widget.obscurePasswordBool ?? true;
    entryDetailsEditablePageCubit.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    keyboardValueNotifier.dispose();
    entryDetailsEditablePageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryDetailsEditablePageCubit, EntryDetailsEditablePageState>(
      bloc: entryDetailsEditablePageCubit,
      builder: (BuildContext context, EntryDetailsEditablePageState state) {
        return CustomScaffold(
          title: switch (widget.entryPageType) {
            EntryPageType.entryPageCreate => 'CREATE ENTRY',
            EntryPageType.entryPageEdit => 'EDIT ENTRY',
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
                      EditableEntryField(
                        label: 'Name',
                        textEditingController: entryDetailsEditablePageCubit.nameTextEditingController,
                      ),
                      if (state.entryNameEmptyBool)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ErrorMessageListTile(
                            message: 'Entry name cannot be empty',
                          ),
                        ),
                      const SizedBox(height: 12),
                      EditableEntryField(
                        label: 'Website',
                        textEditingController: entryDetailsEditablePageCubit.websiteTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      EditableEntryField(
                        label: 'Email',
                        textEditingController: entryDetailsEditablePageCubit.emailTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      EditableEntryField(
                        label: 'Username',
                        textEditingController: entryDetailsEditablePageCubit.usernameTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      EditableEntryField(
                        label: 'Password',
                        textEditingController: entryDetailsEditablePageCubit.passwordTextEditingController,
                        obscureTextBool: _obscurePasswordBool,
                        suffixWidget: InkWell(
                          onTap: () => setState(() => _obscurePasswordBool = !_obscurePasswordBool),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: AssetIcon(
                              _obscurePasswordBool ? AppIcons.details_hide : AppIcons.details_show,
                            ),
                          ),
                        ),
                        suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              GradientOutlinedButton.small(
                                width: 186,
                                label: 'Generate password',
                                onPressed: _showGeneratePasswordPage,
                              ),
                            ],
                          ),
                        ),
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

  bool get _finishButtonEnabledBool => entryDetailsEditablePageCubit.state.entryNameEmptyBool == false;

  Future<void> _save() async {
    await CustomLoadingDialog.show<EntryModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: entryDetailsEditablePageCubit.save,
      onSuccess: (EntryModel? entryModel) async {
        bool entrySavedBool = entryModel != null;
        if (entrySavedBool) {
          AutoRouter.of(context).root.pop(
            switch (widget.entryPageType) {
              EntryPageType.entryPageCreate => EntryCreateEditStatus.creationSuccessful,
              EntryPageType.entryPageEdit => EntryCreateEditStatus.modificationSuccessful,
            },
          );
        }
      },
    );
  }

  Future<void> _showGeneratePasswordPage() async {
    String? generatedPassword = await AutoRouter.of(context).push<String>(
      const PasswordGeneratorRoute(),
    );

    bool passwordApplicableBool = mounted && generatedPassword != null;
    if (passwordApplicableBool) {
      entryDetailsEditablePageCubit.updatePassword(generatedPassword);
    }
  }
}
