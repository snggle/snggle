import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';

class NetworkConfigModel extends Equatable {
  // TODO(dominik): Properties for custom NetworkGroupModels should be stored in database.
  // Creating templates for custom NetworkGroupsModel will be a separate process with its own repository, service and UI.
  // Predefined NetworkGroupModels will be hardcoded in the application, but the final location is not yet known due to the missing process of creating Network templates
  static const NetworkConfigModel kira = NetworkConfigModel(id: 'kira', name: 'Kira', networkIconType: NetworkIconType.unknown);
  static const NetworkConfigModel ethereum = NetworkConfigModel(id: 'ethereum', name: 'Ethereum', networkIconType: NetworkIconType.ethereum);
  static const NetworkConfigModel polkadot = NetworkConfigModel(id: 'polkadot', name: 'Polkadot', networkIconType: NetworkIconType.unknown);
  static const NetworkConfigModel bitcoin = NetworkConfigModel(id: 'bitcoin', name: 'Bitcoin', networkIconType: NetworkIconType.bitcoin);
  static const NetworkConfigModel cosmos = NetworkConfigModel(id: 'cosmos', name: 'Cosmos', networkIconType: NetworkIconType.cosmos);
  static const List<NetworkConfigModel> allNetworks = <NetworkConfigModel>[kira, ethereum, polkadot, bitcoin, cosmos];

  final String id;
  final String name;
  final NetworkIconType networkIconType;

  const NetworkConfigModel({
    required this.id,
    required this.name,
    required this.networkIconType,
  });

  static NetworkConfigModel getByNetworkId(String networkId) {
    return allNetworks.firstWhere((NetworkConfigModel network) => network.id == networkId);
  }

  @override
  List<Object?> get props => <Object>[id, name, networkIconType];
}
