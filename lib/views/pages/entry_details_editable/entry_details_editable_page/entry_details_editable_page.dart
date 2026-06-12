import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_create_edit_status.dart';
import 'package:snggle/views/pages/two_factor_options_page/two_factor_options_type.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
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
  final FocusNode totpSecretFocusNode = FocusNode();

  late bool _obscurePasswordBool;
  bool _obscureNewTotpSecretBool = true;
  bool _obscureTotpSecretBool = true;
  bool _readOnlyTotpBool = true;
  bool _settingNewTotpBool = false;

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
    totpSecretFocusNode.dispose();
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
          actions: _settingNewTotpBool
              ? <Widget>[
                  InkWell(
                    onTap: _showDiscardDialog,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: AssetIcon(AppIcons.app_bar_close),
                    ),
                  ),
                ]
              : null,
          customPopCallback: _handleBackPressed,
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
                    onTap: _finishButtonEnabledBool ? _initSave : null,
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
                      const SizedBox(height: 12),
                      if (state.totpExistsBool || _settingNewTotpBool) ...<Widget>[
                        Builder(
                          builder: (BuildContext context) {
                            bool obscureCurrentTotpSecretBool = _settingNewTotpBool ? _obscureNewTotpSecretBool : _obscureTotpSecretBool;

                            return _buildEditableEntryField(
                              textTheme: textTheme,
                              label: 'TOTP Secret Key',
                              textEditingController: entryDetailsEditablePageCubit.totpSecretTextEditingController,
                              readOnlyBool: _readOnlyTotpBool,
                              autofocusBool: _settingNewTotpBool,
                              obscureTextBool: obscureCurrentTotpSecretBool,
                              focusNode: totpSecretFocusNode,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[A-Za-z2-7=]'))],
                              suffixWidget: InkWell(
                                onTap: () => setState(() {
                                  if (_settingNewTotpBool) {
                                    _obscureNewTotpSecretBool = !_obscureNewTotpSecretBool;
                                  } else {
                                    _obscureTotpSecretBool = !_obscureTotpSecretBool;
                                  }
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: AssetIcon(
                                    obscureCurrentTotpSecretBool ? AppIcons.details_hide : AppIcons.details_show,
                                  ),
                                ),
                              ),
                              suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                            );
                          },
                        ),
                        if (state.totpInvalidBool == true)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ErrorMessageListTile(
                              message: 'Secret is invalid',
                            ),
                          ),
                        const SizedBox(height: 12),
                      ],
                      if (_settingNewTotpBool == false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                GradientOutlinedButton.small(
                                  width: 176,
                                  label: state.totpExistsBool == false ? 'Enable 2FA' : 'Overwrite 2FA',
                                  onPressed: _selectTwoFactorType,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _showTotpHintDialog,
                                      child: const SizedBox(
                                        width: 34,
                                        height: 34,
                                        child: AssetIcon(AppIcons.icon_help, size: 25),
                                      ),
                                    ),
                                  ),
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

  bool get _finishButtonEnabledBool =>
      entryDetailsEditablePageCubit.state.entryNameEmptyBool == false && entryDetailsEditablePageCubit.state.totpInvalidBool == false;

  Future<void> _initSave() async {
    if (entryDetailsEditablePageCubit.preexistingTotpBool == true &&
        entryDetailsEditablePageCubit.totpSecretTextEditingController.text.trim().isEmpty == true) {
      await _showDisableTotpDialog();
    } else {
      await _save();
    }
  }

  Future<void> _save() async {
    await CustomLoadingDialog.show<EntryModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: entryDetailsEditablePageCubit.save,
      onSuccess: (EntryModel? entryModel) async {
        if (entryModel != null) {
          entryDetailsEditablePageCubit.finishTotpEditingSession();
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
    List<TextInputFormatter>? inputFormatters,
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
          enableInteractiveSelectionBool: true,
          textEditingController: textEditingController,
          inputBorder: InputBorder.none,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          obscureTextBool: obscureTextBool,
          suffixWidget: suffixWidget,
          suffixWidgetConstraints: suffixWidgetConstraints,
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }

  Future<void> _selectTwoFactorType() async {
    FocusScope.of(context).unfocus();

    TwoFactorOptionsType? twoFactorOptionsType = await _showTwoFactorOptionsPage();

    if (twoFactorOptionsType == null) {
      entryDetailsEditablePageCubit.finishTotpEditingSession();
      return;
    }

    entryDetailsEditablePageCubit.startTotpEditingSession();

    switch (twoFactorOptionsType.manualSecretInputBool) {
      case true:
        setState(() => _readOnlyTotpBool = false);
        setState(() => _settingNewTotpBool = true);
        await _showTextTotpPage();
      case false:
        setState(() => _readOnlyTotpBool = true);
        setState(() => _settingNewTotpBool = true);
        entryDetailsEditablePageCubit.totpSecretTextEditingController.text = twoFactorOptionsType.totpSecret;
    }
  }

  Future<TwoFactorOptionsType?> _showTwoFactorOptionsPage() async {
    return AutoRouter.of(context).push<TwoFactorOptionsType?>(
      TwoFactorOptionsRoute(
        entryModel: widget.entryModel,
        parentFilesystemPath: widget.parentFilesystemPath,
      ),
    );
  }

  Future<void> _showTextTotpPage() async {
    setState(() => _settingNewTotpBool = true);
    entryDetailsEditablePageCubit.removeTotp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        totpSecretFocusNode.requestFocus();
      }
    });
  }

  Future<void> _showTotpHintDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: '2 Factor Authentication\n',
        content: const Text(
          '2FA is an electronic authentication method in which a user is granted access to a service only after successfully presenting '
          'at least two distinct types of evidence (or factors) to an authentication mechanism. It prevents a single point of failure '
          '(e.g. leaked password) from compromising personal data.\n\n'
          'Time-based One-Time Password (TOTP) 2FA can be enabled by providing the TOTP secret, either inserting it manually or in a form of a QR code. '
          'Setting a new secret will overwrite the already existing one. Manually inserting an empty secret will disable 2FA.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Close',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Future<void> _showDiscardDialog() async {
    switch (widget.entryPageType) {
      case EntryPageType.entryPageEdit:
        await showDialog(
          context: context,
          barrierColor: Colors.transparent,
          useRootNavigator: true,
          builder: (BuildContext context) => CustomDialog(
            title: 'Discard changes?',
            content: const Text(
              'You will lose all the changes made to this entry.',
              textAlign: TextAlign.center,
            ),
            options: <CustomDialogOption>[
              CustomDialogOption(
                label: 'Cancel',
                onPressed: () {},
              ),
              CustomDialogOption(
                label: 'Discard',
                onPressed: _navigateBack,
              ),
            ],
          ),
        );
      case EntryPageType.entryPageCreate:
        await showDialog(
          context: context,
          barrierColor: Colors.transparent,
          useRootNavigator: true,
          builder: (BuildContext context) => CustomDialog(
            title: 'Discard changes?',
            content: const Text(
              'You will lose all data in this entry.',
              textAlign: TextAlign.center,
            ),
            options: <CustomDialogOption>[
              CustomDialogOption(
                label: 'Cancel',
                onPressed: () {},
              ),
              CustomDialogOption(
                label: 'Discard',
                onPressed: _navigateBack,
              ),
            ],
          ),
        );
    }
  }

  Future<void> _showDiscardNewTwoFactorDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Discard new 2FA?',
        content: const Text(
          'You will lose the entered 2FA data in this entry and the 2FA will return to the previous state.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          CustomDialogOption(
            label: 'Discard',
            onPressed: _returnTo2faOptions,
          ),
        ],
      ),
    );
  }

  Future<void> _showDisableTotpDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Disabling 2FA',
        content: const Text(
          'Saving an empty secret will disable 2FA.\n'
          'You may lose access to the service.\n'
          'Are you sure you want to continue?',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          CustomDialogOption(
            label: 'Save',
            onPressed: _save,
          ),
        ],
      ),
    );
  }

  void _handleBackPressed() {
    if (_settingNewTotpBool && entryDetailsEditablePageCubit.totpSecretTextEditingController.text.trim().isEmpty) {
      _returnTo2faOptions();
    } else if (_settingNewTotpBool && entryDetailsEditablePageCubit.totpSecretTextEditingController.text.trim().isNotEmpty) {
      _showDiscardNewTwoFactorDialog();
    } else {
      _showDiscardDialog();
    }
  }

  void _returnTo2faOptions() {
    _selectTwoFactorType();
    entryDetailsEditablePageCubit.restorePreviousTotp();
    setState(() => _readOnlyTotpBool = true);
    setState(() => _settingNewTotpBool = false);
    setState(() => _obscureNewTotpSecretBool = true);
  }

  void _navigateBack() {
    AutoRouter.of(context).pop();
  }
}
