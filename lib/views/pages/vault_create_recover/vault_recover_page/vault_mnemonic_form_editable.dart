import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/pages/vault_create_recover/repeated_vault_warning.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_name_form.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_editable.dart';

class VaultMnemonicFormEditable extends StatelessWidget {
  final bool mnemonicFilledBool;
  final bool mnemonicValidBool;
  final int mnemonicSize;
  final KeyboardValueNotifier keyboardValueNotifier;
  final VaultModel? repeatedVaultModel;
  final List<TextEditingController> textControllersList;
  final VaultRecoverPageCubit vaultRecoverPageCubit;

  const VaultMnemonicFormEditable({
    required this.mnemonicFilledBool,
    required this.mnemonicValidBool,
    required this.mnemonicSize,
    required this.keyboardValueNotifier,
    required this.repeatedVaultModel,
    required this.textControllersList,
    required this.vaultRecoverPageCubit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MnemonicFormEditable(
      mnemonicSize: mnemonicSize,
      textControllersList: textControllersList,
      finishEnabledBool: recoverButtonEnabledBool,
      mnemonicErrorBool: mnemonicFilledBool == true && mnemonicValidBool == false,
      keyboardValueNotifier: keyboardValueNotifier,
      childrenList: <Widget>[
        if (repeatedVaultModel != null)
          RepeatedVaultWarning.simple(
            repeatedVaultModel: repeatedVaultModel!,
          ),
        VaultNameForm(
          textEditingController: vaultRecoverPageCubit.vaultNameTextEditingController,
          nameEmptyBool: vaultRecoverPageCubit.state.nameEmptyBool == true,
        ),
      ],
      onSaveMnemonic: vaultRecoverPageCubit.saveMnemonic,
      onFinish: (List<String> words, ScrollController scrollController) async {
        bool repeatedVaultExistsBool = vaultRecoverPageCubit.state.repeatedVaultModel != null;
        bool vaultNameEmptyBool = vaultRecoverPageCubit.state.nameEmptyBool == true;
        bool formInvalidBool = repeatedVaultExistsBool || vaultNameEmptyBool;
        if (formInvalidBool) {
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
      mnemonicValidBool == true && mnemonicFilledBool == true && repeatedVaultModel == null && vaultRecoverPageCubit.state.nameEmptyBool != true;
}
