import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' show CharacterSetType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_length_type.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_security_level.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/formatters/custom_password_length_input_formatter.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_single_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class GeneratePasswordPage extends StatefulWidget {
  final FilesystemPath? parentFilesystemPath;
  final bool? obscurePasswordBool;

  const GeneratePasswordPage({
    this.parentFilesystemPath,
    this.obscurePasswordBool = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GeneratePasswordPageState();
}

class _GeneratePasswordPageState extends State<GeneratePasswordPage> {
  static const List<CharacterSetType> _characterSetOptions = <CharacterSetType>[
    CharacterSetType.ascii,
    CharacterSetType.sip2,
  ];

  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  final TextEditingController customPasswordLengthTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final FocusNode customPasswordLengthFocusNode = FocusNode();

  late final GeneratePasswordPageCubit generatePasswordPageCubit;

  @override
  void initState() {
    super.initState();
    generatePasswordPageCubit = GeneratePasswordPageCubit(obscurePasswordBool: widget.obscurePasswordBool ?? true);
    customPasswordLengthFocusNode.addListener(_handleCustomPasswordLengthFocusChanged);
    generatePasswordPageCubit.init();
  }

  @override
  void dispose() {
    customPasswordLengthFocusNode.removeListener(_handleCustomPasswordLengthFocusChanged);
    scrollController.dispose();
    keyboardValueNotifier.dispose();
    customPasswordLengthTextEditingController.dispose();
    passwordTextEditingController.dispose();
    customPasswordLengthFocusNode.dispose();
    generatePasswordPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<GeneratePasswordPageCubit, GeneratePasswordPageState>(
      bloc: generatePasswordPageCubit,
      builder: (BuildContext context, GeneratePasswordPageState state) {
        _syncControllerText(passwordTextEditingController, state.password);
        _syncControllerText(customPasswordLengthTextEditingController, state.customPasswordLengthText);

        return CustomScaffold(
          title: 'GENERATE PASSWORD',
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
                    label: 'Confirm',
                    assetIconData: AppIcons.menu_save,
                    onTap: _save,
                  ),
                ],
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Character Set',
                                  style: textTheme.bodyLarge?.copyWith(color: AppColors.darkGrey),
                                ),
                              ),
                              CustomSingleSelectMenu<CharacterSetType>(
                                selectedValue: state.characterSetType,
                                options: _characterSetOptions,
                                onSelected: _handleCharacterSetChanged,
                                itemBuilder: (BuildContext context, CharacterSetType passwordCharacterSetType) {
                                  return Text(
                                    _getPasswordCharacterSetTitle(passwordCharacterSetType),
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Password Security and Length',
                                  style: textTheme.bodyLarge?.copyWith(color: AppColors.darkGrey),
                                ),
                              ),
                              CustomSingleSelectMenu<PasswordLengthType>(
                                selectedValue: state.passwordLengthType,
                                options: state.passwordLengthOptions,
                                onSelected: _handlePasswordLengthChanged,
                                itemBuilder: (BuildContext context, PasswordLengthType passwordLengthType) {
                                  bool customLengthBool = passwordLengthType == PasswordLengthType.custom;
                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        passwordLengthType.displayName,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyMedium?.copyWith(color: _getPasswordLengthColor(passwordLengthType)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        child: Text(
                                          '\u2022',
                                          style: textTheme.bodyMedium?.copyWith(color: AppColors.warningOrange),
                                        ),
                                      ),
                                      if (customLengthBool) ...<Widget>[
                                        SizedBox(
                                          width: 44,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.6)),
                                            ),
                                            child: CustomTextField(
                                              readOnlyBool: false,
                                              enableInteractiveSelectionBool: true,
                                              textEditingController: customPasswordLengthTextEditingController,
                                              focusNode: customPasswordLengthFocusNode,
                                              inputBorder: InputBorder.none,
                                              inputFormatters: <TextInputFormatter>[CustomPasswordLengthInputFormatter()],
                                              keyboardType: TextInputType.number,
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                              obscureTextBool: false,
                                              onChanged: generatePasswordPageCubit.updateCustomPasswordLengthText,
                                            ),
                                          ),
                                        ),
                                      ],
                                      Flexible(
                                        child: Text(
                                          _getPasswordLengthDescription(passwordLengthType),
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              if (anyKeyboardVisibleBool == false) ...<Widget>[
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        GradientOutlinedButton.small(
                                          width: 176,
                                          label: 'Regenerate',
                                          onPressed: _regenerate,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: LabelWrapperVertical.textField(
                                    label: 'Password',
                                    labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                                    labelPadding: EdgeInsets.zero,
                                    child: CustomTextField(
                                      readOnlyBool: true,
                                      enableInteractiveSelectionBool: true,
                                      textEditingController: passwordTextEditingController,
                                      inputBorder: InputBorder.none,
                                      keyboardType: TextInputType.text,
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                      obscureTextBool: state.obscurePasswordBool,
                                      suffixWidget: InkWell(
                                        onTap: generatePasswordPageCubit.toggleObscurePassword,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: AssetIcon(
                                            state.obscurePasswordBool ? AppIcons.details_hide : AppIcons.details_show,
                                          ),
                                        ),
                                      ),
                                      suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Entropy: ${state.passwordEntropy.toStringAsFixed(1)} bits',
                                        style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          '\u2022',
                                          style: textTheme.bodySmall?.copyWith(color: AppColors.warningOrange),
                                        ),
                                      ),
                                      Text(
                                        'Length: ${state.passwordLength}',
                                        style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                      ),
                                      if (state.characterSetType == CharacterSetType.sip2) ...<Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            '\u2022',
                                            style: textTheme.bodySmall?.copyWith(color: AppColors.warningOrange),
                                          ),
                                        ),
                                        Text(
                                          'Checksum: ${state.checksumCharacterCount}',
                                          style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Material(
                                                color: Colors.transparent,
                                                child:
                                                    state.passwordSecurityLevel == PasswordSecurityLevel.unsafe || state.passwordSecurityLevel == PasswordSecurityLevel.weak
                                                    ? Icon(
                                                        Icons.warning_amber_rounded,
                                                        size: 20,
                                                        color: _getPasswordSecurityLevelColor(state.passwordSecurityLevel),
                                                      )
                                                    : AssetIcon(
                                                        AppIcons.menu_save,
                                                        size: 20,
                                                        color: _getPasswordSecurityLevelColor(state.passwordSecurityLevel),
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${state.passwordSecurityLevel.displayName} password',
                                                style: textTheme.bodyMedium?.copyWith(color: _getPasswordSecurityLevelColor(state.passwordSecurityLevel)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: _showPasswordSecurityHintDialog,
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
                              ],
                              SizedBox(height: anyKeyboardVisibleBool ? 40 : 100),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleCharacterSetChanged(CharacterSetType passwordCharacterSetType) {
    generatePasswordPageCubit.changeCharacterSet(passwordCharacterSetType);
  }

  void _handlePasswordLengthChanged(PasswordLengthType passwordLengthType) {
    generatePasswordPageCubit.changePasswordLengthType(passwordLengthType);

    if (passwordLengthType == PasswordLengthType.custom) {
      _requestCustomPasswordLengthFocus();
    }
  }

  void _handleCustomPasswordLengthFocusChanged() {
    GeneratePasswordPageState state = generatePasswordPageCubit.state;

    if (customPasswordLengthTextEditingController.text.isEmpty) {
      if (state.passwordLengthType == PasswordLengthType.custom) {
        generatePasswordPageCubit.changePasswordLengthType(state.characterSetType == CharacterSetType.sip2 ? PasswordLengthType.good : PasswordLengthType.excellent);
      }
      return;
    }

    if (customPasswordLengthFocusNode.hasFocus) {
      generatePasswordPageCubit.changePasswordLengthType(PasswordLengthType.custom);
      return;
    }

    if (customPasswordLengthTextEditingController.value.text == state.passwordLength.toString()) {
      return;
    }

    generatePasswordPageCubit
      ..changePasswordLengthType(PasswordLengthType.custom)
      ..generatePassword();
  }

  void _requestCustomPasswordLengthFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        customPasswordLengthFocusNode.requestFocus();
      }
    });
  }

  String _getPasswordCharacterSetTitle(CharacterSetType passwordCharacterSetType) {
    switch (passwordCharacterSetType) {
      case CharacterSetType.ascii:
        return 'Non-whitespace ASCII';
      case CharacterSetType.sip2:
        return 'SNGGLE (SIP-2)';
    }
  }

  Color _getPasswordLengthColor(PasswordLengthType passwordLengthType) {
    switch (passwordLengthType) {
      case PasswordLengthType.good:
        return AppColors.body3;
      case PasswordLengthType.excellent:
        return AppColors.darkGreen;
      case PasswordLengthType.superb:
        return AppColors.lightGreen;
      case PasswordLengthType.custom:
        return AppColors.body3;
    }
  }

  String _getPasswordLengthDescription(PasswordLengthType passwordLengthType) {
    if (passwordLengthType == PasswordLengthType.custom) {
      return ' characters';
    }

    return '${passwordLengthType.defaultLength} characters';
  }

  Color _getPasswordSecurityLevelColor(PasswordSecurityLevel passwordSecurityLevel) {
    switch (passwordSecurityLevel) {
      case PasswordSecurityLevel.unsafe:
        return AppColors.warningRed;
      case PasswordSecurityLevel.weak:
        return AppColors.warningOrange;
      case PasswordSecurityLevel.good:
        return AppColors.darkGrey;
      case PasswordSecurityLevel.excellent:
        return AppColors.darkGreen;
      case PasswordSecurityLevel.superb:
        return AppColors.lightGreen;
    }
  }

  void _regenerate() {
    generatePasswordPageCubit.generatePassword();
  }

  void _save() {
    AutoRouter.of(context).pop<String>(generatePasswordPageCubit.state.password);
  }

  void _syncControllerText(TextEditingController textEditingController, String text) {
    if (textEditingController.text == text) {
      return;
    }

    textEditingController.text = text;
  }

  Future<void> _showPasswordSecurityHintDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Password security\n',
        content: const Text(
          'Password entropy is used to estimate password strength . The higher the entropy, the more difficult it is to guess a password through brute-force attacks.'
          '\n\nWe recognize the following levels of password security:'
          '\nUnsafe: below 80 security bits'
          '\nWeak: 80-112 security bits'
          '\nGood: 112-128 security bits'
          '\nExcellent: 128-256 security bits'
          '\nSuperb: 256+ security bits'
          '\n\nSIP-2 Character Set lowers the risk of transcription errors and ensures the password remains safe with at least 112 bits of entropy within the total length of 20 characters, including checksum.',
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
}
