import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_cubit.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/formatters/legacy_derivation_path_input_formatter.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_horizontal.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class WalletCreatePage extends StatefulWidget {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final FilesystemPath parentFilesystemPath;
  final NetworkGroupModel networkGroupModel;

  const WalletCreatePage({
    required this.vaultModel,
    required this.vaultPasswordModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletCreatePageState();
}

class _WalletCreatePageState extends State<WalletCreatePage> {
  final ScrollController scrollController = ScrollController();

  late final WalletCreatePageCubit walletCreatePageCubit = WalletCreatePageCubit(
    vaultModel: widget.vaultModel,
    vaultPasswordModel: widget.vaultPasswordModel,
    networkGroupModel: widget.networkGroupModel,
    parentFilesystemPath: widget.parentFilesystemPath,
  );

  @override
  void initState() {
    super.initState();
    walletCreatePageCubit.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    walletCreatePageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<WalletCreatePageCubit, WalletCreatePageState>(
      bloc: walletCreatePageCubit,
      builder: (BuildContext context, WalletCreatePageState walletCreatePageState) {
        return CustomScaffold(
          title: 'CREATE WALLET',
          body: ScrollableLayout(
            scrollController: scrollController,
            tooltipItems: <Widget>[
              BottomTooltipItem(
                label: 'Finish',
                assetIconData: AppIcons.menu_save,
                onTap: walletCreatePageState.walletExistsErrorBool ? null : _createNewWallet,
              ),
            ],
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  LabelWrapperHorizontal(
                    padding: EdgeInsets.zero,
                    label: 'Network Type',
                    child: GradientText(
                      widget.networkGroupModel.networkTemplateModel.name,
                      gradient: AppColors.primaryGradient,
                      textStyle: textTheme.labelMedium,
                    ),
                  ),
                  LabelWrapperVertical.textField(
                    label: 'Name',
                    child: CustomTextField(
                      textEditingController: walletCreatePageCubit.nameTextEditingController,
                      inputBorder: InputBorder.none,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  LabelWrapperVertical.textField(
                    label: 'Derivation Path',
                    child: CustomTextField(
                      textEditingController: walletCreatePageCubit.derivationPathTextEditingController,
                      inputBorder: InputBorder.none,
                      keyboardType: TextInputType.text,
                      prefixText: '${widget.networkGroupModel.networkTemplateModel.baseDerivationPath}/',
                      inputFormatters: <TextInputFormatter>[
                        LegacyDerivationPathInputFormatter(),
                      ],
                    ),
                  ),
                  if (walletCreatePageState.walletExistsErrorBool == true)
                    const ErrorMessageListTile(
                      message: 'Wallet with this derivation path already exists',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _createNewWallet() async {
    await CustomLoadingDialog.show<WalletModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: walletCreatePageCubit.createNewWallet,
      onSuccess: (WalletModel? walletModel) async {
        if (walletModel != null) {
          await AutoRouter.of(context).pop();
        }
      },
    );
  }
}
