import 'package:auto_route/auto_route.dart';
import 'package:blockchain_utils/bip/bip/bip39/bip39.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_wrapper.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class MnemonicFormEditable extends StatefulWidget {
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final int mnemonicSize;
  final KeyboardValueNotifier keyboardValueNotifier;
  final List<TextEditingController> textControllers;
  final VaultRecoverPageCubit vaultRecoverPageCubit;
  final bool recoverButtonActiveBool;

  const MnemonicFormEditable({
    required this.mnemonicValidBool,
    required this.mnemonicFilledBool,
    required this.mnemonicSize,
    required this.keyboardValueNotifier,
    required this.textControllers,
    required this.vaultRecoverPageCubit,
    super.key,
  }) : recoverButtonActiveBool = mnemonicValidBool == true && mnemonicFilledBool == true;

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
    ThemeData theme = Theme.of(context);

    return KeyboardVisibilityBuilder(
      keyboardValueNotifier: widget.keyboardValueNotifier,
      builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
        bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;

        return KeyboardWrapper(
          keyboardValueNotifier: widget.keyboardValueNotifier,
          availableHints: bip39WordList(Bip39Languages.english),
          child: ScrollableLayout(
            tooltipVisibleBool: anyKeyboardVisibleBool == false,
            scrollController: scrollController,
            tooltipItems: <BottomTooltipItem>[
              if (obscureTextBool)
                BottomTooltipItem(
                  label: 'Show',
                  assetIconData: AppIcons.menu_eye_closed,
                  onTap: () => setState(() => obscureTextBool = false),
                )
              else
                BottomTooltipItem(
                  label: 'Hide',
                  assetIconData: AppIcons.menu_eye_open,
                  onTap: () => setState(() => obscureTextBool = true),
                ),
              BottomTooltipItem(
                label: 'Finish',
                assetIconData: AppIcons.menu_finish,
                onTap: widget.recoverButtonActiveBool ? _pressFinishButton : null,
              ),
            ],
            bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  if (widget.vaultRecoverPageCubit.state.mnemonicRepeatedBool) ...<Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'The vault already exists',
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.warning_amber_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  LabelWrapperVertical.textField(
                    label: 'Name',
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    bottomBorderVisibleBool: false,
                    child: CustomTextField(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      initialValue: widget.vaultRecoverPageCubit.vaultNameTextEditingController.text,
                      keyboardType: TextInputType.text,
                      enableInteractiveSelectionBool: true,
                      textEditingController: widget.vaultRecoverPageCubit.vaultNameTextEditingController,
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomGrid.builder(
                    childCount: widget.mnemonicSize,
                    columnsCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      bool errorVisibleBool = _isErrorVisible(index, widget.textControllers[index].text);

                      return LabelWrapperVertical.textField(
                        label: '${index + 1}',
                        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                        bottomBorderVisibleBool: false,
                        child: CustomTextField(
                          key: mnemonicWordKeys[index],
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          autofocusBool: false,
                          customKeyboardBool: true,
                          obscureTextBool: obscureTextBool && focusNodes[index].hasFocus == false,
                          onFocusChanged: (bool hasFocus) => _handleTextFieldFocusChange(hasFocus, index),
                          textStyle: theme.textTheme.bodyMedium,
                          textEditingController: widget.textControllers[index],
                          focusNode: focusNodes[index],
                          errorExistsBool: errorVisibleBool,
                        ),
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

  Future<void> _recoverVault() async {
    await widget.vaultRecoverPageCubit.saveMnemonic();
  }

  Future<void> _pressFinishButton() async {
    await CustomLoadingDialog.show<void>(
      context: context,
      title: 'Saving...',
      futureFunction: _recoverVault,
      onSuccess: (_) async {
        if (widget.vaultRecoverPageCubit.state.mnemonicRepeatedBool) {
          await scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else {
          await AutoRouter.of(context).root.pop(VaultCreateRecoverStatus.creationSuccessful);
        }
      },
    );
  }
}
