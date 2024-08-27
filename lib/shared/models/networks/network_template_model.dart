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

  Future<AHDWallet> deriveWallet(Mnemonic mnemonic, String derivationPathString) async {
    switch (walletType) {
      case WalletType.legacy:
        return _deriveLegacyHDWallet(mnemonic, derivationPathString);
    }
  }

  String getCustomizableDerivationPath({
    int accountIndex = 0,
    int changeIndex = 0,
    int addressIndex = 0,
  }) {
    RegExpMatch? match = _derivationPathRegExp.firstMatch(derivationPathTemplate);
    String? dynamicPart = match?.namedGroup('dynamic_part');

    String customizableDerivationPath = dynamicPart ?? '';
    if (customizableDerivationPath.contains('{{i}}') == false) {
      customizableDerivationPath += '{{i}}';
    }
    customizableDerivationPath = customizableDerivationPath.replaceAll('{{a}}', '$accountIndex');
    customizableDerivationPath = customizableDerivationPath.replaceAll('{{y}}', '$changeIndex');
    customizableDerivationPath = customizableDerivationPath.replaceAll('{{i}}', '$addressIndex');

    return customizableDerivationPath;
  }

  String mergeCustomDerivationPath(String customDerivationPath) {
    String updatedCustomDerivationPath = customDerivationPath;
    if (updatedCustomDerivationPath.startsWith('/')) {
      updatedCustomDerivationPath = updatedCustomDerivationPath.substring(1);
    }
    if (updatedCustomDerivationPath.endsWith('/')) {
      updatedCustomDerivationPath = updatedCustomDerivationPath.substring(0, customDerivationPath.length - 1);
    }

    if (customDerivationPath.isEmpty) {
      return baseDerivationPath;
    } else {
      return '$baseDerivationPath/$updatedCustomDerivationPath';
    }
  }

  String get baseDerivationPath {
    RegExpMatch? match = _derivationPathRegExp.firstMatch(derivationPathTemplate);
    String? staticPart = match?.namedGroup('static_part');
    return staticPart ?? _defaultDerivationPath;
  }

  Future<LegacyHDWallet> _deriveLegacyHDWallet(Mnemonic mnemonic, String derivationPathString) async {
    LegacyDerivationPath legacyDerivationPath = LegacyDerivationPath.parse(derivationPathString);
    LegacyWalletConfig<ABip32PrivateKey> legacyWalletConfig = LegacyWalletConfig<ABip32PrivateKey>(
      derivator: derivator as ALegacyDerivator<ABip32PrivateKey>,
      addressEncoder: addressEncoder,
      curveType: curveType,
    );
    return LegacyHDWallet.fromMnemonic(
      derivationPath: legacyDerivationPath,
      mnemonic: mnemonic,
      walletConfig: legacyWalletConfig,
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
        predefinedNetworkTemplateId,
        derivationPathName,
      ];
}
