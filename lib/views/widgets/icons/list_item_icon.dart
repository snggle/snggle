import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/icons/group_icon.dart';
import 'package:snggle/views/widgets/icons/network_group_icon.dart';
import 'package:snggle/views/widgets/icons/vault_icon.dart';
import 'package:snggle/views/widgets/icons/wallet_icon.dart';

class ListItemIcon extends StatelessWidget {
  final AListItemModel listItemModel;
  final Size size;

  const ListItemIcon({
    required this.listItemModel,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double size = min(this.size.width, this.size.height);
    switch(listItemModel) {
      case VaultModel vaultModel:
        return VaultIcon(size: size, vaultModel: vaultModel);
      case WalletModel walletModel:
        return WalletIcon(size: size, walletModel: walletModel);
      case NetworkGroupModel networkGroupModel:
        return NetworkGroupIcon(size: size, networkGroupModel: networkGroupModel);
      case GroupModel groupModel:
        return GroupIcon.fromGroupModel(size: size, groupModel: groupModel);
      default:
        return const SizedBox();
    }
  }
}
