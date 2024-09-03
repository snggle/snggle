import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid.dart';
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
      child: ContainerIconGrid(
        padding: EdgeInsets.all(size * 0.14),
        listItemsPreview: networkGroupModel.listItemsPreview,
      ),
    );
  }
}
