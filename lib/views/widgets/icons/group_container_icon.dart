import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/icons/folder_shape_border.dart';

class GroupContainerIcon extends StatelessWidget {
  final bool pinnedBool;
  final bool encryptedBool;
  final double size;
  final bool strokeBool;
  final Color? backgroundColor;
  final Widget? child;

  const GroupContainerIcon({
    required this.pinnedBool,
    required this.encryptedBool,
    required this.size,
    this.strokeBool = false,
    this.backgroundColor,
    this.child,
    super.key,
  });

  GroupContainerIcon.fromGroupModel({
    required GroupModel groupModel,
    required this.size,
    this.strokeBool = false,
    this.backgroundColor,
    this.child,
    super.key,
  })  : pinnedBool = groupModel.pinnedBool,
        encryptedBool = groupModel.encryptedBool;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: Container(
              width: size,
              height: size,
              decoration: ShapeDecoration(
                color: backgroundColor ?? const Color(0xffebfbff),
                shape: FolderShapeBorder(
                  pinnedBool: pinnedBool,
                  borderColor: AppColors.middleGrey,
                  borderWidth: 1,
                ),
              ),
            ),
          ),
          if (child != null && encryptedBool == false) Positioned.fill(child: child!),
          if (encryptedBool)
            Positioned.fill(
              child: Center(
                child: AssetIcon(AppIcons.icon_container_lock_big, size: size * 0.5),
              ),
            ),
        ],
      ),
    );
  }
}
