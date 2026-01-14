import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_create_edit_status.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage<EntryCreateEditStatus?>()
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
    TextTheme textTheme = Theme.of(context).textTheme;

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
              if (state.loadingBool) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: LoadingContainer(height: 30),
                );
              }

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
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Name',
                        textEditingController: entryDetailsEditablePageCubit.nameTextEditingController,
                      ),
                      if (state.entryNameEmptyBool == true)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ErrorMessageListTile(
                            message: 'Entry name cannot be empty',
                          ),
                        ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Website',
                        textEditingController: entryDetailsEditablePageCubit.websiteTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Email',
                        textEditingController: entryDetailsEditablePageCubit.emailTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Username',
                        textEditingController: entryDetailsEditablePageCubit.usernameTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
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

  Widget _buildEditableEntryField({
    required TextTheme textTheme,
    required String label,
    required TextEditingController textEditingController,
    bool readOnlyBool = false,
    bool autofocusBool = false,
    bool obscureTextBool = false,
    FocusNode? focusNode,
    Widget? suffixWidget,
    BoxConstraints? suffixWidgetConstraints,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LabelWrapperVertical.textField(
        label: label,
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
        labelPadding: EdgeInsets.zero,
        child: CustomTextField(
          autofocusBool: autofocusBool,
          readOnlyBool: readOnlyBool,
          focusNode: focusNode,
          textEditingController: textEditingController,
          inputBorder: InputBorder.none,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          obscureTextBool: obscureTextBool,
          suffixWidget: suffixWidget,
          suffixWidgetConstraints: suffixWidgetConstraints,
        ),
      ),
    );
  }

  bool get _finishButtonEnabledBool => entryDetailsEditablePageCubit.state.entryNameEmptyBool == false;

  Future<void> _save() async {
    await CustomLoadingDialog.show<EntryModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: entryDetailsEditablePageCubit.save,
      onSuccess: (EntryModel? entryModel) async {
        if (entryModel != null) {
          await AutoRouter.of(context).root.pop(
                switch (widget.entryPageType) {
                  EntryPageType.entryPageCreate => EntryCreateEditStatus.creationSuccessful,
                  EntryPageType.entryPageEdit => EntryCreateEditStatus.modificationSuccessful,
                },
              );
        }
      },
    );
  }
}
