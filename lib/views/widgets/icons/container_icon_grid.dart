import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/custom/custom_flexible_grid.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid_item.dart';
import 'package:snggle/views/widgets/icons/wallet_icon.dart';

class ContainerIconGrid extends StatelessWidget {
  final List<AListItemModel> listItemsPreview;
  final EdgeInsets padding;

  const ContainerIconGrid({
    required this.listItemsPreview,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double innerWidth = constraints.maxWidth - padding.horizontal;
        double innerHeight = constraints.maxHeight - padding.vertical;

        double gridSize = min(innerWidth, innerHeight);
        double spacing = gridSize * 0.13;

        return Padding(
          padding: padding,
          child: Center(
            child: SizedBox(
              width: gridSize,
              height: gridSize,
              child: CustomFlexibleGrid.builder(
                columnsCount: 3,
                verticalGap: spacing,
                horizontalGap: spacing,
                childCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= listItemsPreview.length) {
                    return const SizedBox.expand();
                  }

                  AListItemModel listItemModel = listItemsPreview[index];
                  double size = constraints.maxWidth;

                  switch (listItemModel) {
                    case VaultModel vaultModel:
                      return ContainerIconGridItem.fromVaultModel(vaultModel: vaultModel, size: size);
                    case NetworkGroupModel networkGroupModel:
                      return ContainerIconGridItem.fromNetworkGroupModel(networkGroupModel: networkGroupModel, size: size);
                    case GroupModel groupModel:
                      return ContainerIconGridItem.fromGroupModel(groupModel: groupModel, size: size);
                    case WalletModel walletModel:
                      return WalletIcon(size: size, walletModel: walletModel, smallBool: true);
                    default:
                      throw Exception('Unknown AListItemModel');
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
