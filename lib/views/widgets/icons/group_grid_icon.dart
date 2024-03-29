import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/custom/custom_flexible_grid.dart';
import 'package:snggle/views/widgets/icons/vault_container_icon.dart';
import 'package:snggle/views/widgets/icons/wallet_icon.dart';

class GroupGridIcon extends StatelessWidget {
  final List<AListItemModel> listItemsPreview;
  final EdgeInsets padding;

  const GroupGridIcon({
    required this.listItemsPreview,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CustomFlexibleGrid.builder(
        columnsCount: 3,
        verticalGap: 3,
        horizontalGap: 3,
        childCount: 9,
        itemBuilder: (BuildContext context, int index) {
          if (index >= listItemsPreview.length) {
            return const SizedBox.expand();
          }

          AListItemModel listItemModel = listItemsPreview[index];

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              switch (listItemModel) {
                case VaultModel vaultModel:
                  return VaultContainerIcon.fromVaultModel(
                    size: constraints.maxWidth,
                    vaultModel: vaultModel,
                  );
                case WalletModel walletModel:
                  return WalletIcon(
                    size: constraints.maxWidth,
                    walletModel: walletModel,
                  );
                default:
                  throw Exception('Unknown AListItemModel');
              }
            },
          );
        },
      ),
    );
  }
}
