import 'package:snggle/config/app_icons/app_icons.dart';

enum NetworkIconType {
  bitcoin(
    listSmallIcon: AppIcons.icon_container_network_bitcoin,
    horizontalTileIcon: AppIcons.horizontal_tile_network_bitcoin,
  ),
  cosmos(
    listSmallIcon: AppIcons.icon_container_network_cosmos,
    horizontalTileIcon: AppIcons.horizontal_tile_network_cosmos,
  ),
  ethereum(
    listSmallIcon: AppIcons.icon_container_network_ethereum,
    horizontalTileIcon: AppIcons.horizontal_tile_network_ethereum,
  ),
  unknown(
    listSmallIcon: AppIcons.icon_container_network_unknown,
    horizontalTileIcon: AppIcons.horizontal_tile_network_unknown,
  );

  final AssetIconData listSmallIcon;
  final AssetIconData horizontalTileIcon;

  const NetworkIconType({
    required this.listSmallIcon,
    required this.horizontalTileIcon,
  });
}
