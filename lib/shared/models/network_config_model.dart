import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';

class NetworkConfigModel extends Equatable {
  // TODO(dominik): Properties for custom NetworkGroupModels should be stored in database.
  // Creating templates for custom NetworkGroupsModel will be a separate process with its own repository, service and UI.
  // Predefined NetworkGroupModels will be hardcoded in the application, but the final location is not yet known due to the missing process of creating Network templates
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

  static NetworkConfigModel getByNetworkId(String networkId) {
    return allNetworks.firstWhere((NetworkConfigModel network) => network.id == networkId);
  }

  @override
  List<Object?> get props => <Object>[id, name, iconData];
}
