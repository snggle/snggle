import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/native/autofill_save/autofill_save_context.dart';
import 'package:snggle/shared/native/autofill_save/native_autofill_save.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class AutofillSaveEntryPage extends StatefulWidget {
  const AutofillSaveEntryPage({
    super.key,
  });

  @override
  State<AutofillSaveEntryPage> createState() => _AutofillSaveEntryPageState();
}

class _AutofillSaveEntryPageState extends State<AutofillSaveEntryPage> {
  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();

  final EntryDetailsEditablePageCubit entryDetailsEditablePageCubit = EntryDetailsEditablePageCubit(
    parentFilesystemPath: FilesystemPath.fromString('entries'),
    entryModel: null,
    entryPageType: EntryPageType.entryPageCreate,
  );

  bool _obscurePasswordBool = true;

  @override
  void initState() {
    super.initState();
    _init();
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
      builder:
          (
            BuildContext context,
            EntryDetailsEditablePageState state,
          ) {
            return CustomScaffold(
              title: 'CREATE ENTRY',
              resizeToAvoidBottomInsetBool: true,
              popAvailableBool: false,
              customPopCallback: _showDiscardDialog,
              customSystemPopCallback: _showDiscardDialog,
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
                              onTap: () {
                                setState(() {
                                  _obscurePasswordBool = !_obscurePasswordBool;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: AssetIcon(
                                  _obscurePasswordBool ? AppIcons.details_hide : AppIcons.details_show,
                                ),
                              ),
                            ),
                            suffixWidgetConstraints: const BoxConstraints(
                              minWidth: 34,
                              minHeight: 34,
                            ),
                          ),
                          SizedBox(
                            height: anyKeyboardVisibleBool ? 40 : 100,
                          ),
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
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkGrey,
        ),
        labelPadding: EdgeInsets.zero,
        child: CustomTextField(
          autofocusBool: autofocusBool,
          readOnlyBool: readOnlyBool,
          focusNode: focusNode,
          enableInteractiveSelectionBool: true,
          textEditingController: textEditingController,
          inputBorder: InputBorder.none,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 5,
          ),
          obscureTextBool: obscureTextBool,
          suffixWidget: suffixWidget,
          suffixWidgetConstraints: suffixWidgetConstraints,
        ),
      ),
    );
  }

  Future<void> _init() async {
    try {
      await entryDetailsEditablePageCubit.init();

      AutofillSaveContext autofillContext = await NativeAutofillSave.getContext();

      String? entryName = autofillContext.appName;

      if (entryName != null) {
        entryDetailsEditablePageCubit.nameTextEditingController.text = entryName;
      }

      entryDetailsEditablePageCubit.emailTextEditingController.text = autofillContext.email ?? '';
      entryDetailsEditablePageCubit.usernameTextEditingController.text = autofillContext.username ?? '';
      entryDetailsEditablePageCubit.passwordTextEditingController.text = autofillContext.password ?? '';
    } catch (error, stackTrace) {
      debugPrint(
        'AUTOFILL CONTEXT ERROR: $error\n$stackTrace',
      );
    }
  }

  bool get _finishButtonEnabledBool {
    return entryDetailsEditablePageCubit.state.entryNameEmptyBool == false;
  }

  Future<void> _save() async {
    debugPrint('AUTOFILL SAVE START');

    try {
      debugPrint('AUTOFILL CUBIT SAVE BEFORE');

      EntryModel? entryModel = await entryDetailsEditablePageCubit.save();

      debugPrint(
        'AUTOFILL CUBIT SAVE AFTER: '
        '${entryModel?.filesystemPath}',
      );

      if (entryModel == null) {
        debugPrint('AUTOFILL SAVE RETURNED NULL');
        return;
      }

      await _showSuccessDialog();
    } catch (error, stackTrace) {
      debugPrint(
        'AUTOFILL SAVE ERROR: $error\n$stackTrace',
      );
    }
  }

  Future<void> _showDiscardDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomDialog(
        title: 'Discard the entry?',
        content: const Text(
          'You will be directed back\n'
          'to the external app.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          const CustomDialogOption(
            label: 'Discard',
            onPressed: NativeAutofillSave.finish,
          ),
        ],
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => const CustomDialog(
        title: 'Success',
        content: Text(
          'The entry creation process has been completed.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Done',
            onPressed: NativeAutofillSave.finish,
          ),
        ],
      ),
    );
  }
}
