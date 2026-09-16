import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/generate_password_page/password_character_set_type.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/generate_password_page/password_length_type.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/generate_password_page/password_security_level.dart';
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
  static const List<PasswordCharacterSetType> _characterSetOptions = <PasswordCharacterSetType>[
    PasswordCharacterSetType.ascii,
    PasswordCharacterSetType.sip2,
  ];
  static const List<PasswordLengthType> _passwordLengthOptions = <PasswordLengthType>[
    PasswordLengthType.good,
    PasswordLengthType.excellent,
    PasswordLengthType.superb,
    PasswordLengthType.custom,
  ];
  static const List<PasswordLengthType> _sip2PasswordLengthOptions = <PasswordLengthType>[
    PasswordLengthType.good,
    PasswordLengthType.custom,
  ];

  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  final ValueNotifier<PasswordCharacterSetType> characterSetNotifier = ValueNotifier<PasswordCharacterSetType>(_characterSetOptions.first);
  final ValueNotifier<PasswordLengthType> passwordLengthNotifier = ValueNotifier<PasswordLengthType>(PasswordLengthType.excellent);
  final FocusNode customPasswordLengthFocusNode = FocusNode();

  late bool _obscurePasswordBool;
  late PasswordLengthType _currentLength;

  late final GeneratePasswordPageCubit generatePasswordPageCubit = GeneratePasswordPageCubit();

  @override
  void initState() {
    super.initState();
    _obscurePasswordBool = widget.obscurePasswordBool ?? true;
    generatePasswordPageCubit.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    keyboardValueNotifier.dispose();
    characterSetNotifier.dispose();
    passwordLengthNotifier.dispose();
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
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Character Set',
                                style: textTheme.bodyLarge?.copyWith(color: AppColors.darkGrey),
                              ),
                            ),
                            ValueListenableBuilder<PasswordCharacterSetType>(
                              valueListenable: characterSetNotifier,
                              builder: (BuildContext context, PasswordCharacterSetType selectedCharacterSetType, _) {
                                return CustomSingleSelectMenu<PasswordCharacterSetType>(
                                  selectedValue: selectedCharacterSetType,
                                  options: _characterSetOptions,
                                  onSelected: _handleCharacterSetChanged,
                                  itemBuilder: (BuildContext context, PasswordCharacterSetType passwordCharacterSetType) {
                                    return Text(
                                      _getPasswordCharacterSetTitle(passwordCharacterSetType),
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                                    );
                                  },
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
                            ValueListenableBuilder<PasswordCharacterSetType>(
                              valueListenable: characterSetNotifier,
                              builder: (BuildContext context, PasswordCharacterSetType selectedCharacterSetType, _) {
                                return ValueListenableBuilder<PasswordLengthType>(
                                  valueListenable: passwordLengthNotifier,
                                  builder: (BuildContext context, PasswordLengthType selectedPasswordLengthType, _) {
                                    return CustomSingleSelectMenu<PasswordLengthType>(
                                      selectedValue: selectedPasswordLengthType,
                                      options: _getPasswordLengthOptions(selectedCharacterSetType),
                                      onSelected: _handlePasswordLengthChanged,
                                      itemBuilder: (BuildContext context, PasswordLengthType passwordLengthType) {
                                        bool customLengthBool = passwordLengthType == PasswordLengthType.custom;
                                        return Row(
                                          children: <Widget>[
                                            Text(
                                              _getPasswordLengthTitle(passwordLengthType),
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyMedium?.copyWith(color: _getPasswordLengthColor(passwordLengthType)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 22),
                                              child: Text(
                                                '•',
                                                style: textTheme.bodyMedium?.copyWith(color: AppColors.warningOrange),
                                              ),
                                            ),
                                            if (customLengthBool) ...<Widget>[
                                              SizedBox(
                                                width: 44,
                                                child: CustomTextField(
                                                  readOnlyBool: false,
                                                  enableInteractiveSelectionBool: true,
                                                  textEditingController: generatePasswordPageCubit.customPasswordLengthTextEditingController,
                                                  focusNode: customPasswordLengthFocusNode,
                                                  inputBorder: InputBorder.none,
                                                  keyboardType: TextInputType.number,
                                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                                  obscureTextBool: false,
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
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            const SizedBox(height: 24),
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
                                  textEditingController: generatePasswordPageCubit.passwordTextEditingController,
                                  inputBorder: InputBorder.none,
                                  keyboardType: TextInputType.text,
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                              ),
                            ),
                            ValueListenableBuilder<PasswordCharacterSetType>(
                              valueListenable: characterSetNotifier,
                              builder: (BuildContext context, PasswordCharacterSetType selectedCharacterSetType, _) {
                                return ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: generatePasswordPageCubit.entropyTextEditingController,
                                  builder: (BuildContext context, TextEditingValue entropyValue, _) {
                                    return ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: generatePasswordPageCubit.passwordLengthTextEditingController,
                                      builder: (BuildContext context, TextEditingValue lengthValue, _) {
                                        return ValueListenableBuilder<TextEditingValue>(
                                          valueListenable: generatePasswordPageCubit.checksumTextEditingController,
                                          builder: (BuildContext context, TextEditingValue checksumValue, _) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Entropy: ${entropyValue.text} bits',
                                                    style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: Text(
                                                      '•',
                                                      style: textTheme.bodySmall?.copyWith(color: AppColors.warningOrange),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Length: ${lengthValue.text}',
                                                    style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                                  ),
                                                  if (selectedCharacterSetType == PasswordCharacterSetType.sip2) ...<Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                                      child: Text(
                                                        '•',
                                                        style: textTheme.bodySmall?.copyWith(color: AppColors.warningOrange),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Checksum: ${checksumValue.text}',
                                                      style: textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
                              child: SizedBox(
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${state.passwordSecurityLevel.displayName} password',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: switch (state.passwordSecurityLevel) {
                                            PasswordSecurityLevel.unsafe => AppColors.warningRed,
                                            PasswordSecurityLevel.weak => AppColors.warningOrange,
                                            PasswordSecurityLevel.good => AppColors.darkGrey,
                                            PasswordSecurityLevel.excellent => AppColors.darkGreen,
                                            PasswordSecurityLevel.superb => AppColors.lightGreen,
                                          },
                                        ),
                                      ),
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
                            SizedBox(height: anyKeyboardVisibleBool ? 40 : 100),
                          ],
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

  void _save() {
    AutoRouter.of(context).pop<String>(generatePasswordPageCubit.passwordTextEditingController.text);
  }

  String _getPasswordCharacterSetTitle(PasswordCharacterSetType passwordCharacterSetType) {
    switch (passwordCharacterSetType) {
      case PasswordCharacterSetType.ascii:
        return 'Non-whitespace ASCII';
      case PasswordCharacterSetType.sip2:
        return 'SNGGLE (SIP-2)';
    }
  }

  String _getPasswordLengthTitle(PasswordLengthType passwordLengthType) {
    switch (passwordLengthType) {
      case PasswordLengthType.good:
        return 'Good';
      case PasswordLengthType.excellent:
        return 'Excellent';
      case PasswordLengthType.superb:
        return 'Superb';
      case PasswordLengthType.custom:
        return 'Custom';
    }
  }

  void _handleCharacterSetChanged(PasswordCharacterSetType passwordCharacterSetType) {
    if (generatePasswordPageCubit.passwordCharacterSetType == passwordCharacterSetType) {
      return;
    }

    PasswordLengthType selectedPasswordLengthType = passwordLengthNotifier.value;
    if (_passwordLengthSupported(passwordCharacterSetType, selectedPasswordLengthType) == false) {
      selectedPasswordLengthType = PasswordLengthType.good;
    }

    setState(() {
      characterSetNotifier.value = passwordCharacterSetType;
      generatePasswordPageCubit.passwordCharacterSetType = passwordCharacterSetType;
      passwordLengthNotifier.value = selectedPasswordLengthType;
      generatePasswordPageCubit.passwordLengthType = selectedPasswordLengthType;
    });

    print('Suchar: Char Set changed');
    _regenerate();
  }

  void _handlePasswordLengthChanged(PasswordLengthType passwordLengthType) {
    if (generatePasswordPageCubit.passwordLengthType == passwordLengthType) {
      return;
    }

    setState(() {
      passwordLengthNotifier.value = passwordLengthType;
      generatePasswordPageCubit.passwordLengthType = passwordLengthType;
    });

    if (passwordLengthType == PasswordLengthType.custom) {
      _requestCustomPasswordLengthFocus();
      return;
    }

    print('Suchar: Length changed');
    _regenerate();
  }

  List<PasswordLengthType> _getPasswordLengthOptions(PasswordCharacterSetType passwordCharacterSetType) {
    switch (passwordCharacterSetType) {
      case PasswordCharacterSetType.ascii:
        return _passwordLengthOptions;
      case PasswordCharacterSetType.sip2:
        return _sip2PasswordLengthOptions;
    }
  }

  bool _passwordLengthSupported(PasswordCharacterSetType passwordCharacterSetType, PasswordLengthType passwordLengthType) {
    return _getPasswordLengthOptions(passwordCharacterSetType).contains(passwordLengthType);
  }

  void _requestCustomPasswordLengthFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        customPasswordLengthFocusNode.requestFocus();
      }
    });
  }

  String _getPasswordLengthDescription(PasswordLengthType passwordLengthType) {
    switch (passwordLengthType) {
      case PasswordLengthType.good:
        return '18 characters';
      case PasswordLengthType.excellent:
        return '20 characters';
      case PasswordLengthType.superb:
        return '40 characters';
      case PasswordLengthType.custom:
        return 'characters';
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

  void _regenerate() {
    if (_currentLength == PasswordLengthType.custom && ) {

    }
    generatePasswordPageCubit.generatePassword();
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
