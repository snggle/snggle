import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/vault_create_recover/mnemonic_size_picker.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_mnemonic_form_generated.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/paginated_form/paginated_form.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class VaultCreatePage extends StatefulWidget {
  final FilesystemPath _parentFilesystemPath;

  const VaultCreatePage({
    required this._parentFilesystemPath,
    super.key,
  });

  @override
  State<VaultCreatePage> createState() => _VaultCreatePageState();
}

class _VaultCreatePageState extends State<VaultCreatePage> {
  final PageController _pageController = PageController(keepPage: false);
  late final VaultCreatePageCubit _vaultCreatePageCubit = VaultCreatePageCubit(
    parentFilesystemPath: widget._parentFilesystemPath,
  );

  @override
  void dispose() {
    _pageController.dispose();
    _vaultCreatePageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<VaultCreatePageCubit, VaultCreatePageState>(
      bloc: _vaultCreatePageCubit,
      builder: (BuildContext buildContext, VaultCreatePageState vaultCreatePageState) {
        return CustomScaffold(
          title: 'Vault creation',
          popAvailableBool: false,
          popButtonVisible: true,
          customPopCallback: _handleCustomPop,
          customSystemPopCallback: _handleCustomPop,
          actions: <Widget>[
            IconButton(
              onPressed: () => context.router.root.pop(),
              icon: AssetIcon(AppIcons.app_bar_close, size: 20, color: AppColors.body1),
            ),
          ],
          body: PaginatedForm(
            pageController: _pageController,
            pages: <Widget>[
              MnemonicSizePicker(onSizeSelected: _handleMnemonicSizeSelected, advancedWarningBool: true),
              if (vaultCreatePageState.mnemonicFormVisibleBool)
                VaultMnemonicFormGenerated(
                  mnemonicModel: vaultCreatePageState.mnemonicModel!,
                  vaultCreatePageCubit: _vaultCreatePageCubit,
                  repeatedVaultModel: vaultCreatePageState.repeatedVaultModel,
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
    if (_isFirstPage() == false) {
      _pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    } else {
      context.router.pop();
    }
  }

  Future<void> _handleMnemonicSizeSelected(crypto_utils.MnemonicSize mnemonicSize) async {
    await _vaultCreatePageCubit.init(mnemonicSize);
    await _pageController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }

  bool _isFirstPage() {
    if (_pageController.hasClients == false) {
      return true;
    }

    int pageIndex = _pageController.page?.round() ?? _pageController.initialPage;
    return pageIndex == 0;
  }
}
