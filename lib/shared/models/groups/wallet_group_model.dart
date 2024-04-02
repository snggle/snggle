import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:uuid/uuid.dart';

class WalletGroupModel extends AContainerModel {
  final bool pinnedBool;
  final String id;
  final String name;

  WalletGroupModel({
    required this.pinnedBool,
    required this.id,
    required this.name,
    required String parentPath,
  }) : super(containerPathModel: ContainerPathModel.fromString('${parentPath}/${id}'));

  factory WalletGroupModel.generate({required String parentPath}) {
    String groupUUID = const Uuid().v4();

    return WalletGroupModel(
      pinnedBool: false,
      id: groupUUID,
      parentPath: parentPath,
      name: groupUUID,
    );
  }

  WalletGroupModel copyWith({
    bool? pinnedBool,
    String? id,
    String? parentPath,
    String? name,
  }) {
    return WalletGroupModel(
      pinnedBool: pinnedBool ?? this.pinnedBool,
      id: id ?? this.id,
      parentPath: parentPath ?? containerPathModel.parentPath,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, id, containerPathModel, name];
}
