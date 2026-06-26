import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
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
  final bool mnemonicErrorBool;
  final int mnemonicSize;
  final KeyboardValueNotifier keyboardValueNotifier;
  final Future<void> Function(List<String> mnemonicList, ScrollController scrollController) onFinish;
  final Future<void> Function() onSaveMnemonic;
  final List<TextEditingController> textControllersList;

  final bool finishEnabledBool;
  final bool initialObscureTextBool;
  final int columnsCount;
  final double topSpacing;
  final List<Widget> childrenList;

  const MnemonicFormEditable({
    required this.mnemonicErrorBool,
    required this.mnemonicSize,
    required this.keyboardValueNotifier,
    required this.onFinish,
    required this.onSaveMnemonic,
    required this.textControllersList,
    this.finishEnabledBool = true,
    this.initialObscureTextBool = true,
    this.columnsCount = 3,
    this.topSpacing = 14,
    this.childrenList = const <Widget>[],
    Key? key,
  }) : super(key: key);

  @override
  State<MnemonicFormEditable> createState() => _MnemonicFormEditableState();
}

class _MnemonicFormEditableState extends State<MnemonicFormEditable> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalObjectKey> _mnemonicWordKeyList;
  late List<FocusNode> _focusNodesList;
  bool _obscureTextBool = true;

  @override
  void initState() {
    super.initState();
    _mnemonicWordKeyList = List<GlobalObjectKey>.generate(
      widget.mnemonicSize,
      (int i) => GlobalObjectKey('mnemonic_word_$i'),
    );

    _focusNodesList = List<FocusNode>.generate(widget.mnemonicSize, (_) => FocusNode());
    _obscureTextBool = widget.initialObscureTextBool;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (FocusNode focusNode in _focusNodesList) {
      focusNode.dispose();
    }
    super.dispose();
  }

  FocusNode? _focusNodeAt(int index) {
    if (index < 0 || index >= _focusNodesList.length) {
      return null;
    }
    return _focusNodesList[index];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (widget.textControllersList.length != widget.mnemonicSize) {
      return const SizedBox.shrink();
    }

    return KeyboardVisibilityBuilder(
      keyboardValueNotifier: widget.keyboardValueNotifier,
      builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
        bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;
        return KeyboardWrapper(
          keyboardValueNotifier: widget.keyboardValueNotifier,
          availableHints: crypto_utils.MnemonicDictionary.english,
          child: ScrollableLayout(
            tooltipVisibleBool: anyKeyboardVisibleBool == false,
            scrollController: _scrollController,
            tooltipItems: <BottomTooltipItem>[
              if (_obscureTextBool)
                BottomTooltipItem(
                  label: 'Show',
                  assetIconData: AppIcons.menu_eye_closed,
                  onTap: () => setState(() => _obscureTextBool = false),
                )
              else
                BottomTooltipItem(
                  label: 'Hide',
                  assetIconData: AppIcons.menu_eye_open,
                  onTap: () => setState(() => _obscureTextBool = true),
                ),
              BottomTooltipItem(
                label: 'Finish',
                assetIconData: AppIcons.menu_finish,
                onTap: widget.finishEnabledBool ? _pressFinishButton : null,
              ),
            ],
            bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  ...widget.childrenList,
                  SizedBox(height: widget.topSpacing),
                  CustomGrid.builder(
                    childCount: widget.mnemonicSize,
                    columnsCount: widget.columnsCount,
                    itemBuilder: (BuildContext context, int index) {
                      bool errorVisibleBool = _isErrorVisible(index);
                      return LabelWrapperVertical.textField(
                        label: '${index + 1}',
                        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                        bottomBorderVisibleBool: false,
                        child: CustomTextField(
                          key: _mnemonicWordKeyList[index],
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          autofocusBool: false,
                          customKeyboardBool: true,
                          obscureTextBool: _obscureTextBool && _focusNodesList[index].hasFocus == false,
                          onFocusChanged: (bool hasFocus) => _handleTextFieldFocusChange(hasFocus, index),
                          textStyle: themeData.textTheme.bodyMedium,
                          textEditingController: widget.textControllersList[index],
                          focusNode: _focusNodesList[index],
                          errorExistsBool: errorVisibleBool,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: anyKeyboardVisibleBool ? 50 : 120),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isErrorVisible(int index) {
    String word = widget.textControllersList[index].text;
    bool textFieldFocusedBool = _focusNodesList[index].hasFocus;
    bool wordCorrectBool = crypto_utils.MnemonicDictionary.english.contains(word);
    bool lastTextFieldBool = index == widget.mnemonicSize - 1;
    bool checksumErrorBool = lastTextFieldBool && widget.mnemonicErrorBool;

    return (wordCorrectBool == false || checksumErrorBool) && textFieldFocusedBool == false && word.isNotEmpty;
  }

  void _handleTextFieldFocusChange(bool focusBool, int index) {
    FocusNode currentFocusNode = _focusNodesList[index];
    bool currentFocusChangedBool = widget.keyboardValueNotifier.isFocused(currentFocusNode);

    setState(() {});
    if (focusBool) {
      widget.keyboardValueNotifier.showKeyboard(
        previousFocusNode: _focusNodeAt(index - 1),
        currentFocusNode: currentFocusNode,
        nextFocusNode: _focusNodeAt(index + 1),
        textEditingController: widget.textControllersList[index],
      );
      _ensureTextFieldVisible(index);
    } else if (currentFocusChangedBool) {
      widget.keyboardValueNotifier.hideKeyboard();
    }
  }

  Future<void> _ensureTextFieldVisible(int index) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    BuildContext? buildContext = _mnemonicWordKeyList[index].currentContext;
    if (buildContext != null) {
      await Scrollable.ensureVisible(
        buildContext,
        alignment: 0.5,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  Future<void> _pressFinishButton() async {
    await CustomLoadingDialog.show<void>(
      context: context,
      title: 'Saving...',
      futureFunction: widget.onSaveMnemonic,
      onSuccess: (_) async {
        List<String> words = widget.textControllersList.map((TextEditingController c) => c.text).toList(growable: false);
        await widget.onFinish(words, _scrollController);
      },
    );
  }
}
