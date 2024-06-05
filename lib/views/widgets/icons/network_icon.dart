import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:snggle/views/widgets/icons/vault_container_icon.dart';

class NetworkIcon extends StatelessWidget {
  final NetworkGroupModel networkGroupModel;
  final double size;

  const NetworkIcon({
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
      child: Center(
        child: GradientIcon(
          networkGroupModel.networkConfigModel.iconData,
          size: size * 0.6,
          gradient: AppColors.primaryGradient,
        ),
      ),
    );
  }
}
