// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@Entity()
class NetworkGroupEntity extends Equatable {
  @Id()
  int id;
  final bool encryptedBool;
  final bool pinnedBool;
  @Index()
  final String filesystemPathString;
  final String name;
  final ToOne<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateRelation = ToOne<EmbeddedNetworkTemplateEntity>();

  NetworkGroupEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.filesystemPathString,
    required this.name,
    EmbeddedNetworkTemplateEntity? embeddedNetworkTemplate,
  }) {
    embeddedNetworkTemplateRelation.target = embeddedNetworkTemplate;
  }

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

  NetworkGroupEntity copyWith({
    int? id,
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

  @Transient()
  EmbeddedNetworkTemplateEntity? get embeddedNetworkTemplate {
    return embeddedNetworkTemplateRelation.target;
  }

  set embeddedNetworkTemplate(EmbeddedNetworkTemplateEntity? embeddedNetworkTemplateEntity) {
    embeddedNetworkTemplateRelation.target = embeddedNetworkTemplateEntity;
  }

  @Transient()
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, embeddedNetworkTemplate, filesystemPathString, name];
}
