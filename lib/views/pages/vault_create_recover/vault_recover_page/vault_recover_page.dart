import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/vault_create_recover/mnemonic_size_picker.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/mnemonic_form_editable.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/paginated_form/paginated_form.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

@RoutePage<VaultCreateRecoverStatus?>()
class VaultRecoverPage extends StatefulWidget {
  final FilesystemPath parentFilesystemPath;

  const VaultRecoverPage({
    required this.parentFilesystemPath,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VaultRecoverPageState();
}

class _VaultRecoverPageState extends State<VaultRecoverPage> {
  final PageController pageController = PageController(keepPage: false);
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  late final VaultRecoverPageCubit vaultRecoverPageCubit = VaultRecoverPageCubit(
    parentFilesystemPath: widget.parentFilesystemPath,
  );

  @override
  void dispose() {
    pageController.dispose();
    keyboardValueNotifier.dispose();
    vaultRecoverPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultRecoverPageCubit, VaultRecoverPageState>(
      bloc: vaultRecoverPageCubit,
      builder: (BuildContext context, VaultRecoverPageState vaultRecoverPageState) {
        return CustomScaffold(
          title: 'Vault recovery',
          popAvailableBool: false,
          popButtonVisible: true,
          resizeToAvoidBottomInsetBool: true,
          customPopCallback: _handleCustomPop,
          customSystemPopCallback: _handleSystemPop,
          actions: <Widget>[
            IconButton(
              onPressed: () => AutoRouter.of(context).root.pop(),
              icon: AssetIcon(AppIcons.app_bar_close, size: 20, color: AppColors.body1),
            ),
          ],
          body: PaginatedForm(
            pageController: pageController,
            pages: <Widget>[
              MnemonicSizePicker(onSizeSelected: _handleMnemonicSizeSelected),
              if (vaultRecoverPageState.confirmPageEnabledBool)
                MnemonicFormEditable(
                  mnemonicSize: vaultRecoverPageState.mnemonicSize!,
                  keyboardValueNotifier: keyboardValueNotifier,
                  textControllers: vaultRecoverPageState.textControllers!,
                  mnemonicValidBool: vaultRecoverPageState.mnemonicValidBool,
                  mnemonicFilledBool: vaultRecoverPageState.mnemonicFilledBool,
                  vaultRecoverPageCubit: vaultRecoverPageCubit,
                )
              else
                const SizedBox()
            ],
          ),
        );
      },
    );
  }

  void _handleCustomPop() {
    FocusScope.of(context).unfocus();
    if (pageController.page != 0) {
      pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    } else {
      AutoRouter.of(context).popForced();
    }
  }

  void _handleSystemPop() {
    FocusScope.of(context).unfocus();
    if (keyboardValueNotifier.isVisible()) {
      keyboardValueNotifier.hideKeyboard();
    } else if (pageController.page != 0) {
      pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    } else {
      AutoRouter.of(context).popForced();
    }
  }

  void _handleMnemonicSizeSelected(int mnemonicSize) {
    vaultRecoverPageCubit.init(mnemonicSize);
    pageController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }
}
