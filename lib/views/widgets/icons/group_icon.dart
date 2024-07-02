import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/views/widgets/icons/group_container_icon.dart';
import 'package:snggle/views/widgets/icons/group_grid_icon.dart';

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
      child: GroupGridIcon(
        gap: 1.5,
        padding: EdgeInsets.zero,
        listItemsPreview: listItemsPreview,
      ),
    );
  }
}
