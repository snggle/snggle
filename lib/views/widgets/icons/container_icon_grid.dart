import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/custom/custom_flexible_grid.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid_item.dart';
import 'package:snggle/views/widgets/icons/entry_icon.dart';
import 'package:snggle/views/widgets/icons/wallet_icon.dart';

class ContainerIconGrid extends StatelessWidget {
  final List<Widget> contentPreview;
  final EdgeInsets padding;

  const ContainerIconGrid({
    required this.contentPreview,
    required this.padding,
    super.key,
  });

  factory ContainerIconGrid.fromListItemsPreview({
    required List<AListItemModel> listItemsPreview,
    required EdgeInsets padding,
    Key? key,
  }) {
    return ContainerIconGrid(
      key: key,
      padding: padding,
      contentPreview: listItemsPreview.map(_buildPreviewChild).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double innerWidth = constraints.maxWidth - padding.horizontal;
        double innerHeight = constraints.maxHeight - padding.vertical;

        double gridSize = min(innerWidth, innerHeight);
        double spacing = gridSize * 0.13;

        int slotsPerSide = _calcSlotsPerSide(contentPreview.length);
        int slotsCount = slotsPerSide * slotsPerSide;

        return Padding(
          padding: padding,
          child: Center(
            child: SizedBox(
              width: gridSize,
              height: gridSize,
              child: CustomFlexibleGrid.builder(
                columnsCount: slotsPerSide,
                verticalGap: spacing,
                horizontalGap: spacing,
                childCount: slotsCount,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= contentPreview.length) {
                    return const SizedBox.expand();
                  }

                  return contentPreview[index];
                },
              ),
            ),
          ),
        );
      },
    );
  }

  int _calcSlotsPerSide(int itemsCount) {
    if (itemsCount <= 1) {
      return 1;
    } else if (itemsCount <= 4) {
      return 2;
    } else {
      return 3;
    }
  }

  static Widget _buildPreviewChild(AListItemModel listItemModel) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
          case EntryModel entryModel:
            return EntryIcon(size: size, entryModel: entryModel);
          default:
            throw Exception('Unknown AListItemModel');
        }
      },
    );
  }
}
