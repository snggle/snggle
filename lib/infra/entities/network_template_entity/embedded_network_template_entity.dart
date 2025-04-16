import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/wallet_create/derivation_path_index_extractor/derivation_path_types.dart';
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
  final DerivationPathType? derivationPathType;

  @Enumerated(EnumType.name)
  final CurveType? curveType;

  @Enumerated(EnumType.name)
  final NetworkIconType? networkIconType;

  @Enumerated(EnumType.name)
  final WalletType? walletType;

  const EmbeddedNetworkTemplateEntity({
    this.name,
    this.addressEncoderType,
    this.derivationPathTemplate,
    this.derivatorType,
    this.derivationPathType,
    this.curveType,
    this.networkIconType,
    this.walletType,
  });

  factory EmbeddedNetworkTemplateEntity.fromNetworkTemplateModel(NetworkTemplateModel networkTemplateModel) {
    return EmbeddedNetworkTemplateEntity(
      name: networkTemplateModel.name,
      addressEncoderType: networkTemplateModel.addressEncoder.serializeType(),
      derivationPathTemplate: networkTemplateModel.derivationPathTemplate,
      derivatorType: networkTemplateModel.derivator.serializeType(),
      derivationPathType: networkTemplateModel.derivationPathIndexExtractor.derivationPathType,
      curveType: networkTemplateModel.curveType,
      networkIconType: networkTemplateModel.networkIconType,
      walletType: networkTemplateModel.walletType,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        addressEncoderType,
        derivationPathTemplate,
        derivatorType,
        derivationPathType,
        curveType,
        networkIconType,
        walletType,
      ];
}
