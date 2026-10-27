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
  final bool _mnemonicErrorBool;
  final int _mnemonicSize;
  final KeyboardValueNotifier _keyboardValueNotifier;
  final Future<void> Function(List<String> mnemonicList, ScrollController scrollController) _onFinish;
  final Future<void> Function() _onSaveMnemonic;
  final List<TextEditingController> _textControllersList;

  final bool _finishEnabledBool;
  final bool _initialObscureTextBool;
  final int _columnsCount;
  final double _topSpacing;
  final List<Widget> _childrenList;

  const MnemonicFormEditable({
    required this._mnemonicErrorBool,
    required this._mnemonicSize,
    required this._keyboardValueNotifier,
    required this._onFinish,
    required this._onSaveMnemonic,
    required this._textControllersList,
    this._finishEnabledBool = true,
    this._initialObscureTextBool = true,
    this._columnsCount = 3,
    this._topSpacing = 14,
    this._childrenList = const <Widget>[],
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
      widget._mnemonicSize,
      (int i) => GlobalObjectKey('mnemonic_word_$i'),
    );

    _focusNodesList = List<FocusNode>.generate(widget._mnemonicSize, (_) => FocusNode());
    _obscureTextBool = widget._initialObscureTextBool;
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

    if (widget._textControllersList.length != widget._mnemonicSize) {
      return const SizedBox.shrink();
    }

    return KeyboardVisibilityBuilder(
      keyboardValueNotifier: widget._keyboardValueNotifier,
      builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
        bool anyKeyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;
        return KeyboardWrapper(
          keyboardValueNotifier: widget._keyboardValueNotifier,
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
                onTap: widget._finishEnabledBool ? _pressFinishButton : null,
              ),
            ],
            bottomMarginVisibleBool: anyKeyboardVisibleBool == false,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  ...widget._childrenList,
                  SizedBox(height: widget._topSpacing),
                  CustomGrid.builder(
                    childCount: widget._mnemonicSize,
                    columnsCount: widget._columnsCount,
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
                          obscureTextBool: _obscureTextBool && _focusNodesList[index].hasFocus == false,
                          onFocusChanged: (bool hasFocus) => _handleTextFieldFocusChange(hasFocus, index),
                          textStyle: themeData.textTheme.bodyMedium,
                          textEditingController: widget._textControllersList[index],
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
    String word = widget._textControllersList[index].text;
    bool textFieldFocusedBool = _focusNodesList[index].hasFocus;
    bool wordCorrectBool = crypto_utils.MnemonicDictionary.english.contains(word);
    bool lastTextFieldBool = index == widget._mnemonicSize - 1;
    bool checksumErrorBool = lastTextFieldBool && widget._mnemonicErrorBool;

    return (wordCorrectBool == false || checksumErrorBool) && textFieldFocusedBool == false && word.isNotEmpty;
  }

  void _handleTextFieldFocusChange(bool focusBool, int index) {
    FocusNode currentFocusNode = _focusNodesList[index];
    bool currentFocusChangedBool = widget._keyboardValueNotifier.isFocused(currentFocusNode);

    setState(() {});
    if (focusBool) {
      widget._keyboardValueNotifier.showKeyboard(
        previousFocusNode: _focusNodeAt(index - 1),
        currentFocusNode: currentFocusNode,
        nextFocusNode: _focusNodeAt(index + 1),
        textEditingController: widget._textControllersList[index],
      );
      _ensureTextFieldVisible(index);
    } else if (currentFocusChangedBool) {
      widget._keyboardValueNotifier.hideKeyboard();
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
      futureFunction: widget._onSaveMnemonic,
      onSuccess: (_) async {
        List<String> words = widget._textControllersList.map((TextEditingController c) => c.text).toList(growable: false);
        await widget._onFinish(words, _scrollController);
      },
    );
  }
}
