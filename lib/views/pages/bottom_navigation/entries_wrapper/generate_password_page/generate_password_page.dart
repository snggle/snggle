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
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_single_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
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

  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  final ValueNotifier<PasswordCharacterSetType> characterSetNotifier = ValueNotifier<PasswordCharacterSetType>(_characterSetOptions.first);
  final ValueNotifier<PasswordLengthType> passwordLengthNotifier = ValueNotifier<PasswordLengthType>(PasswordLengthType.excellent);

  late bool _obscurePasswordBool;

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
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
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
                      ValueListenableBuilder<PasswordLengthType>(
                        valueListenable: passwordLengthNotifier,
                        builder: (BuildContext context, PasswordLengthType selectedPasswordLengthType, _) {
                          return CustomSingleSelectMenu<PasswordLengthType>(
                            selectedValue: selectedPasswordLengthType,
                            options: _passwordLengthOptions,
                            onSelected: _handlePasswordLengthChanged,
                            itemBuilder: (BuildContext context, PasswordLengthType passwordLengthType) {
                              return Text(
                                _getPasswordLengthTitle(passwordLengthType),
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Length',
                        textEditingController: generatePasswordPageCubit.passwordLengthTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Entropy',
                        textEditingController: generatePasswordPageCubit.entropyTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Checksum',
                        textEditingController: generatePasswordPageCubit.checksumTextEditingController,
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              GradientOutlinedButton.small(
                                width: 176,
                                label: 'Generate pass',
                                onPressed: _regenerate,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildEditableEntryField(
                        textTheme: textTheme,
                        label: 'Password',
                        textEditingController: generatePasswordPageCubit.passwordTextEditingController,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: LabelWrapperVertical.textField(
                          label: 'Entropy: ${generatePasswordPageCubit.entropyTextEditingController.text} bits',
                          labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                          labelPadding: EdgeInsets.zero,
                          child: CustomTextField(
                            autofocusBool: false,
                            readOnlyBool: true,
                            enableInteractiveSelectionBool: true,
                            textEditingController: generatePasswordPageCubit.entropyTextEditingController,
                            inputBorder: InputBorder.none,
                            keyboardType: TextInputType.text,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 5,
                            ),
                            obscureTextBool: false,
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
          enableInteractiveSelectionBool: true,
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

    setState(() {
      characterSetNotifier.value = passwordCharacterSetType;
      generatePasswordPageCubit.passwordCharacterSetType = passwordCharacterSetType;
    });
  }

  void _handlePasswordLengthChanged(PasswordLengthType passwordLengthType) {
    if (generatePasswordPageCubit.passwordLengthType == passwordLengthType) {
      return;
    }

    setState(() {
      passwordLengthNotifier.value = passwordLengthType;
      generatePasswordPageCubit.passwordLengthType = passwordLengthType;
    });
  }

  void _regenerate() {
    //TODO(Kamil): implement regeneration
  }
}
