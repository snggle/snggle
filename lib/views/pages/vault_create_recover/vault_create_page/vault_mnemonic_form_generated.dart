import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/pages/vault_create_recover/repeated_vault_warning.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_name_form.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_generated.dart';

class VaultMnemonicFormGenerated extends StatefulWidget {
  final crypto_utils.MnemonicSize mnemonicSize;
  final List<String> mnemonicList;
  final VaultCreatePageCubit vaultCreatePageCubit;
  final VaultModel? repeatedVaultModel;

  const VaultMnemonicFormGenerated({
    required this.mnemonicSize,
    required this.mnemonicList,
    required this.vaultCreatePageCubit,
    required this.repeatedVaultModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VaultMnemonicFormGeneratedState();
}

class _VaultMnemonicFormGeneratedState extends State<VaultMnemonicFormGenerated> {
  @override
  Widget build(BuildContext context) {
    return MnemonicFormGenerated(
      mnemonicSize: widget.mnemonicSize,
      mnemonicList: widget.mnemonicList,
      finishButtonEnabledBool: _finishButtonEnabledBool,
      childrenWidgetList: <Widget>[
        if (widget.repeatedVaultModel != null)
          RepeatedVaultWarning.critical(
            repeatedVaultModel: widget.repeatedVaultModel!,
          ),
        VaultNameForm(
          textEditingController: widget.vaultCreatePageCubit.vaultNameTextEditingController,
          showEmptyErrorBool: widget.vaultCreatePageCubit.state.vaultNameEmptyBool == true,
        ),
        // <<< CHANGED
      ],
      onFinishPressed: _pressFinishButton,
    );
  }

  Future<void> _pressFinishButton(ScrollController scrollController) async {
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

  bool get _finishButtonEnabledBool => widget.repeatedVaultModel == null && widget.vaultCreatePageCubit.state.vaultNameEmptyBool == false;
}
