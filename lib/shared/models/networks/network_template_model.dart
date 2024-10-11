import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';

class NetworkTemplateModel extends Equatable {
  final String name;
  final String derivationPathTemplate;
  final ABlockchainAddressEncoder<ABip32PublicKey> addressEncoder;
  final ADerivator derivator;
  final CurveType curveType;
  final NetworkIconType networkIconType;
  final WalletType walletType;

  const NetworkTemplateModel({
    required this.name,
    required this.derivationPathTemplate,
    required this.addressEncoder,
    required this.derivator,
    required this.curveType,
    required this.networkIconType,
    required this.walletType,
  });

  factory NetworkTemplateModel.fromEntity(EmbeddedNetworkTemplateEntity embeddedNetworkTemplateEntity) {
    return NetworkTemplateModel(
      name: embeddedNetworkTemplateEntity.name!,
      derivationPathTemplate: embeddedNetworkTemplateEntity.derivationPathTemplate!,
      addressEncoder: ABlockchainAddressEncoder.fromSerializedType(embeddedNetworkTemplateEntity.addressEncoderType!),
      derivator: ADerivator.fromSerializedType(embeddedNetworkTemplateEntity.derivatorType!),
      curveType: embeddedNetworkTemplateEntity.curveType!,
      networkIconType: embeddedNetworkTemplateEntity.networkIconType!,
      walletType: embeddedNetworkTemplateEntity.walletType!,
    );
  }

  NetworkTemplateModel copyWith({
    String? name,
    String? derivationPathTemplate,
    ABlockchainAddressEncoder<ABip32PublicKey>? addressEncoder,
    ADerivator? derivator,
    CurveType? curveType,
    NetworkIconType? networkIconType,
    WalletType? walletType,
  }) {
    return NetworkTemplateModel(
      name: name ?? this.name,
      derivationPathTemplate: derivationPathTemplate ?? this.derivationPathTemplate,
      addressEncoder: addressEncoder ?? this.addressEncoder,
      derivator: derivator ?? this.derivator,
      curveType: curveType ?? this.curveType,
      networkIconType: networkIconType ?? this.networkIconType,
      walletType: walletType ?? this.walletType,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        derivationPathTemplate,
        addressEncoder.serializeType(),
        derivator.serializeType(),
        curveType.name,
        networkIconType.name,
        walletType.name,
      ];
}
