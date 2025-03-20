import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/vault_create_recover/mnemonic_size_picker.dart';
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/mnemonic_form_generated.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/paginated_form/paginated_form.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage<VaultCreateRecoverStatus?>()
class VaultCreatePage extends StatefulWidget {
  final FilesystemPath parentFilesystemPath;

  const VaultCreatePage({
    required this.parentFilesystemPath,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VaultCreatePageState();
}

class _VaultCreatePageState extends State<VaultCreatePage> {
  final PageController pageController = PageController(keepPage: false);
  late final VaultCreatePageCubit vaultCreatePageCubit = VaultCreatePageCubit(
    parentFilesystemPath: widget.parentFilesystemPath,
  );

  @override
  void dispose() {
    pageController.dispose();
    vaultCreatePageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultCreatePageCubit, VaultCreatePageState>(
      bloc: vaultCreatePageCubit,
      builder: (BuildContext context, VaultCreatePageState vaultCreatePageState) {
        return CustomScaffold(
          title: 'Vault creation',
          popAvailableBool: false,
          popButtonVisible: true,
          customPopCallback: _handleCustomPop,
          actions: <Widget>[
            IconButton(
              onPressed: () => AutoRouter.of(context).root.pop(),
              icon: AssetIcon(AppIcons.app_bar_close, size: 20, color: AppColors.body1),
            ),
          ],
          body: Column(
            children: <Widget>[
              Expanded(
                child: PaginatedForm(
                  pageController: pageController,
                  pages: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        MnemonicSizePicker(onSizeSelected: _handleMnemonicSizeSelected),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GradientOutlinedButton.large(
                            onPressed: () async => AutoRouter.of(context).push(const CameraCaptureRoute()),
                            label: 'Generate Entropy via Camera',
                          ),
                        ),
                      ],
                    ),
                    if (vaultCreatePageState.confirmPageEnabledBool)
                      MnemonicFormGenerated(
                        mnemonicSize: vaultCreatePageState.mnemonicSize!,
                        mnemonic: vaultCreatePageState.mnemonic!,
                        vaultCreatePageCubit: vaultCreatePageCubit,
                        repeatedVaultModel: vaultCreatePageState.repeatedVaultModel,
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
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

  Future<void> _handleMnemonicSizeSelected(crypto_utils.MnemonicSize mnemonicSize) async {
    await vaultCreatePageCubit.init(mnemonicSize);
    await pageController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }
}
