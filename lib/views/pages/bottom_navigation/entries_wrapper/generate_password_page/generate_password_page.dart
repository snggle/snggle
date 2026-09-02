import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
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
  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();

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
}
