import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox_list_tile.dart';
import 'package:snggle/views/widgets/custom/custom_grid.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class MnemonicFormGenerated extends StatefulWidget {
  final crypto_utils.MnemonicSize mnemonicSize;
  final List<String> mnemonic;
  final VaultCreatePageCubit vaultCreatePageCubit;
  final VaultModel? repeatedVaultModel;

  const MnemonicFormGenerated({
    required this.mnemonicSize,
    required this.mnemonic,
    required this.vaultCreatePageCubit,
    required this.repeatedVaultModel,
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
    ThemeData theme = Theme.of(context);

    TextEditingController vaultNameTextEditingController = widget.vaultCreatePageCubit.vaultNameTextEditingController;

    return ScrollableLayout(
      scrollController: scrollController,
      tooltipItems: <Widget>[
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
        AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[scrolledBottomNotifier, vaultNameTextEditingController]),
          builder: (BuildContext context, _) {
            return BottomTooltipItem(
              label: _bottomTooltipLabel,
              assetIconData: _bottomTooltipIcon,
              onTap: _bottomTooltipOnTap,
            );
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
            if (widget.repeatedVaultModel != null) ...<Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'CRITICAL WARNING',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'The vault already exists. The randomization algorithm on your device may be compromised.',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Repeated vault: ${widget.repeatedVaultModel!.name}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
            LabelWrapperVertical.textField(
              label: 'Name',
              labelPadding: const EdgeInsets.symmetric(horizontal: 10),
              bottomBorderVisibleBool: false,
              child: CustomTextField(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                keyboardType: TextInputType.text,
                enableInteractiveSelectionBool: true,
                textEditingController: widget.vaultCreatePageCubit.vaultNameTextEditingController,
              ),
            ),
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
                    textEditingController: TextEditingController(text: widget.mnemonic[index]),
                    autofocusBool: index == 0,
                    obscureTextBool: obscureTextBool,
                  ),
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  AssetIconData get _bottomTooltipIcon => _scrolledBottomBool ? AppIcons.menu_save : AppIcons.menu_finish;

  String get _bottomTooltipLabel => _scrolledBottomBool ? 'Finish' : 'Continue';

  VoidCallback? get _bottomTooltipOnTap => _scrolledBottomBool ? (_finishButtonEnabledBool ? _pressFinishButton : null) : _pressContinueButton;

  bool get _finishButtonEnabledBool => _scrolledBottomBool && statementAcceptedBool && widget.repeatedVaultModel == null && _vaultNameNotEmptyBool;

  bool get _scrolledBottomBool => scrolledBottomNotifier.value;

  bool get _vaultNameNotEmptyBool => widget.vaultCreatePageCubit.vaultNameTextEditingController.text.trim().isNotEmpty;

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

  Future<void> _pressFinishButton() async {
    await CustomLoadingDialog.show<void>(
      context: context,
      title: 'Saving...',
      futureFunction: widget.vaultCreatePageCubit.saveMnemonic,
      onSuccess: (_) async {
        if (widget.vaultCreatePageCubit.state.repeatedVaultModel != null) {
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
