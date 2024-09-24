import 'package:snggle/config/app_icons/app_icons.dart';

enum NetworkIconType {
  bitcoin(
    listSmallIcon: AppIcons.icon_container_network_bitcoin,
    largeIcon: AppIcons.network_bitcoin_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_bitcoin,
  ),
  cosmos(
    listSmallIcon: AppIcons.icon_container_network_cosmos,
    largeIcon: AppIcons.network_cosmos_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_cosmos,
  ),
  ethereum(
    listSmallIcon: AppIcons.icon_container_network_ethereum,
    largeIcon: AppIcons.network_ethereum_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_ethereum,
  ),
  unknown(
    listSmallIcon: AppIcons.icon_container_network_unknown,
    largeIcon: AppIcons.network_unknown_large,
    horizontalTileIcon: AppIcons.horizontal_tile_network_unknown,
  );

  final AssetIconData listSmallIcon;
  final AssetIconData largeIcon;
  final AssetIconData horizontalTileIcon;

  const NetworkIconType({
    required this.listSmallIcon,
    required this.largeIcon,
    required this.horizontalTileIcon,
  });
}
