import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/bloc/widgets/mnemonic_form_generated/mnemonic_form_generated_cubit.dart';
import 'package:snggle/bloc/widgets/mnemonic_form_generated/mnemonic_form_generated_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox_list_tile.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class MnemonicFormGenerated extends StatefulWidget {
  final List<String> mnemonicList;
  final Future<void> Function(ScrollController scrollController) onFinishPressed;

  final List<Widget> childrenWidgetList;

  const MnemonicFormGenerated({
    required this.mnemonicList,
    required this.onFinishPressed,
    this.childrenWidgetList = const <Widget>[],
    super.key,
  });

  @override
  State<MnemonicFormGenerated> createState() => _MnemonicFormGeneratedState();
}

class _MnemonicFormGeneratedState extends State<MnemonicFormGenerated> {
  late final MnemonicFormGeneratedCubit _mnemonicFormGeneratedCubit;
  final ScrollController _scrollController = ScrollController();
  late List<TextEditingController> _textEditingControllerList;

  @override
  void initState() {
    super.initState();
    _mnemonicFormGeneratedCubit = MnemonicFormGeneratedCubit();

    _textEditingControllerList = List<TextEditingController>.generate(
      widget.mnemonicList.length,
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

    for (TextEditingController textEditingController in _textEditingControllerList) {
      textEditingController.dispose();
    }

    _mnemonicFormGeneratedCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    ThemeData theme = Theme.of(buildContext);
    return BlocBuilder<MnemonicFormGeneratedCubit, MnemonicFormGeneratedState>(
      bloc: _mnemonicFormGeneratedCubit,
      builder: (BuildContext buildContext, MnemonicFormGeneratedState mnemonicFormGeneratedState) {
        return ScrollableLayout(
          scrollController: _scrollController,
          tooltipItems: <Widget>[
            BottomTooltipItem(
              label: mnemonicFormGeneratedState.obscureTextBool ? 'Show' : 'Hide',
              assetIconData: mnemonicFormGeneratedState.obscureTextBool ? AppIcons.menu_eye_closed : AppIcons.menu_eye_open,
              onTap: _mnemonicFormGeneratedCubit.toggleObscureText,
            ),
            BottomTooltipItem(
              label: mnemonicFormGeneratedState.scrolledBottomBool ? 'Finish' : 'Continue',
              assetIconData: mnemonicFormGeneratedState.scrolledBottomBool ? AppIcons.menu_save : AppIcons.menu_finish,
              onTap: mnemonicFormGeneratedState.scrolledBottomBool
                  ? (mnemonicFormGeneratedState.finishButtonEnabledBool
                      ? () async {
                          await widget.onFinishPressed(_scrollController);
                        }
                      : null)
                  : _pressContinueButton,
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
                  childCount: widget.mnemonicList.length,
                  itemBuilder: (BuildContext buildContext, int index) {
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
                        obscureTextBool: mnemonicFormGeneratedState.obscureTextBool,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 21),
                CustomCheckboxListTile(
                  initialValue: mnemonicFormGeneratedState.statementAcceptedBool,
                  onChanged: (bool statementAcceptedBool) {
                    _mnemonicFormGeneratedCubit.updateStatementAccepted(
                      statementAcceptedBool: statementAcceptedBool,
                    );
                  },
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
      },
    );
  }

  void _updateScrolledBottomNotifier() {
    if (_scrollController.hasClients) {
      bool atBottomBool = _scrollController.position.atEdge && _scrollController.position.pixels == _scrollController.position.maxScrollExtent;

      _mnemonicFormGeneratedCubit.updateScrolledBottom(
        scrolledBottomBool: atBottomBool,
      );
    }
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
}
