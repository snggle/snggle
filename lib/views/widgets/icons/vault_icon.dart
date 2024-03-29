import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/widgets/icons/group_grid_icon.dart';
import 'package:snggle/views/widgets/icons/vault_container_icon.dart';

class VaultIcon extends StatelessWidget {
  final double size;
  final VaultModel vaultModel;

  const VaultIcon({
    required this.size,
    required this.vaultModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VaultContainerIcon.fromVaultModel(
      size: size,
      vaultModel: vaultModel,
      child: GroupGridIcon(
        padding: EdgeInsets.all(size * 0.15),
        listItemsPreview: vaultModel.listItemsPreview,
      ),
    );
  }
}
