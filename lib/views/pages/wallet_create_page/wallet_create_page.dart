import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_cubit.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/networks/network_type.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/formatters/legacy_derivation_path_input_formatter.dart';
import 'package:snggle/shared/utils/string_utils.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_horizontal.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class WalletCreatePage extends StatefulWidget {
  final VaultModel vaultModel;
  final FilesystemPath parentFilesystemPath;
  final NetworkGroupModel networkGroupModel;

  const WalletCreatePage({
    required this.vaultModel,
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
    networkGroupModel: widget.networkGroupModel,
    parentFilesystemPath: widget.parentFilesystemPath,
  );

  @override
  void initState() {
    super.initState();
    walletCreatePageCubit.init(defaultWalletName: 'Wallet');
  }

  @override
  void dispose() {
    scrollController.dispose();
    walletCreatePageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String baseDerivationPath = '${widget.networkGroupModel.networkTemplateModel.baseDerivationPath}/';
    bool networkIsSolanaBool = widget.networkGroupModel.networkTemplateModel.networkType == NetworkType.solana;
    String? suffix = networkIsSolanaBool ? "'/0'" : null;

    TextScaler textScaler = MediaQuery.textScalerOf(context);
    double prefixWidth = StringUtils.getTextSize(baseDerivationPath, theme.textTheme.bodyMedium!, textScaler: textScaler).width;
    double? suffixWidth = networkIsSolanaBool ? StringUtils.getTextSize(suffix!, theme.textTheme.bodyMedium!, textScaler: textScaler).width : null;

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
                onTap: _finishButtonEnabledBool ? _createNewWallet : null,
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
                      textStyle: theme.textTheme.labelMedium,
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
                  if (walletCreatePageCubit.state.walletNameEmptyBool == true)
                    const ErrorMessageListTile(
                      message: 'Wallet name cannot be empty',
                    ),
                  LabelWrapperVertical(
                    label: 'Derivation Path',
                    child: CustomTextField(
                      textEditingController: walletCreatePageCubit.derivationPathTextEditingController,
                      inputBorder: InputBorder.none,
                      keyboardType: TextInputType.number,
                      prefixWidgetConstraints: BoxConstraints(minWidth: 0, minHeight: 0, maxWidth: prefixWidth),
                      prefixWidget: Text(baseDerivationPath, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.middleGrey)),
                      suffixWidgetConstraints: networkIsSolanaBool ? BoxConstraints(minWidth: 0, minHeight: 0, maxWidth: suffixWidth!) : null,
                      suffixWidget:
                          networkIsSolanaBool ? Text(suffix!, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.middleGrey)) : null,
                      dynamicSuffixBool: true,
                      padding: EdgeInsets.zero,
                      inputFormatters: <TextInputFormatter>[
                        LegacyDerivationPathInputFormatter(),
                      ],
                    ),
                  ),
                  if (walletCreatePageState.emptyDerivationPathBool == true)
                    const ErrorMessageListTile(
                      message: 'Derivation path cannot be empty',
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

  bool get _finishButtonEnabledBool =>
      walletCreatePageCubit.state.walletNameEmptyBool == false &&
      walletCreatePageCubit.state.emptyDerivationPathBool == false &&
      walletCreatePageCubit.state.walletExistsErrorBool == false;

  Future<void> _createNewWallet() async {
    try {
      await CustomLoadingDialog.show<WalletModel?>(
        context: context,
        title: 'Saving...',
        futureFunction: walletCreatePageCubit.createNewWallet,
        onSuccess: (WalletModel? walletModel) async {
          if (mounted == false) {
            return;
          }

          if (walletModel != null) {
            await AutoRouter.of(context).pop();
          }
        },
      );
    } on InvalidMasterKeyException {
      if (mounted == false) {
        return;
      }

      unawaited(MasterKeyDialog.show(context));
    }
  }
}
