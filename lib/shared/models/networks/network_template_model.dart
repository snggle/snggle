import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';

class NetworkTemplateModel extends Equatable {
  static final RegExp _derivationPathRegExp = RegExp(r"^(?<static_part>m(?:/(?<segment>\d+'?))+)/?(?<dynamic_part>(?:{{\w+}}.*)?)$");
  static const String _defaultDerivationPath = 'm';

  final String name;
  final String derivationPathTemplate;
  final ABlockchainAddressEncoder<ABip32PublicKey> addressEncoder;
  final ADerivator derivator;
  final CurveType curveType;
  final NetworkIconType networkIconType;
  final WalletType walletType;
  final int? predefinedNetworkTemplateId;
  final String? derivationPathName;

  const NetworkTemplateModel({
    required this.name,
    required this.derivationPathTemplate,
    required this.addressEncoder,
    required this.derivator,
    required this.curveType,
    required this.networkIconType,
    required this.walletType,
    this.predefinedNetworkTemplateId,
    this.derivationPathName,
  });

  factory NetworkTemplateModel.fromEntity(NetworkTemplateEntity networkTemplateEntity) {
    return NetworkTemplateModel(
      name: networkTemplateEntity.name,
      derivationPathTemplate: networkTemplateEntity.derivationPathTemplate,
      addressEncoder: ABlockchainAddressEncoder.fromSerializedType(networkTemplateEntity.addressEncoderType),
      derivator: ADerivator.fromSerializedType(networkTemplateEntity.derivatorType),
      curveType: networkTemplateEntity.curveType,
      networkIconType: networkTemplateEntity.networkIconType,
      walletType: networkTemplateEntity.walletType,
      predefinedNetworkTemplateId: networkTemplateEntity.predefinedNetworkTemplateId,
      derivationPathName: networkTemplateEntity.derivationPathName,
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
    int? predefinedNetworkTemplateId,
    String? derivationPathName,
  }) {
    return NetworkTemplateModel(
      name: name ?? this.name,
      derivationPathTemplate: derivationPathTemplate ?? this.derivationPathTemplate,
      addressEncoder: addressEncoder ?? this.addressEncoder,
      derivator: derivator ?? this.derivator,
      curveType: curveType ?? this.curveType,
      networkIconType: networkIconType ?? this.networkIconType,
      walletType: walletType ?? this.walletType,
      predefinedNetworkTemplateId: predefinedNetworkTemplateId ?? this.predefinedNetworkTemplateId,
      derivationPathName: derivationPathName,
    );
  }

  int get id => name.hashCode;

  String get baseDerivationPath {
    RegExpMatch? match = _derivationPathRegExp.firstMatch(derivationPathTemplate);
    String? staticPart = match?.namedGroup('static_part');
    return staticPart ?? _defaultDerivationPath;
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
        predefinedNetworkTemplateId,
        derivationPathName,
      ];
}
