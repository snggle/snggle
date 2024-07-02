import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/views/widgets/icons/group_grid_icon.dart';
import 'package:snggle/views/widgets/icons/vault_container_icon.dart';

class NetworkGroupIcon extends StatelessWidget {
  final NetworkGroupModel networkGroupModel;
  final double size;

  const NetworkGroupIcon({
    required this.networkGroupModel,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VaultContainerIcon(
      pinnedBool: networkGroupModel.pinnedBool,
      encryptedBool: networkGroupModel.encryptedBool,
      size: size,
      child: GroupGridIcon(
        padding: EdgeInsets.all(size * 0.134615385),
        listItemsPreview: networkGroupModel.listItemsPreview,
      ),
    );
  }
}
