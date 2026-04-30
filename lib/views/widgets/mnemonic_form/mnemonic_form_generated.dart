import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox_list_tile.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class MnemonicFormGenerated extends StatefulWidget {
  final crypto_utils.MnemonicSize mnemonicSize;
  final List<String> mnemonicList;
  final Future<void> Function(ScrollController scrollController) onFinishPressed;

  final bool finishButtonEnabledBool;
  final bool initialObscureTextBool;
  final bool statementInitialBool;
  final List<Widget> childrenWidgetList;

  const MnemonicFormGenerated({
    required this.mnemonicSize,
    required this.mnemonicList,
    required this.onFinishPressed,
    this.finishButtonEnabledBool = true,
    this.initialObscureTextBool = true,
    this.statementInitialBool = false,
    this.childrenWidgetList = const <Widget>[],
    super.key,
  });

  @override
  State<MnemonicFormGenerated> createState() => _MnemonicFormGeneratedState();
}

class _MnemonicFormGeneratedState extends State<MnemonicFormGenerated> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _valueNotifierBool = ValueNotifier<bool>(false);

  late List<TextEditingController> _textEditingControllerList;
  bool _obscureTextBool = true;
  bool _statementAcceptedBool = false;

  @override
  void initState() {
    super.initState();
    _obscureTextBool = widget.initialObscureTextBool;
    _statementAcceptedBool = widget.statementInitialBool;
    _textEditingControllerList = List<TextEditingController>.generate(
      widget.mnemonicSize.wordCount,
      (int i) => TextEditingController(text: widget.mnemonicList[i]),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted == false) {
        return;
      }
      _updateScrolledBottomNotifier();
      _scrollController.addListener(_updateScrolledBottomNotifier);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateScrolledBottomNotifier)
      ..dispose();

    _valueNotifierBool.dispose();

    for (TextEditingController textEditController in _textEditingControllerList) {
      textEditController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ScrollableLayout(
      scrollController: _scrollController,
      tooltipItems: <Widget>[
        BottomTooltipItem(
          label: _obscureTextBool ? 'Show' : 'Hide',
          assetIconData: _obscureTextBool ? AppIcons.menu_eye_closed : AppIcons.menu_eye_open,
          onTap: () => setState(() => _obscureTextBool = !_obscureTextBool),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _valueNotifierBool,
          builder: (BuildContext context, bool scrolledBottomBool, _) {
            return BottomTooltipItem(
              label: scrolledBottomBool ? 'Finish' : 'Continue',
              assetIconData: scrolledBottomBool ? AppIcons.menu_save : AppIcons.menu_finish,
              onTap: scrolledBottomBool
                  ? (widget.finishButtonEnabledBool && _statementAcceptedBool
                      ? () async {
                          await widget.onFinishPressed(_scrollController);
                        }
                      : null)
                  : _pressContinueButton,
            );
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            ...widget.childrenWidgetList,
            const SizedBox(height: 14),
            CustomGrid.builder(
              columnsCount: 3,
              childCount: widget.mnemonicSize.wordCount,
              itemBuilder: (BuildContext context, int index) {
                return LabelWrapperVertical.textField(
                  label: '${index + 1}',
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  bottomBorderVisibleBool: false,
                  child: CustomTextField(
                    readOnlyBool: true,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    textStyle: theme.textTheme.bodyMedium,
                    textEditingController: _textEditingControllerList[index],
                    autofocusBool: index == 0,
                    obscureTextBool: _obscureTextBool,
                  ),
                );
              },
            ),
            const SizedBox(height: 21),
            CustomCheckboxListTile(
              initialValue: _statementAcceptedBool,
              onChanged: (bool value) => setState(() => _statementAcceptedBool = value),
              title: 'I have written down all recovery words in their correct order '
                  'and acknowledge that losing or revealing the mnemonic might '
                  'result in the loss of funds.',
              selectedBorder: GradientBoxBorder(
                gradient: RadialGradient(
                  radius: 3.5,
                  center: Alignment.topLeft,
                  colors: AppColors.primaryGradient.colors,
                ),
                width: 1,
              ),
              unselectedBorder: GradientBoxBorder(
                gradient: RadialGradient(
                  radius: 3.5,
                  center: Alignment.topLeft,
                  colors: AppColors.validationGradient.colors,
                ),
                width: 1,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _pressContinueButton() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateScrolledBottomNotifier() {
    if (_scrollController.hasClients) {
      bool atBottomBool = _scrollController.position.atEdge && _scrollController.position.pixels == _scrollController.position.maxScrollExtent;

      if (_valueNotifierBool.value != atBottomBool) {
        _valueNotifierBool.value = atBottomBool;
      }
    }
  }
}
