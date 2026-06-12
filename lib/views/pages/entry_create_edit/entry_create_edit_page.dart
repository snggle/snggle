import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_create_edit/entry_create_edit_page/entry_create_edit_page_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/entry_create_edit/entry_page_type.dart';
import 'package:snggle/views/pages/two_factor_options_page/two_factor_options_type.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
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
  final FocusNode totpSecretFocusNode = FocusNode();

  late bool _obscurePasswordBool;
  bool _obscureNewTotpSecretBool = true;
  bool _obscureTotpSecretBool = true;
  bool _readOnlyTotpBool = true;
  bool _settingNewTotpBool = false;

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
    totpSecretFocusNode.dispose();
    entryCreateEditPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryCreateEditPageCubit, EntryCreateEditPageState>(
      bloc: entryCreateEditPageCubit,
      builder: (BuildContext context, EntryCreateEditPageState state) {
        bool totpFieldVisibleBool = state.totpExistsBool || _settingNewTotpBool;
        bool obscureCurrentTotpSecretBool = _settingNewTotpBool ? _obscureNewTotpSecretBool : _obscureTotpSecretBool;
        bool totpOptionsVisibleBool = state.loadingBool == false && _settingNewTotpBool == false;

        return CustomScaffold(
          title: switch (widget.entryPageType) {
            EntryPageType.create => 'CREATE ENTRY',
            EntryPageType.edit => 'EDIT ENTRY',
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
          popAvailableBool: false,
          customSystemPopCallback: _handleBackPressed,
          customPopCallback: _handleBackPressed,
          resizeToAvoidBottomInsetBool: true,
          body: KeyboardVisibilityBuilder(
            keyboardValueNotifier: keyboardValueNotifier,
            builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
              bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;
              bool finishButtonEnabledBool = state.entryNameEmptyBool == false && state.emailInvalidBool == false && state.totpInvalidBool == false;

              return ScrollableLayout(
                scrollController: scrollController,
                bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
                tooltipVisibleBool: anyKeyboardVisibleBool == false,
                tooltipItems: <Widget>[
                  BottomTooltipItem(
                    label: 'Save',
                    assetIconData: AppIcons.menu_save,
                    onTap: finishButtonEnabledBool ? _saveOrShowDialog : null,
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
                        emailInvalidBool: state.emailInvalidBool,
                        usernameTextEditingController: entryCreateEditPageCubit.usernameTextEditingController,
                        passwordTextEditingController: entryCreateEditPageCubit.passwordTextEditingController,
                        readOnlyBool: false,
                        entryNameEmptyBool: state.entryNameEmptyBool,
                        obscurePasswordBool: _obscurePasswordBool,
                        onTogglePasswordVisibility: () => setState(() => _obscurePasswordBool = _obscurePasswordBool == false),
                      ),
                      if (totpFieldVisibleBool) ...<Widget>[
                        const SizedBox(height: 12),
                        EntryFormField(
                          label: 'TOTP Secret Key',
                          textEditingController: entryCreateEditPageCubit.totpSecretTextEditingController,
                          readOnlyBool: _readOnlyTotpBool,
                          autofocusBool: _readOnlyTotpBool == false,
                          focusNode: totpSecretFocusNode,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[A-Za-z2-7=]'))],
                          obscureTextBool: obscureCurrentTotpSecretBool,
                          obscureClipboardContentBool: true,
                          suffixWidget: InkWell(
                            onTap: _toggleTotpVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: AssetIcon(obscureCurrentTotpSecretBool ? AppIcons.details_hide : AppIcons.details_show),
                            ),
                          ),
                          suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                        ),
                        if (state.totpInvalidBool)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ErrorMessageListTile(message: 'Secret is invalid'),
                          ),
                        const SizedBox(height: 12),
                      ],
                      if (totpOptionsVisibleBool)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                GradientOutlinedButton.small(
                                  width: 176,
                                  label: state.totpExistsBool ? 'Overwrite 2FA' : 'Enable 2FA',
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

  void _handleBackPressed() {
    if (_settingNewTotpBool == false) {
      _showDiscardDialog();
      return;
    }

    bool emptySecretBool = entryCreateEditPageCubit.totpSecretTextEditingController.text.trim().isEmpty;
    if (emptySecretBool) {
      _returnToTwoFactorOptions();
    } else {
      _showDiscardNewTotpDialog();
    }
  }

  void _saveOrShowDialog() {
    if (entryCreateEditPageCubit.shouldConfirmTotpRemoval()) {
      _showDisableTotpDialog();
    } else {
      _save();
    }
  }

  Future<void> _returnToTwoFactorOptions() async {
    entryCreateEditPageCubit
      ..restorePreviousTotp()
      ..finishTotpEditingSession();

    setState(() {
      _readOnlyTotpBool = true;
      _settingNewTotpBool = false;
      _obscureNewTotpSecretBool = true;
    });

    await _selectTwoFactorType();
  }

  void _save() {
    CustomLoadingDialog.show<EntryModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: entryCreateEditPageCubit.save,
      onSuccess: (EntryModel? entryModel) {
        bool savedEntryAvailableBool = entryModel != null && mounted;
        if (savedEntryAvailableBool) {
          entryCreateEditPageCubit.finishTotpEditingSession();
          AutoRouter.of(context).root.pop<bool>(true);
        }
      },
    );
  }

  Future<void> _selectTwoFactorType() async {
    FocusScope.of(context).unfocus();

    TwoFactorOptionsType? twoFactorOptionsType = await AutoRouter.of(context).push<TwoFactorOptionsType>(
      TwoFactorOptionsRoute(entryModel: widget.entryModel, parentFilesystemPath: widget.parentFilesystemPath),
    );

    bool optionsUnavailableBool = twoFactorOptionsType == null || mounted == false;
    if (optionsUnavailableBool) {
      return;
    }

    entryCreateEditPageCubit.startTotpEditingSession();
    bool manualSecretInputBool = twoFactorOptionsType.manualSecretInputBool;
    if (manualSecretInputBool) {
      entryCreateEditPageCubit.removeTotp();
    } else {
      entryCreateEditPageCubit.totpSecretTextEditingController.text = twoFactorOptionsType.totpSecret;
    }

    setState(() {
      _readOnlyTotpBool = manualSecretInputBool == false;
      _settingNewTotpBool = true;
    });

    if (manualSecretInputBool) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          totpSecretFocusNode.requestFocus();
        }
      });
    }
  }

  void _showDisableTotpDialog() {
    showDialog<void>(
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
          CustomDialogOption(label: 'Cancel', onPressed: () {}),
          CustomDialogOption(label: 'Save', onPressed: _save),
        ],
      ),
    );
  }

  void _showDiscardDialog() {
    String discardTitle = switch (widget.entryPageType) {
      EntryPageType.edit => 'Discard changes?',
      EntryPageType.create => 'Discard new entry?',
    };

    String discardMessage = switch (widget.entryPageType) {
      EntryPageType.edit => 'You will lose all changes made to this entry.',
      EntryPageType.create => 'You will lose all data in this entry.',
    };

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: discardTitle,
        content: Text(
          discardMessage,
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          CustomDialogOption(
            label: 'Discard',
            onPressed: () => AutoRouter.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDiscardNewTotpDialog() {
    showDialog<void>(
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
          CustomDialogOption(label: 'Cancel', onPressed: () {}),
          CustomDialogOption(label: 'Discard', onPressed: _returnToTwoFactorOptions),
        ],
      ),
    );
  }

  void _showTotpHintDialog() {
    showDialog<void>(
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
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }

  void _toggleTotpVisibility() {
    setState(() {
      if (_settingNewTotpBool) {
        _obscureNewTotpSecretBool = _obscureNewTotpSecretBool == false;
      } else {
        _obscureTotpSecretBool = _obscureTotpSecretBool == false;
      }
    });
  }
}
