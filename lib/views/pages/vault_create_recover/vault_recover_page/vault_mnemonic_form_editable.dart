import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/pages/vault_create_recover/repeated_vault_warning.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_name_form.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_editable.dart';

class VaultMnemonicFormEditable extends StatelessWidget {
  final bool mnemonicValidBool;
  final bool mnemonicFilledBool;
  final int mnemonicSize;
  final List<TextEditingController> textControllersList;
  final VaultRecoverPageCubit vaultRecoverPageCubit;
  final VaultModel? repeatedVaultModel;

  const VaultMnemonicFormEditable({
    required this.mnemonicValidBool,
    required this.mnemonicFilledBool,
    required this.mnemonicSize,
    required this.textControllersList,
    required this.vaultRecoverPageCubit,
    required this.repeatedVaultModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MnemonicFormEditable(
      mnemonicSize: mnemonicSize,
      textControllersList: textControllersList,
      finishEnabledBool: recoverButtonEnabledBool,
      childrenList: <Widget>[
        if (repeatedVaultModel != null)
          RepeatedVaultWarning.simple(
            repeatedVaultModel: repeatedVaultModel!,
          ),
        VaultNameForm(
          textEditingController: vaultRecoverPageCubit.vaultNameTextEditingController,
          showEmptyErrorBool: vaultRecoverPageCubit.state.vaultNameEmptyBool == true,
        ),
      ],
      onSaveMnemonic: vaultRecoverPageCubit.saveMnemonic,
      onFinish: (List<String> words, ScrollController scrollController) async {
        if (vaultRecoverPageCubit.state.repeatedVaultModel != null || vaultRecoverPageCubit.state.vaultNameEmptyBool == true) {
          await scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          return;
        }

        await AutoRouter.of(context).root.pop(VaultCreateRecoverStatus.creationSuccessful);
      },
    );
  }

  bool get recoverButtonEnabledBool =>
      mnemonicValidBool == true && mnemonicFilledBool == true && repeatedVaultModel == null && vaultRecoverPageCubit.state.vaultNameEmptyBool != true;
}
