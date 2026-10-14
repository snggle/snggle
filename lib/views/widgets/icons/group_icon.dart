import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid.dart';
import 'package:snggle/views/widgets/icons/group_container_icon.dart';

class GroupIcon extends StatelessWidget {
  final bool pinnedBool;
  final bool encryptedBool;
  final double size;
  final List<AListItemModel> listItemsPreview;

  const GroupIcon({
    required this.pinnedBool,
    required this.encryptedBool,
    required this.size,
    required this.listItemsPreview,
    super.key,
  });

  GroupIcon.fromGroupModel({
    required GroupModel groupModel,
    required this.size,
    super.key,
  })  : pinnedBool = groupModel.pinnedBool,
        encryptedBool = groupModel.encryptedBool,
        listItemsPreview = groupModel.listItemsPreview;

  @override
  Widget build(BuildContext context) {
    return GroupContainerIcon(
      pinnedBool: pinnedBool,
      encryptedBool: encryptedBool,
      size: size,
      child: ContainerIconGrid(
        padding: EdgeInsets.only(left: size * 0.14, right: size * 0.14, top: size * 0.23, bottom: size * 0.096),
        listItemsPreview: listItemsPreview,
      ),
    );
  }
}
