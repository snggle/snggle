import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/vault_create_recover/mnemonic_size_picker.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_discard_dialog.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_mnemonic_form_editable.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/paginated_form/paginated_form.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

@RoutePage()
class VaultRecoverPage extends StatefulWidget {
  final FilesystemPath _parentFilesystemPath;

  const VaultRecoverPage({
    required this._parentFilesystemPath,
    super.key,
  });

  @override
  State<VaultRecoverPage> createState() => _VaultRecoverPageState();
}

class _VaultRecoverPageState extends State<VaultRecoverPage> {
  final KeyboardValueNotifier _keyboardValueNotifier = KeyboardValueNotifier();
  final PageController _pageController = PageController(keepPage: false);
  late final VaultRecoverPageCubit _vaultRecoverPageCubit = VaultRecoverPageCubit(parentFilesystemPath: widget._parentFilesystemPath);

  @override
  void dispose() {
    _keyboardValueNotifier.dispose();
    _pageController.dispose();
    _vaultRecoverPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultRecoverPageCubit, VaultRecoverPageState>(
      bloc: _vaultRecoverPageCubit,
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
              onPressed: () => _isFirstPage() ? context.router.root.pop() : _showDiscardDialog(onDiscardPressed: context.router.root.pop),
              icon: AssetIcon(AppIcons.app_bar_close, size: 20, color: AppColors.body1),
            ),
          ],
          body: PaginatedForm(
            pageController: _pageController,
            pages: <Widget>[
              MnemonicSizePicker(onSizeSelected: _handleMnemonicSizeSelected, advancedWarningBool: false),
              if (vaultRecoverPageState.confirmPageEnabledBool)
                VaultMnemonicFormEditable(
                  mnemonicSize: vaultRecoverPageState.mnemonicSize!,
                  textControllersList: vaultRecoverPageState.textControllers!,
                  mnemonicValidBool: vaultRecoverPageState.mnemonicValidBool,
                  mnemonicFilledBool: vaultRecoverPageState.mnemonicFilledBool,
                  vaultRecoverPageCubit: _vaultRecoverPageCubit,
                  repeatedVaultModel: vaultRecoverPageState.repeatedVaultModel,
                  keyboardValueNotifier: _keyboardValueNotifier,
                )
              else
                const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  void _handleCustomPop() {
    FocusScope.of(context).unfocus();
    _keyboardValueNotifier.hideKeyboard();

    if (_pageController.page != 0) {
      _showDiscardDialog(onDiscardPressed: _navigateToPreviousPage);
    } else {
      AutoRouter.of(context).pop();
    }
  }

  void _handleSystemPop() {
    FocusScope.of(context).unfocus();
    _keyboardValueNotifier.hideKeyboard();

    if (_isFirstPage() == false) {
      _showDiscardDialog(onDiscardPressed: _navigateToPreviousPage);
    } else {
      context.router.pop();
    }
  }

  Future<void> _showDiscardDialog({required VoidCallback onDiscardPressed}) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => VaultDiscardDialog(onDiscardPressed: onDiscardPressed),
    );
  }

  void _handleMnemonicSizeSelected(crypto_utils.MnemonicSize mnemonicSize) {
    _vaultRecoverPageCubit.init(mnemonicSize.wordCount);
    _pageController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }

  bool _isFirstPage() {
    if (_pageController.hasClients == false) {
      return true;
    }

    int pageIndex = _pageController.page?.round() ?? _pageController.initialPage;
    return pageIndex == 0;
  }

  void _navigateToPreviousPage() {
    _pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }
}
