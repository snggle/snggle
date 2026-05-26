import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/networks/network_type.dart';

part 'embedded_network_template_entity.g.dart';

@Embedded(ignore: <String>{'props', 'stringify', 'hashCode'})
class EmbeddedNetworkTemplateEntity extends Equatable {
  /// Isar requires all fields in embedded objects not to have required parameters.
  /// Any attempts at adding required parameters will result in the following error when running build_runner:
  /// "Constructors of embedded objects must not have required parameters"
  ///
  /// There are 2 possible solutions to this issue:
  /// 1. Enabling null fields
  /// 2. Assigning default values
  /// Assigning correct default values is impossible when we support more than 1 network.
  /// For this reason, we enable null fields everywhere in this class.
  final String? name;
  final String? addressEncoderType;
  final String? derivationPathTemplate;
  final String? derivatorType;

  @Enumerated(EnumType.name)
  final CurveType? curveType;

  @Enumerated(EnumType.name)
  final NetworkIconType? networkIconType;

  @Enumerated(EnumType.name)
  final NetworkType? networkType;

  @Enumerated(EnumType.name)
  final WalletType? walletType;

  const EmbeddedNetworkTemplateEntity({
    this.name,
    this.addressEncoderType,
    this.derivationPathTemplate,
    this.derivatorType,
    this.curveType,
    this.networkIconType,
    this.networkType,
    this.walletType,
  });

  factory EmbeddedNetworkTemplateEntity.fromNetworkTemplateModel(NetworkTemplateModel networkTemplateModel) {
    return EmbeddedNetworkTemplateEntity(
      name: networkTemplateModel.name,
      addressEncoderType: networkTemplateModel.addressEncoder.serializeType(),
      derivationPathTemplate: networkTemplateModel.derivationPathTemplate,
      derivatorType: networkTemplateModel.derivator.serializeType(),
      curveType: networkTemplateModel.curveType,
      networkIconType: networkTemplateModel.networkIconType,
      networkType: networkTemplateModel.networkType,
      walletType: networkTemplateModel.walletType,
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
    networkType,
    walletType,
  ];
}
