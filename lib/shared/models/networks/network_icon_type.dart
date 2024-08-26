import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';

enum NetworkIconType {
  bitcoin(AppIcons.token_eth),
  cosmos(AppIcons.token_eth),
  ethereum(AppIcons.token_eth);

  final IconData iconData;

  const NetworkIconType(this.iconData);
}
