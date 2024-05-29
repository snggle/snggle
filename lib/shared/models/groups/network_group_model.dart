import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/group_type.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupModel extends GroupModel {
  final NetworkConfigModel networkConfigModel;

  NetworkGroupModel({
    required super.pinnedBool,
    required super.encryptedBool,
    required super.uuid,
    required super.filesystemPath,
    required super.listItemsPreview,
    required this.networkConfigModel,
  }) : super(name: networkConfigModel.name);

  @override
  NetworkGroupModel copyWith({
    bool? pinnedBool,
    bool? encryptedBool,
    String? uuid,
    FilesystemPath? filesystemPath,
    List<AListItemModel>? listItemsPreview,
    NetworkConfigModel? networkConfigModel,
    String? name,
  }) {
    return NetworkGroupModel(
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      uuid: uuid ?? this.uuid,
      listItemsPreview: listItemsPreview ?? this.listItemsPreview,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      networkConfigModel: networkConfigModel ?? this.networkConfigModel,
    );
  }

  @override
  GroupType get groupType => GroupType.network;

  @override
  List<Object?> get props => <Object?>[pinnedBool, encryptedBool, uuid, listItemsPreview, filesystemPath, networkConfigModel, name];
}
