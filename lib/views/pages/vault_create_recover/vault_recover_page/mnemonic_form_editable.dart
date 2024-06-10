import 'package:blockchain_utils/bip/bip/bip39/bip39.dart';
import 'package:flutter/cupertino.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/pages/vault_create_recover/mnemonic_form_layout.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_wrapper.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class MnemonicFormEditable extends StatefulWidget {
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final int lastVaultIndex;
  final int mnemonicSize;
  final KeyboardValueNotifier keyboardValueNotifier;
  final List<TextEditingController> textControllers;
  final VaultRecoverPageCubit vaultRecoverPageCubit;
  final bool recoverButtonActiveBool;

  const MnemonicFormEditable({
    required this.mnemonicValidBool,
    required this.mnemonicFilledBool,
    required this.lastVaultIndex,
    required this.mnemonicSize,
    required this.keyboardValueNotifier,
    required this.textControllers,
    required this.vaultRecoverPageCubit,
    super.key,
  }) : recoverButtonActiveBool = mnemonicValidBool == false || mnemonicFilledBool == false;

  @override
  State<StatefulWidget> createState() => _MnemonicFormEditableState();
}

class _MnemonicFormEditableState extends State<MnemonicFormEditable> {
  final ScrollController scrollController = ScrollController();
  late final List<GlobalObjectKey> mnemonicWordKeys = List<GlobalObjectKey>.generate(
    widget.mnemonicSize,
    (int index) => GlobalObjectKey('mnemonic_word_$index'),
  );

  late final List<FocusNode> focusNodes = List<FocusNode>.generate(
    widget.mnemonicSize,
    (int index) => FocusNode(),
  );

  bool obscureTextBool = true;

  @override
  void dispose() {
    for (GlobalKey globalKey in mnemonicWordKeys) {
      globalKey.currentState?.dispose();
    }
    for (FocusNode focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      keyboardValueNotifier: widget.keyboardValueNotifier,
      builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
        bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;

        return BottomTooltipWrapper(
          tooltipVisibleBool: anyKeyboardVisibleBool == false,
          blurBackgroundBool: false,
          tooltip: BottomTooltip(
            backgroundColor: AppColors.body2,
            actions: <Widget>[
              if (obscureTextBool)
                BottomTooltipItem(
                  label: 'Show',
                  iconData: AppIcons.show,
                  onTap: () => setState(() => obscureTextBool = false),
                )
              else
                BottomTooltipItem(
                  label: 'Hide',
                  iconData: AppIcons.hide,
                  onTap: () => setState(() => obscureTextBool = true),
                ),
              BottomTooltipItem(
                label: 'Finish',
                iconData: AppIcons.continue_icon,
                onTap: widget.recoverButtonActiveBool ? null : () => widget.vaultRecoverPageCubit.saveMnemonic(),
              ),
            ],
          ),
          child: KeyboardWrapper(
            keyboardValueNotifier: widget.keyboardValueNotifier,
            availableHints: bip39WordList(Bip39Languages.english),
            child: MnemonicFormLayout(
              scrollController: scrollController,
              bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 8),
                  CustomTextField(
                    label: 'Name',
                    initialValue: 'New_Vault_${widget.lastVaultIndex + 1}',
                    keyboardType: TextInputType.text,
                    enableInteractiveSelection: true,
                    textEditingController: widget.vaultRecoverPageCubit.vaultNameTextEditingController,
                  ),
                  const SizedBox(height: 14),
                  CustomGrid.builder(
                    childCount: widget.mnemonicSize,
                    columnsCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      bool errorVisibleBool = _isErrorVisible(index, widget.textControllers[index].text);

                      return CustomTextField(
                        key: mnemonicWordKeys[index],
                        autofocusBool: false,
                        customKeyboardBool: true,
                        obscureTextBool: obscureTextBool && focusNodes[index].hasFocus == false,
                        label: '${index + 1}',
                        onFocusChanged: (bool hasFocus) => _handleTextFieldFocusChange(hasFocus, index),
                        textEditingController: widget.textControllers[index],
                        focusNode: focusNodes[index],
                        errorExistsBool: errorVisibleBool,
                      );
                    },
                  ),
                  SizedBox(height: anyKeyboardVisibleBool ? 40 : 110),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isErrorVisible(int index, String word) {
    bool textFieldFocusedBool = focusNodes[index].hasFocus;
    bool lastTextFieldBool = index == widget.mnemonicSize - 1;

    bool wordCorrectBool = bip39WordList(Bip39Languages.english).contains(word);
    bool checksumErrorBool = lastTextFieldBool && widget.mnemonicFilledBool && widget.mnemonicValidBool == false;

    return (wordCorrectBool == false || checksumErrorBool) && textFieldFocusedBool == false && word.isNotEmpty;
  }

  void _handleTextFieldFocusChange(bool hasFocus, int index) {
    FocusNode currentFocusNode = focusNodes.elementAt(index);
    bool currentFocusChangedBool = widget.keyboardValueNotifier.isFocused(currentFocusNode);

    if (hasFocus) {
      widget.keyboardValueNotifier.showKeyboard(
        textEditingController: widget.textControllers.elementAt(index),
        previousFocusNode: index != 0 ? focusNodes.elementAtOrNull(index - 1) : null,
        currentFocusNode: currentFocusNode,
        nextFocusNode: focusNodes.elementAtOrNull(index + 1),
      );
      _ensureTextFieldVisible(index);
    } else if (currentFocusChangedBool) {
      widget.keyboardValueNotifier.hideKeyboard();
    }
  }

  Future<void> _ensureTextFieldVisible(int index) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    GlobalObjectKey textFieldKey = mnemonicWordKeys[index];
    if (textFieldKey.currentContext != null) {
      await Scrollable.ensureVisible(
        textFieldKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 100),
      );
    }
  }
}
