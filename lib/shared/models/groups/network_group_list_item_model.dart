import 'package:snggle/bloc/network_groups_page/network_groups_page_cubit.dart';
import 'package:snggle/shared/models/groups/group_list_item_model.dart';

class NetworkGroupListItemModel extends GroupListItemModel {
  final NetworkConfigModel networkConfigModel;

  const NetworkGroupListItemModel({
    required this.networkConfigModel,
    required super.encryptedBool,
    required super.walletsPreview,
    required super.containerPathModel,
  });

  @override
  List<Object?> get props => <Object?>[encryptedBool, networkConfigModel, walletsPreview];
}
