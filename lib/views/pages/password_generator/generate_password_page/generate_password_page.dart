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
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';
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
  final bool obscurePasswordBool;
  final PasswordCharacterSetMode characterSetMode;

  const GeneratePasswordPage({
    required this.characterSetMode,
    this.obscurePasswordBool = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GeneratePasswordPageState();
}

class _GeneratePasswordPageState extends State<GeneratePasswordPage> {
  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  final TextEditingController customPasswordLengthTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final FocusNode customPasswordLengthFocusNode = FocusNode();

  late final GeneratePasswordPageCubit generatePasswordPageCubit;

  @override
  void initState() {
    super.initState();
    generatePasswordPageCubit = GeneratePasswordPageCubit(
      characterSetMode: widget.characterSetMode,
      obscurePasswordBool: widget.obscurePasswordBool,
    );
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
        if (passwordTextEditingController.text != state.password) {
          passwordTextEditingController.text = state.password;
        }
        if (customPasswordLengthTextEditingController.text != state.customPasswordLength) {
          customPasswordLengthTextEditingController.text = state.customPasswordLength;
        }

        return CustomScaffold(
          title: 'GENERATE PASSWORD',
          resizeToAvoidBottomInsetBool: true,
          body: KeyboardVisibilityBuilder(
            keyboardValueNotifier: keyboardValueNotifier,
            builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
              bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;
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
                              if (state.characterSetMode == PasswordCharacterSetMode.advanced)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Password Characters',
                                    style: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                                  ),
                                ),
                              if (state.characterSetMode == PasswordCharacterSetMode.advanced)
                                Column(
                                  children: <Widget>[
                                    _buildCharacterCheckbox(
                                      title: 'Lowercase letters',
                                      selectedBool: state.advancedCharacterSettings?.lowercase ?? false,
                                      onTap: generatePasswordPageCubit.toggleLowercase,
                                    ),
                                    _buildCharacterCheckbox(
                                      title: 'Uppercase letters',
                                      selectedBool: state.advancedCharacterSettings?.uppercase ?? false,
                                      onTap: generatePasswordPageCubit.toggleUppercase,
                                    ),
                                    _buildCharacterCheckbox(
                                      title: 'Numbers',
                                      selectedBool: state.advancedCharacterSettings?.numbers ?? false,
                                      onTap: generatePasswordPageCubit.toggleNumbers,
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            _buildCharacterCheckbox(
                                              title: 'Special characters',
                                              selectedBool: state.advancedCharacterSettings?.special ?? false,
                                              onTap: generatePasswordPageCubit.toggleSpecial,
                                            ),
                                            _buildCharacterCheckbox(
                                              title: 'Remove ambiguous letters',
                                              selectedBool: state.removeAmbiguousBool,
                                              onTap: generatePasswordPageCubit.toggleRemoveAmbiguous,
                                            ),
                                          ],
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: _showAdvancedHintDialog,
                                                  child: const SizedBox(
                                                    width: 34,
                                                    height: 34,
                                                    child: AssetIcon(
                                                      AppIcons.icon_help,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (state.characterSettingsInvalidBool)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: ErrorMessageListTile(message: 'Select at least one character category'),
                                      ),
                                  ],
                                ),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Password Security and Length',
                                  style: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                                ),
                              ),
                              CustomSingleSelectMenu<PasswordLevelType>(
                                selectedValue: state.selectedPasswordLevelType,
                                options: state.passwordLevelTypeList,
                                onSelected: _handlePasswordLengthChanged,
                                itemBuilder: (BuildContext context, PasswordLevelType passwordLengthType) {
                                  bool customFieldBool = passwordLengthType == PasswordLevelType.custom;
                                  Color passwordColor = _getPasswordSecurityLevelColor(passwordLengthType);

                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        passwordLengthType.displayName,
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
                                          _getPasswordLengthDescription(state, passwordLengthType),
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
                              if (anyKeyboardVisibleBool == false) ...<Widget>[
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.5),
                                  child: SizedBox(
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
                                      if (state.characterSetMode == PasswordCharacterSetMode.sip2) ...<Widget>[
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

  Widget _buildCharacterCheckbox({required String title, required bool selectedBool, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            CustomCheckbox(selectedBool: selectedBool),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.body3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePasswordLengthChanged(PasswordLevelType passwordLengthType) {
    if (passwordLengthType == PasswordLevelType.custom) {
      generatePasswordPageCubit.selectCustomPasswordLevel();
      _requestCustomPasswordLengthFocus();
      return;
    }

    if (customPasswordLengthFocusNode.hasFocus) {
      _cancelCustomPasswordLengthFocus();
    }

    generatePasswordPageCubit.changePasswordLevelType(passwordLengthType);
  }

  void _handleCustomPasswordLengthFocusChanged() {
    if (customPasswordLengthFocusNode.hasFocus) {
      generatePasswordPageCubit.selectCustomPasswordLevel();
      return;
    }

    generatePasswordPageCubit.applyCustomPasswordLevel();
  }

  void _requestCustomPasswordLengthFocus() {
    customPasswordLengthFocusNode.requestFocus();
  }

  void _cancelCustomPasswordLengthFocus() {
    customPasswordLengthFocusNode.unfocus();
  }

  String _getPasswordLengthDescription(GeneratePasswordPageState state, PasswordLevelType passwordLengthType) {
    if (passwordLengthType == PasswordLevelType.custom) {
      return '(${GeneratePasswordPageCubit.minCustomPasswordLength} - ${GeneratePasswordPageCubit.maxCustomPasswordLength}) characters';
    }

    int? length = state.passwordLengthForLevel(passwordLengthType);
    return length == null ? 'N/A characters' : '$length characters';
  }

  Color _getPasswordSecurityLevelColor(PasswordLevelType passwordSecurityLevel) {
    switch (passwordSecurityLevel) {
      case PasswordLevelType.unsafe:
        return AppColors.warningRed;
      case PasswordLevelType.weak:
        return AppColors.warningOrange;
      case PasswordLevelType.excellent:
        return AppColors.excellent;
      case PasswordLevelType.magnificent:
        return AppColors.magnificent;
      case PasswordLevelType.good:
      //return AppColors.good;
      default:
        return AppColors.body3;
    }
  }

  Future<void> _initConfirm() async {
    if (generatePasswordPageCubit.state.passwordReadyBool == false) {
      return;
    }

    bool weakPasswordBool =
        generatePasswordPageCubit.state.calculatedPasswordLevelType == PasswordLevelType.unsafe ||
        generatePasswordPageCubit.state.calculatedPasswordLevelType == PasswordLevelType.weak;

    if (weakPasswordBool) {
      await _showWeakPasswordDialog();
    } else {
      _confirm();
    }
  }

  void _confirm() {
    if (generatePasswordPageCubit.state.passwordReadyBool == false) {
      return;
    }
    AutoRouter.of(context).pop<String>(generatePasswordPageCubit.state.password);
  }

  Future<void> _showPasswordSecurityHintDialog() async {
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

  Future<void> _showAsciiHintDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'ASCII Character Set\n',
        content: const Text(
          'This character set contains 94 non-whitespace ASCII characters:'
          '\n\nUppercase letters:\nABCDEFGHIJKLMNOPQRSTUVWXYZ'
          '\n\nLowercase letters:\nabcdefghijklmnopqrstuvwxyz'
          '\n\nDigits:\n0123456789'
          '\n\nSymbols:\n'
          r'''!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''',
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

  Future<void> _showCharacterSetHintDialog(PasswordCharacterSetMode characterSetMode) async {
    switch (characterSetMode) {
      case PasswordCharacterSetMode.ascii:
        await _showAsciiHintDialog();
      case PasswordCharacterSetMode.sip2:
        await _showSip2HintDialog();
      case PasswordCharacterSetMode.advanced:
        await _showAdvancedHintDialog();
    }
  }

  Future<void> _showAdvancedHintDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Special and ambiguous characters',
        content: const Text(
          'Full list of special characters:'
          '\n\n!"#\$%&\'()*+, -./:;<=>?@[\\]^_`{|}~'
          '\n\nRemoving ambiguous letters disables uppercase I and O, as well as lowercase l.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }

  Future<void> _showSip2HintDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Snggle Improvement Proposal - 2 Character Set',
        content: const Text(
          'This character set contains 64 characters:'
          '\n\nUppercase letters:\nABCDEFGHJKLMNPQRSTUVWXYZ'
          '\n - all uppercase characters excluding I and O'
          '\n\nLowercase letters:\nabcdefghijkmnopqrstuvwxyz'
          '\n - all lowercase characters excluding l'
          '\n\nDigits:\n0123456789'
          '\n - all digits, including 0 and 1'
          '\n\nSymbols:\n'
          '''!+-@=''',
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
        title: 'Insecure password',
        content: const Text(
          'This password may have insufficient security\n'
          'and be susceptible to brute-force attacks.\n'
          'Are you sure you want to use that password?',
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
