// ignore_for_file: must_be_immutable

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/networks/network_type.dart';

@Entity()
class EmbeddedNetworkTemplateEntity extends Equatable {
  @Id()
  int id;

  String? name;
  String? addressEncoderType;
  String? derivationPathTemplate;
  String? derivatorType;
  String? dbCurveType;
  String? dbNetworkIconType;
  String? dbNetworkType;
  String? dbWalletType;

  @Transient()
  CurveType? get curveType => _enumByNameOrNull<CurveType>(CurveType.values, dbCurveType);

  set curveType(CurveType? value) {
    dbCurveType = value?.name;
  }

  @Transient()
  NetworkIconType? get networkIconType => _enumByNameOrNull<NetworkIconType>(NetworkIconType.values, dbNetworkIconType);

  set networkIconType(NetworkIconType? value) {
    dbNetworkIconType = value?.name;
  }

  @Transient()
  NetworkType? get networkType => _enumByNameOrNull<NetworkType>(NetworkType.values, dbNetworkType);

  set networkType(NetworkType? value) {
    dbNetworkType = value?.name;
  }

  @Transient()
  WalletType? get walletType => _enumByNameOrNull<WalletType>(WalletType.values, dbWalletType);

  set walletType(WalletType? value) {
    dbWalletType = value?.name;
  }

  EmbeddedNetworkTemplateEntity({
    this.id = 0,
    this.name,
    this.addressEncoderType,
    this.derivationPathTemplate,
    this.derivatorType,
    CurveType? curveType,
    NetworkIconType? networkIconType,
    NetworkType? networkType,
    WalletType? walletType,
    this.dbCurveType,
    this.dbNetworkIconType,
    this.dbNetworkType,
    this.dbWalletType,
  }) {
    if (curveType != null) {
      this.curveType = curveType;
    }
    if (networkIconType != null) {
      this.networkIconType = networkIconType;
    }
    if (networkType != null) {
      this.networkType = networkType;
    }
    if (walletType != null) {
      this.walletType = walletType;
    }
  }

  factory EmbeddedNetworkTemplateEntity.fromNetworkTemplateModel(
    NetworkTemplateModel networkTemplateModel,
  ) {
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

  @Transient()
  @override
  List<Object?> get props => <Object?>[
        name,
        addressEncoderType,
        derivationPathTemplate,
        derivatorType,
        dbCurveType,
        dbNetworkIconType,
        dbNetworkType,
        dbWalletType,
        curveType,
        networkIconType,
        networkType,
        walletType,
      ];
}

T? _enumByNameOrNull<T extends Enum>(List<T> values, String? name) {
  if (name == null) {
    return null;
  }

  for (final T value in values) {
    if (value.name == name) {
      return value;
    }
  }

  return null;
}
