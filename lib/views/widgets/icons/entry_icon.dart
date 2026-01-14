import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class EntryIcon extends StatelessWidget {
  final double size;
  final EntryModel entryModel;
  final bool smallBool;

  const EntryIcon({
    required this.size,
    required this.entryModel,
    this.smallBool = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = AssetIcon(
      AppIcons.icon_entry_medium_background,
      size: size,
    );

    Widget backdropFilterWidget = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      ),
    );

    if (entryModel.pinnedBool) {
      double radius = size * 0.565217391;
      BorderRadius borderRadius = BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );

      iconWidget = ClipRRect(borderRadius: borderRadius, child: iconWidget);

      backdropFilterWidget = ClipRRect(borderRadius: borderRadius, child: backdropFilterWidget);
    } else {
      iconWidget = ClipOval(child: iconWidget);
      backdropFilterWidget = ClipOval(child: backdropFilterWidget);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          iconWidget,
          if (entryModel.encryptedBool) backdropFilterWidget,
          if (entryModel.encryptedBool)
            Center(
              child: AssetIcon(
                smallBool ? AppIcons.icon_container_lock_small : AppIcons.icon_container_lock_big,
                size: size * 0.5,
              ),
            ),
        ],
      ),
    );
  }
}
