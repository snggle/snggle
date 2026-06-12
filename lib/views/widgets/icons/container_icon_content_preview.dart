import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid_item.dart';
import 'package:snggle/views/widgets/icons/entry_icon.dart';
import 'package:snggle/views/widgets/icons/wallet_icon.dart';

class ContainerIconContentPreview extends StatelessWidget {
  final AListItemModel listItemModel;

  const ContainerIconContentPreview({
    required this.listItemModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
