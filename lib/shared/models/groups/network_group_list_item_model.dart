import 'package:snggle/shared/models/groups/group_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';

class NetworkGroupListItemModel extends GroupListItemModel {
  final NetworkConfigModel networkConfigModel;

  NetworkGroupListItemModel({
    required this.networkConfigModel,
    required super.encryptedBool,
    required super.walletsPreview,
    required super.groupModel,
  }) : super(pinnedBool: groupModel.pinnedBool);

  @override
  void setPinned({required bool pinnedBool}) {
    super.setPinned(pinnedBool: pinnedBool);
    groupModel = groupModel.copyWith(pinnedBool: pinnedBool);
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, networkConfigModel, groupModel, walletsPreview];
}
