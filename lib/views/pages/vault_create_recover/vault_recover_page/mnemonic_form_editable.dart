import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_editable/mnemonic_form_editable_cubit.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_editable/mnemonic_form_editable_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_wrapper.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class MnemonicFormEditable extends StatefulWidget {
  final crypto_utils.MnemonicSize mnemonicSize;
  final FilesystemPath parentFilesystemPath;
  final KeyboardValueNotifier keyboardValueNotifier;

  const MnemonicFormEditable({
    required this.mnemonicSize,
    required this.parentFilesystemPath,
    required this.keyboardValueNotifier,
    super.key,
  });

  @override
  State<MnemonicFormEditable> createState() => _MnemonicFormEditableState();
}

class _MnemonicFormEditableState extends State<MnemonicFormEditable> {
  final ScrollController scrollController = ScrollController();
  late final MnemonicFormEditableCubit mnemonicFormEditableCubit;
  late final List<GlobalObjectKey> mnemonicWordKeys = List<GlobalObjectKey>.generate(
    widget.mnemonicSize.wordCount,
    (int index) => GlobalObjectKey('mnemonic_word_$index'),
  );

  late final List<FocusNode> focusNodes = List<FocusNode>.generate(
    widget.mnemonicSize.wordCount,
    (int index) => FocusNode(),
  );

  bool obscureTextBool = true;

  @override
  void initState() {
    super.initState();
    mnemonicFormEditableCubit = MnemonicFormEditableCubit(
      parentFilesystemPath: widget.parentFilesystemPath,
      mnemonicSize: widget.mnemonicSize,
    );
  }

  @override
  void dispose() {
    for (GlobalKey globalKey in mnemonicWordKeys) {
      globalKey.currentState?.dispose();
    }
    for (FocusNode focusNode in focusNodes) {
      focusNode.dispose();
    }

    scrollController.dispose();
    mnemonicFormEditableCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocBuilder<MnemonicFormEditableCubit, MnemonicFormEditableState>(
      bloc: mnemonicFormEditableCubit,
      builder: (BuildContext context, MnemonicFormEditableState mnemonicFormEditableState) {
        return KeyboardVisibilityBuilder(
          keyboardValueNotifier: widget.keyboardValueNotifier,
          builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
            bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;

            return KeyboardWrapper(
              keyboardValueNotifier: widget.keyboardValueNotifier,
              availableHints: crypto_utils.MnemonicDictionary.english,
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
                    onTap: mnemonicFormEditableCubit.state.mnemonicCompleteBool ? _pressFinishButton : null,
                  ),
                ],
                bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      if (mnemonicFormEditableCubit.state.repeatedVaultModel != null) ...<Widget>[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'The vault already exists',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Repeated vault: ${mnemonicFormEditableCubit.state.repeatedVaultModel!.name}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                      ],
                      LabelWrapperVertical.textField(
                        label: 'Name',
                        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                        bottomBorderVisibleBool: false,
                        child: CustomTextField(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          keyboardType: TextInputType.text,
                          enableInteractiveSelectionBool: true,
                          textEditingController: mnemonicFormEditableCubit.vaultNameTextEditingController,
                        ),
                      ),
                      if (mnemonicFormEditableCubit.state.vaultNameExistsBool == true)
                        const ErrorMessageListTile(
                          message: 'Vault with this name already exists',
                        ),
                      const SizedBox(height: 14),
                      CustomGrid.builder(
                        childCount: mnemonicFormEditableCubit.state.mnemonicSize.wordCount,
                        columnsCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          bool errorVisibleBool = _isErrorVisible(index, mnemonicFormEditableCubit.state.textControllers[index].text);

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
                              textEditingController: mnemonicFormEditableCubit.state.textControllers[index],
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
      },
    );
  }

  bool _isErrorVisible(int index, String word) {
    bool textFieldFocusedBool = focusNodes[index].hasFocus;
    bool lastTextFieldBool = index == widget.mnemonicSize.wordCount - 1;

    bool wordCorrectBool = crypto_utils.MnemonicDictionary.english.contains(word);
    bool checksumErrorBool =
        lastTextFieldBool && mnemonicFormEditableCubit.state.mnemonicFilledBool && mnemonicFormEditableCubit.state.mnemonicValidBool == false;

    return (wordCorrectBool == false || checksumErrorBool) && textFieldFocusedBool == false && word.isNotEmpty;
  }

  void _handleTextFieldFocusChange(bool hasFocus, int index) {
    FocusNode currentFocusNode = focusNodes.elementAt(index);
    bool currentFocusChangedBool = widget.keyboardValueNotifier.isFocused(currentFocusNode);

    if (hasFocus) {
      widget.keyboardValueNotifier.showKeyboard(
        textEditingController: mnemonicFormEditableCubit.state.textControllers.elementAt(index),
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

  Future<void> _pressFinishButton() async {
    await CustomLoadingDialog.show<void>(
      context: context,
      title: 'Saving...',
      futureFunction: mnemonicFormEditableCubit.saveMnemonic,
      onSuccess: (_) async {
        if (mnemonicFormEditableCubit.state.repeatedVaultModel != null) {
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
