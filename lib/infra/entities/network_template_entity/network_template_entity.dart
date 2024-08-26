import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

part 'network_template_entity.g.dart';

@Collection(accessor: 'networkTemplates', ignore: <String>{'props', 'stringify', 'hashCode'})
class NetworkTemplateEntity extends Equatable {
  @Index(unique: true)
  final String name;

  final String addressEncoderType;
  final String derivationPathTemplate;
  final String derivatorType;

  @Enumerated(EnumType.name)
  final CurveType curveType;

  @Enumerated(EnumType.name)
  final NetworkIconType networkIconType;

  @Enumerated(EnumType.name)
  final WalletType walletType;

  final int? predefinedNetworkTemplateId;
  final String? derivationPathName;

  const NetworkTemplateEntity({
    required this.name,
    required this.addressEncoderType,
    required this.derivationPathTemplate,
    required this.derivatorType,
    required this.curveType,
    required this.networkIconType,
    required this.walletType,
    this.predefinedNetworkTemplateId,
    this.derivationPathName,
  });

  factory NetworkTemplateEntity.fromNetworkTemplateModel(NetworkTemplateModel networkTemplateModel) {
    return NetworkTemplateEntity(
      name: networkTemplateModel.name,
      addressEncoderType: networkTemplateModel.addressEncoder.serializeType(),
      derivationPathTemplate: networkTemplateModel.derivationPathTemplate,
      derivatorType: networkTemplateModel.derivator.serializeType(),
      curveType: networkTemplateModel.curveType,
      networkIconType: networkTemplateModel.networkIconType,
      walletType: networkTemplateModel.walletType,
      predefinedNetworkTemplateId: networkTemplateModel.predefinedNetworkTemplateId,
      derivationPathName: networkTemplateModel.derivationPathName,
    );
  }

  Id get id => name.hashCode;

  @override
  List<Object?> get props => <Object?>[
        name,
        addressEncoderType,
        derivationPathTemplate,
        derivatorType,
        curveType,
        networkIconType,
        walletType,
        predefinedNetworkTemplateId,
        derivationPathName,
      ];
}
