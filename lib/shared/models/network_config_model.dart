import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';

class NetworkConfigModel extends Equatable {
  static const NetworkConfigModel kira = NetworkConfigModel(id: 'kira', name: 'Kira', iconData: AppIcons.token_kira);
  static const NetworkConfigModel ethereum = NetworkConfigModel(id: 'ethereum', name: 'Ethereum', iconData: AppIcons.token_eth);
  static const NetworkConfigModel polkadot = NetworkConfigModel(id: 'polkadot', name: 'Polkadot', iconData: AppIcons.token_polkadot);
  static const NetworkConfigModel bitcoin = NetworkConfigModel(id: 'bitcoin', name: 'Bitcoin', iconData: AppIcons.token_btc);
  static const NetworkConfigModel cosmos = NetworkConfigModel(id: 'cosmos', name: 'Cosmos', iconData: AppIcons.token_cosmos);

  static const List<NetworkConfigModel> allNetworks = <NetworkConfigModel>[kira, ethereum, polkadot, bitcoin, cosmos];

  final String id;
  final String name;
  final IconData iconData;

  const NetworkConfigModel({
    required this.id,
    required this.name,
    required this.iconData,
  });

  @override
  List<Object?> get props => <Object>[id, name, iconData];
}
