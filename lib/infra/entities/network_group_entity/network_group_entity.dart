import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'network_group_entity.g.dart';

@Collection(accessor: 'networkGroups', ignore: <String>{'props', 'stringify', 'hashCode', 'networkTemplateEntity'})
class NetworkGroupEntity extends Equatable {
  final Id id;
  final bool encryptedBool;
  final bool pinnedBool;
  @Index()
  final String filesystemPathString;
  final String name;
  final EmbeddedNetworkTemplateEntity embeddedNetworkTemplate;

  const NetworkGroupEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.filesystemPathString,
    required this.name,
    required this.embeddedNetworkTemplate,
  });

  factory NetworkGroupEntity.fromNetworkGroupModel(NetworkGroupModel networkGroupModel) {
    return NetworkGroupEntity(
      id: networkGroupModel.id,
      encryptedBool: networkGroupModel.encryptedBool,
      pinnedBool: networkGroupModel.pinnedBool,
      embeddedNetworkTemplate: EmbeddedNetworkTemplateEntity.fromNetworkTemplateModel(networkGroupModel.networkTemplateModel),
      filesystemPathString: networkGroupModel.filesystemPath.fullPath,
      name: networkGroupModel.name,
    );
  }

  NetworkTemplateEntity get networkTemplateEntity {
    return NetworkTemplateEntity(
      name: embeddedNetworkTemplate.name!,
      addressEncoderType: embeddedNetworkTemplate.addressEncoderType!,
      derivationPathTemplate: embeddedNetworkTemplate.derivationPathTemplate!,
      derivatorType: embeddedNetworkTemplate.derivatorType!,
      curveType: embeddedNetworkTemplate.curveType!,
      networkIconType: embeddedNetworkTemplate.networkIconType!,
      walletType: embeddedNetworkTemplate.walletType!,
      predefinedNetworkTemplateId: embeddedNetworkTemplate.predefinedNetworkTemplateId,
      derivationPathName: embeddedNetworkTemplate.derivationPathName,
    );
  }

  NetworkGroupEntity copyWith({
    Id? id,
    bool? encryptedBool,
    bool? pinnedBool,
    String? filesystemPathString,
    String? name,
    EmbeddedNetworkTemplateEntity? embeddedNetworkTemplate,
  }) {
    return NetworkGroupEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
      embeddedNetworkTemplate: embeddedNetworkTemplate ?? this.embeddedNetworkTemplate,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object>[id, encryptedBool, pinnedBool, embeddedNetworkTemplate, filesystemPathString, name];
}
