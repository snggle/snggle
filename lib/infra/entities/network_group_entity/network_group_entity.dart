import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'network_group_entity.g.dart';

@Collection(accessor: 'networkGroups', ignore: <String>{'props', 'stringify', 'hashCode'})
class NetworkGroupEntity extends Equatable {
  final Id id;
  final bool pinnedBool;
  final bool encryptedBool;
  final String name;
  final String networkId;
  @Index()
  final String filesystemPathString;

  const NetworkGroupEntity({
    required this.id,
    required this.pinnedBool,
    required this.encryptedBool,
    required this.name,
    required this.networkId,
    required this.filesystemPathString,
  });

  factory NetworkGroupEntity.fromNetworkGroupModel(NetworkGroupModel networkGroupModel) {
    return NetworkGroupEntity(
      id: networkGroupModel.id,
      pinnedBool: networkGroupModel.pinnedBool,
      encryptedBool: networkGroupModel.encryptedBool,
      name: networkGroupModel.name,
      networkId: networkGroupModel.networkConfigModel.id,
      filesystemPathString: networkGroupModel.filesystemPath.fullPath,
    );
  }

  NetworkGroupEntity copyWith({
    Id? id,
    bool? pinnedBool,
    bool? encryptedBool,
    String? name,
    String? networkId,
    String? filesystemPathString,
  }) {
    return NetworkGroupEntity(
      id: id ?? this.id,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      name: name ?? this.name,
      networkId: networkId ?? this.networkId,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object>[id, pinnedBool, encryptedBool, name, networkId, filesystemPathString];
}
