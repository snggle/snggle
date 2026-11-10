import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/utils/formatters/custom_password_length_input_formatter.dart';
import 'package:snggle/views/pages/password_generator/generate_password_page/password_character_checkbox.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_single_select_menu.dart';
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
class GeneratePasswordPage extends StatefulWidget {
  final PasswordCharacterSetMode passwordCharacterSetMode;
  final bool obscurePasswordBool;

  const GeneratePasswordPage({
    required this.passwordCharacterSetMode,
    this.obscurePasswordBool = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GeneratePasswordPageState();
}

class _GeneratePasswordPageState extends State<GeneratePasswordPage> {
  final FocusNode customPasswordLengthFocusNode = FocusNode();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  final ScrollController scrollController = ScrollController();
  final TextEditingController customPasswordLengthTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  late final GeneratePasswordPageCubit generatePasswordPageCubit;

  @override
  void initState() {
    super.initState();
    generatePasswordPageCubit = GeneratePasswordPageCubit(
      passwordCharacterSetMode: widget.passwordCharacterSetMode,
      obscurePasswordBool: widget.obscurePasswordBool,
    );
    customPasswordLengthFocusNode.addListener(_handleLengthFocus);
    generatePasswordPageCubit.init();
  }

  @override
  void dispose() {
    customPasswordLengthFocusNode.removeListener(_handleLengthFocus);
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
        bool passwordChangedBool = passwordTextEditingController.text != state.password;
        if (passwordChangedBool) {
          passwordTextEditingController.text = state.password;
        }
        bool customLengthChangedBool = customPasswordLengthTextEditingController.text != state.customPasswordLength;
        if (customLengthChangedBool) {
          customPasswordLengthTextEditingController.text = state.customPasswordLength;
        }

        bool advancedModeBool = state.passwordCharacterSetMode == PasswordCharacterSetMode.advanced;
        bool checksumModeBool = state.passwordCharacterSetMode == PasswordCharacterSetMode.sip2;
        return CustomScaffold(
          title: 'GENERATE PASSWORD',
          resizeToAvoidBottomInsetBool: true,
          body: KeyboardVisibilityBuilder(
            keyboardValueNotifier: keyboardValueNotifier,
            builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
              bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;
              bool keyboardHiddenBool = anyKeyboardVisibleBool == false;
              bool confirmButtonActiveBool = state.passwordReadyBool;

              return ScrollableLayout(
                scrollController: scrollController,
                bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
                tooltipVisibleBool: anyKeyboardVisibleBool == false,
                tooltipItems: <Widget>[
                  BottomTooltipItem(
                    label: 'Confirm',
                    assetIconData: AppIcons.menu_save,
                    onTap: confirmButtonActiveBool ? _initConfirm : null,
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
                              if (advancedModeBool) ...<Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Password Characters',
                                    style: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                                  ),
                                ),
                                PasswordCharacterCheckbox(
                                  title: 'Lowercase letters',
                                  selectedBool: state.advancedPasswordCharactersConfig.lowercase,
                                  onTapVoidCallback: generatePasswordPageCubit.toggleLowercase,
                                ),
                                PasswordCharacterCheckbox(
                                  title: 'Uppercase letters',
                                  selectedBool: state.advancedPasswordCharactersConfig.uppercase,
                                  onTapVoidCallback: generatePasswordPageCubit.toggleUppercase,
                                ),
                                PasswordCharacterCheckbox(
                                  title: 'Numbers',
                                  selectedBool: state.advancedPasswordCharactersConfig.numbers,
                                  onTapVoidCallback: generatePasswordPageCubit.toggleNumbers,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 44),
                                      child: PasswordCharacterCheckbox(
                                        title: 'Special characters',
                                        selectedBool: state.advancedPasswordCharactersConfig.special,
                                        onTapVoidCallback: generatePasswordPageCubit.toggleSpecial,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 10,
                                      child: Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _showCharactersHint,
                                            child: const SizedBox(
                                              width: 34,
                                              height: 34,
                                              child: AssetIcon(AppIcons.icon_help, size: 25),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                              ],
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Password Security and Length',
                                  style: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                                ),
                              ),
                              CustomSingleSelectMenu<PasswordLevelType>(
                                selectedValue: state.selectedPasswordLevelType,
                                options: state.selectablePasswordLevels,
                                onSelected: _handleLengthChanged,
                                itemBuilder: (BuildContext context, PasswordLevelType passwordLevelType) {
                                  bool customFieldBool = passwordLevelType == PasswordLevelType.custom;
                                  Color passwordColor = _getSecurityColor(passwordLevelType);

                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        passwordLevelType.displayName,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: passwordColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        child: Text(
                                          '\u2022',
                                          style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                                        ),
                                      ),
                                      if (customFieldBool) ...<Widget>[
                                        SizedBox(
                                          width: 44,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.6)),
                                            ),
                                            child: CustomTextField(
                                              readOnlyBool: false,
                                              textEditingController: customPasswordLengthTextEditingController,
                                              focusNode: customPasswordLengthFocusNode,
                                              inputBorder: InputBorder.none,
                                              inputFormatters: <TextInputFormatter>[
                                                CustomPasswordLengthInputFormatter(
                                                  maximumLength: GeneratePasswordPageState.maximumCustomPasswordLength,
                                                ),
                                              ],
                                              keyboardType: TextInputType.number,
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                              obscureTextBool: false,
                                              onChanged: generatePasswordPageCubit.updateCustomLength,
                                            ),
                                          ),
                                        ),
                                      ],
                                      Flexible(
                                        child: Text(
                                          _getLengthDescription(state, passwordLevelType),
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              AnimatedOpacity(
                                opacity: state.customPasswordLengthInvalidBool && state.selectedPasswordLevelType == PasswordLevelType.custom
                                    ? 1.0
                                    : 0.0,
                                duration: const Duration(milliseconds: 150),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: ErrorMessageListTile(
                                    message: 'Password length must be at least 4',
                                  ),
                                ),
                              ),
                              if (keyboardHiddenBool) ...<Widget>[
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      GradientOutlinedButton.small(
                                        width: 176,
                                        label: 'Re-roll',
                                        icon: const AssetIcon(AppIcons.dice),
                                        onPressed: confirmButtonActiveBool ? generatePasswordPageCubit.generatePassword : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
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
                                        confirmButtonActiveBool ? 'Entropy: ${state.passwordEntropy.toStringAsFixed(1)} bits' : 'Entropy: N/A',
                                        style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                      ),
                                      if (checksumModeBool) ...<Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            '\u2022',
                                            style: textTheme.bodySmall?.copyWith(color: AppColors.body3),
                                          ),
                                        ),
                                        Text(
                                          confirmButtonActiveBool ? 'Random: ${state.randomCharacterCount}' : 'Random: N/A',
                                          style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            '\u2022',
                                            style: textTheme.bodySmall?.copyWith(color: AppColors.body3),
                                          ),
                                        ),
                                        Text(
                                          confirmButtonActiveBool ? 'Checksum: ${state.checksumCharacterCount}' : 'Checksum: N/A',
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
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: _showSecurityHint,
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

  void _cancelLengthFocus() {
    customPasswordLengthFocusNode.unfocus();
  }

  void _confirm() {
    bool passwordUnavailableBool = generatePasswordPageCubit.state.passwordReadyBool == false;
    if (passwordUnavailableBool) {
      return;
    }
    AutoRouter.of(context).parent<StackRouter>()?.pop<String>(generatePasswordPageCubit.state.password);
  }

  String _getLengthDescription(GeneratePasswordPageState state, PasswordLevelType passwordLevelType) {
    bool customLevelBool = passwordLevelType == PasswordLevelType.custom;
    if (customLevelBool) {
      return '(${GeneratePasswordPageCubit.minimumCustomPasswordLength} - ${GeneratePasswordPageCubit.maximumCustomPasswordLength}) characters';
    }

    int? length = state.calculatePasswordLength(passwordLevelType);
    return length == null ? 'N/A characters' : '$length characters';
  }

  Color _getSecurityColor(PasswordLevelType passwordLevelType) {
    switch (passwordLevelType) {
      case PasswordLevelType.unsafe:
        return AppColors.warningRed;
      case PasswordLevelType.weak:
        return AppColors.warningOrange;
      case PasswordLevelType.excellent:
        return AppColors.excellent;
      case PasswordLevelType.magnificent:
        return AppColors.magnificent;
      case PasswordLevelType.good:
      default:
        return AppColors.body3;
    }
  }

  void _handleLengthChanged(PasswordLevelType passwordLevelType) {
    bool customLevelBool = passwordLevelType == PasswordLevelType.custom;
    if (customLevelBool) {
      generatePasswordPageCubit.selectCustomPasswordLevel();
      _requestLengthFocus();
      return;
    }

    bool customLengthFocusedBool = customPasswordLengthFocusNode.hasFocus;
    if (customLengthFocusedBool) {
      _cancelLengthFocus();
    }

    generatePasswordPageCubit.changePasswordLevelType(passwordLevelType);
  }

  void _handleLengthFocus() {
    bool customLengthFocusedBool = customPasswordLengthFocusNode.hasFocus;
    if (customLengthFocusedBool) {
      generatePasswordPageCubit.selectCustomPasswordLevel();
      return;
    }

    generatePasswordPageCubit.applyCustomPasswordLevel();
  }

  Future<void> _initConfirm() async {
    bool passwordUnavailableBool = generatePasswordPageCubit.state.passwordReadyBool == false;
    if (passwordUnavailableBool) {
      return;
    }

    bool weakPasswordBool = generatePasswordPageCubit.shouldWarnPassword();

    if (weakPasswordBool) {
      await _showWeakPasswordDialog();
    } else {
      _confirm();
    }
  }

  void _requestLengthFocus() {
    customPasswordLengthFocusNode.requestFocus();
  }

  Future<void> _showCharactersHint() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Special characters\n',
        content: const Text(
          'The following special characters may be included in a password:'
          '\n!"#\$%&\'()*+, -./:;<=>?@[\\]^_`{|}~',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }

  Future<void> _showSecurityHint() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Password security\n',
        content: const Text(
          'Password entropy is used to estimate password strength. The higher the entropy, the more difficult it is to guess a password through brute-force attacks.'
          '\n\nWe recognize the following levels of password security:'
          '\nUnsafe: below 80 security bits'
          '\nWeak: 80-112 security bits'
          '\nGood: 112-128 security bits'
          '\nExcellent: 128-256 security bits'
          '\nMagnificent: 256+ security bits'
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

  Future<void> _showWeakPasswordDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Insecure password\n',
        content: const Text(
          'This password may have insufficient security\n'
          'and be susceptible to brute-force attacks.\n'
          'Are you sure you want to use this password?',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          CustomDialogOption(
            label: 'Confirm',
            onPressed: _confirm,
          ),
        ],
      ),
    );
  }
}
