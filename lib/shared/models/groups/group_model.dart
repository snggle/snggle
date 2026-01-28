import 'package:isar/isar.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupModel extends AListItemModel {
  final List<AListItemModel> listItemsPreview;
  final String _name;
  final int _networkId;
  final int _localId;

  GroupModel({
    required super.id,
    required super.pinnedBool,
    required super.encryptedBool,
    required super.filesystemPath,
    required this.listItemsPreview,
    required String name,
    int networkId = -1,
    int localId = 0,
  })  : _name = name,
        _networkId = networkId,
        _localId = localId;

  @override
  GroupModel copyWith({
    int? id,
    bool? pinnedBool,
    bool? encryptedBool,
    List<AListItemModel>? listItemsPreview,
    FilesystemPath? filesystemPath,
    String? name,
    int? vaultGroupId,
    int? networkId,
    int? localId,
  }) {
    return GroupModel(
      id: id ?? this.id,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      listItemsPreview: listItemsPreview ?? this.listItemsPreview,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      networkId: networkId ?? this.networkId,
      localId: localId ?? this.localId,
    );
  }

  @override
  String get name => _name;

  @override
  int get networkId => _networkId;

  int get localId => _localId;

  @override
  String get defaultItemName => '${listItemsPreview.first.defaultItemName} Group';

  bool get hasSingleItem => listItemsPreview.length == 1;

  @override
  List<Object?> get props => <Object?>[id, pinnedBool, encryptedBool, listItemsPreview, filesystemPath, name, networkId, localId];
}
