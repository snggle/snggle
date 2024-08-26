import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';

enum NetworkIconType {
  bitcoin(iconData: AppIcons.token_eth, thinIconData: AppIcons.eth_thin),
  cosmos(iconData: AppIcons.token_eth, thinIconData: AppIcons.cosmos_thin),
  ethereum(iconData: AppIcons.token_eth, thinIconData: AppIcons.eth_thin);

  final IconData iconData;
  final IconData thinIconData;

  const NetworkIconType({
    required this.iconData,
    required this.thinIconData,
  });
}
