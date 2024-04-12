import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox_list_tile.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class MnemonicFormGenerated extends StatefulWidget {
  final int lastVaultIndex;
  final int mnemonicSize;
  final List<String> mnemonic;
  final VaultCreatePageCubit vaultCreatePageCubit;

  const MnemonicFormGenerated({
    required this.lastVaultIndex,
    required this.mnemonicSize,
    required this.mnemonic,
    required this.vaultCreatePageCubit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MnemonicFormGeneratedState();
}

class _MnemonicFormGeneratedState extends State<MnemonicFormGenerated> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> scrolledBottomNotifier = ValueNotifier<bool>(false);

  bool obscureTextBool = true;
  bool statementAcceptedBool = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _enableFinishButton();
      scrollController.addListener(_enableFinishButton);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomTooltipWrapper(
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
          ValueListenableBuilder<bool>(
            valueListenable: scrolledBottomNotifier,
            builder: (BuildContext context, bool scrolledBottomBool, _) {
              return BottomTooltipItem(
                label: scrolledBottomBool ? 'Finish' : 'Continue',
                iconData: AppIcons.continue_icon,
                onTap: scrolledBottomBool
                    ? statementAcceptedBool
                        ? _pressFinishButton
                        : null
                    : _pressContinueButton,
              );
            },
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GradientScrollbar(
          scrollController: scrollController,
          margin: const EdgeInsets.only(bottom: 80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    label: 'Name',
                    initialValue: 'New_Vault_${widget.lastVaultIndex + 1}',
                    keyboardType: TextInputType.text,
                    enableInteractiveSelection: true,
                    textEditingController: widget.vaultCreatePageCubit.vaultNameTextEditingController,
                  ),
                  const SizedBox(height: 14),
                  CustomGrid.builder(
                    columnsCount: 3,
                    childCount: widget.mnemonicSize,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomTextField(
                        readOnlyBool: true,
                        label: '${index + 1}',
                        textEditingController: TextEditingController(text: widget.mnemonic[index]),
                        autofocusBool: index == 0,
                        obscureTextBool: obscureTextBool,
                      );
                    },
                  ),
                  const SizedBox(height: 21),
                  CustomCheckboxListTile(
                    initialValue: false,
                    onChanged: (bool value) => setState(() => statementAcceptedBool = value),
                    title:
                        'I have written down all recovery words in their correct order and acknowledge that loosing or revealing the mnemonic might result in the loss of funds.',
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
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pressContinueButton() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _enableFinishButton() {
    if (scrollController.position.atEdge && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      scrolledBottomNotifier.value = true;
    } else {
      scrolledBottomNotifier.value = false;
    }
  }

  void _pressFinishButton() {
    widget.vaultCreatePageCubit.saveMnemonic();
  }
}
