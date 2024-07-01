import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/icons/group_icon.dart';
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
    if (listItemModel is VaultModel) {
      return VaultIcon(size: size, vaultModel: listItemModel as VaultModel);
    } else if (listItemModel is WalletModel) {
      return WalletIcon(size: size, walletModel: listItemModel as WalletModel);
    } else if (listItemModel is GroupModel) {
      return GroupIcon.fromGroupModel(size: size, groupModel: listItemModel as GroupModel);
    }
    return const SizedBox();
  }
}
