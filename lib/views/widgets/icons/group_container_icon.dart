import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:snggle/views/widgets/icons/folder_shape_border.dart';

class GroupContainerIcon extends StatelessWidget {
  final bool pinnedBool;
  final bool encryptedBool;
  final double size;
  final bool strokeBool;
  final Widget? child;

  const GroupContainerIcon({
    required this.pinnedBool,
    required this.encryptedBool,
    required this.size,
    this.strokeBool = false,
    this.child,
    super.key,
  });

  GroupContainerIcon.fromGroupModel({
    required GroupModel groupModel,
    required this.size,
    this.strokeBool = false,
    this.child,
    super.key,
  })  : pinnedBool = groupModel.pinnedBool,
        encryptedBool = groupModel.encryptedBool;

  @override
  Widget build(BuildContext context) {
    double basePadding = size * 0.06;
    double topPadding = size * 0.13;
    double childSize = size - basePadding * 2 - topPadding;

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
                color: AppColors.body2,
                shape: FolderShapeBorder(
                  pinnedBool: pinnedBool,
                  borderColor: AppColors.middleGrey,
                  borderWidth: 1,
                ),
              ),
            ),
          ),
          if (child != null && encryptedBool == false)
            Center(
              child: Container(
                width: childSize,
                height: childSize,
                padding: EdgeInsets.only(top: topPadding, left: topPadding / 2, right: topPadding / 2),
                child: child!,
              ),
            ),
          if (encryptedBool)
            Positioned.fill(
              child: Center(
                child: GradientIcon(
                  AppIcons.lock,
                  size: size * 0.5,
                  gradient: AppColors.primaryGradient,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
