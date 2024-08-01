import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupModel extends AListItemModel {
  final NetworkConfigModel networkConfigModel;
  final List<AListItemModel> listItemsPreview;
  final String _name;

  NetworkGroupModel({
    required super.id,
    required super.pinnedBool,
    required super.encryptedBool,
    required super.filesystemPath,
    required this.listItemsPreview,
    required this.networkConfigModel,
  }) : _name = networkConfigModel.name;

  @override
  NetworkGroupModel copyWith({
    int? id,
    bool? pinnedBool,
    bool? encryptedBool,
    FilesystemPath? filesystemPath,
    List<AListItemModel>? listItemsPreview,
    NetworkConfigModel? networkConfigModel,
  }) {
    return NetworkGroupModel(
      id: id ?? this.id,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      listItemsPreview: listItemsPreview ?? this.listItemsPreview,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      networkConfigModel: networkConfigModel ?? this.networkConfigModel,
    );
  }

  @override
  String get name => _name;

  @override
  List<Object?> get props => <Object?>[id, pinnedBool, encryptedBool, listItemsPreview, filesystemPath, networkConfigModel, name];
}
