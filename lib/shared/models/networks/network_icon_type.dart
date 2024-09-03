import 'package:snggle/config/app_icons.dart';

enum NetworkIconType {
  bitcoin(
    containerIcon: AppIcons.icon_container_network_bitcoin,
    largeIcon: AppIcons.network_bitcoin_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_bitcoin,
    networkTemplatesListIcon: AppIcons.network_templates_list_bitcoin,
  ),
  cosmos(
    containerIcon: AppIcons.icon_container_network_cosmos,
    largeIcon: AppIcons.network_cosmos_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_cosmos,
    networkTemplatesListIcon: AppIcons.network_templates_list_cosmos,
  ),
  ethereum(
    containerIcon: AppIcons.icon_container_network_ethereum,
    largeIcon: AppIcons.network_ethereum_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_ethereum,
    networkTemplatesListIcon: AppIcons.network_templates_list_ethereum,
  );

  final AssetIconData containerIcon;
  final AssetIconData largeIcon;
  final AssetIconData horizontalTileIcon;
  final AssetIconData networkTemplatesListIcon;

  const NetworkIconType({
    required this.containerIcon,
    required this.largeIcon,
    required this.horizontalTileIcon,
    required this.networkTemplatesListIcon,
  });
}
