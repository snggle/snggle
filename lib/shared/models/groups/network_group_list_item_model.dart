import 'package:snggle/shared/models/groups/group_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';

class NetworkGroupListItemModel extends GroupListItemModel {
  final NetworkConfigModel networkConfigModel;

  NetworkGroupListItemModel({
    required this.networkConfigModel,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.containerPathModel,
    required super.walletsPreview,
  });

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, containerPathModel, networkConfigModel, walletsPreview];
}
