import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_type.dart';

class NetworkTemplateModel extends Equatable {
  static final RegExp _derivationPathRegExp = RegExp(r"^(?<static_part>m(?:/(?<segment>\d+'?))+)/?(?<dynamic_part>(?:{{\w+}}.*)?)$");
  static const String _defaultDerivationPath = 'm';

  final String name;
  final String derivationPathTemplate;
  final ABlockchainAddressEncoder<ABip32PublicKey> addressEncoder;
  final ADerivator derivator;
  final CurveType curveType;
  final NetworkIconType networkIconType;
  final NetworkType networkType;
  final WalletType walletType;

  const NetworkTemplateModel({
    required this.name,
    required this.derivationPathTemplate,
    required this.addressEncoder,
    required this.derivator,
    required this.curveType,
    required this.networkIconType,
    required this.networkType,
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
      networkType: embeddedNetworkTemplateEntity.networkType!,
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
    NetworkType? networkType,
    WalletType? walletType,
  }) {
    return NetworkTemplateModel(
      name: name ?? this.name,
      derivationPathTemplate: derivationPathTemplate ?? this.derivationPathTemplate,
      addressEncoder: addressEncoder ?? this.addressEncoder,
      derivator: derivator ?? this.derivator,
      curveType: curveType ?? this.curveType,
      networkIconType: networkIconType ?? this.networkIconType,
      networkType: networkType ?? this.networkType,
      walletType: walletType ?? this.walletType,
    );
  }

  Future<AHDWallet> deriveWallet(Mnemonic mnemonic, String derivationPathString) async {
    switch (walletType) {
      case WalletType.legacy:
        return _deriveLegacyHDWallet(mnemonic, derivationPathString);
    }
  }

  // TODO(Kamil): Dominik created this method with fully customizable derivation paths in mind. It is futile with the current limited customization.
  // TODO(Kamil): The method will be used again when full customization is implemented.
  String getCustomizableDerivationPath({
    int accountIndex = 0,
    int changeIndex = 0,
    int addressIndex = 0,
  }) {
    RegExpMatch? match = _derivationPathRegExp.firstMatch(derivationPathTemplate);
    String? dynamicPart = match?.namedGroup('dynamic_part');

    String customizableDerivationPath = dynamicPart ?? '';

    if (customizableDerivationPath.contains('{{i}}') == false) {
      customizableDerivationPath = _appendIndex(customizableDerivationPath);
    }

    customizableDerivationPath = customizableDerivationPath.replaceAll('{{a}}', '$accountIndex');
    customizableDerivationPath = customizableDerivationPath.replaceAll('{{y}}', '$changeIndex');
    customizableDerivationPath = customizableDerivationPath.replaceAll('{{i}}', '$addressIndex');

    if (networkType == NetworkType.solana) {
      customizableDerivationPath = customizableDerivationPath.split("'/0'").first;
    }

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
    }
    if (networkType == NetworkType.solana) {
      return "$baseDerivationPath/$updatedCustomDerivationPath'/0'";
    } else {
      return '$baseDerivationPath/$updatedCustomDerivationPath';
    }
  }

  String get baseDerivationPath {
    RegExpMatch? match = _derivationPathRegExp.firstMatch(derivationPathTemplate);
    String? staticPart = match?.namedGroup('static_part');
    return staticPart ?? _defaultDerivationPath;
  }

  String _appendIndex(String customizableDerivationPath) {
    if (customizableDerivationPath.contains('{{i}}') == true) {
      return customizableDerivationPath;
    }

    switch (networkType) {
      case NetworkType.ethereum:
        return '$customizableDerivationPath{{i}}';
      case NetworkType.solana:
        return "{{i}}'/0'";
    }
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
        networkType.name,
        walletType.name,
      ];
}
