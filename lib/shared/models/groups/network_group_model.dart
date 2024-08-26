import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupModel extends AListItemModel {
  final NetworkTemplateModel networkTemplateModel;
  final List<AListItemModel> listItemsPreview;

  NetworkGroupModel({
    required super.id,
    required super.pinnedBool,
    required super.encryptedBool,
    required super.filesystemPath,
    required super.name,
    required this.listItemsPreview,
    required this.networkTemplateModel,
  });

  @override
  NetworkGroupModel copyWith({
    int? id,
    bool? pinnedBool,
    bool? encryptedBool,
    FilesystemPath? filesystemPath,
    String? name,
    List<AListItemModel>? listItemsPreview,
    NetworkTemplateModel? networkTemplateModel,
  }) {
    return NetworkGroupModel(
      id: id ?? this.id,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      listItemsPreview: listItemsPreview ?? this.listItemsPreview,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      networkTemplateModel: networkTemplateModel ?? this.networkTemplateModel,
    );
  }

  @override
  String get name {
    return super.name ?? networkTemplateModel.name;
  }

  @override
  List<Object?> get props => <Object?>[id, pinnedBool, encryptedBool, listItemsPreview, filesystemPath, name, networkTemplateModel, name];
}
