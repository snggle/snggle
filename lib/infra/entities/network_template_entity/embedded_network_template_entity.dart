import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

part 'embedded_network_template_entity.g.dart';

@Embedded(ignore: <String>{'props', 'stringify', 'hashCode'})
class EmbeddedNetworkTemplateEntity extends Equatable {
  final String? name;
  final String? addressEncoderType;
  final String? derivationPathTemplate;
  final String? derivatorType;

  @Enumerated(EnumType.name)
  final CurveType? curveType;

  @Enumerated(EnumType.name)
  final NetworkIconType? networkIconType;

  @Enumerated(EnumType.name)
  final WalletType? walletType;

  final int? predefinedNetworkTemplateId;
  final String? derivationPathName;

  const EmbeddedNetworkTemplateEntity({
    this.name,
    this.addressEncoderType,
    this.derivationPathTemplate,
    this.derivatorType,
    this.curveType,
    this.networkIconType,
    this.walletType,
    this.predefinedNetworkTemplateId,
    this.derivationPathName,
  });

  factory EmbeddedNetworkTemplateEntity.fromNetworkTemplateModel(NetworkTemplateModel networkTemplateModel) {
    return EmbeddedNetworkTemplateEntity(
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
