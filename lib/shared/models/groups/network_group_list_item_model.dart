import 'package:snggle/shared/models/groups/wallet_group_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';

class NetworkGroupListItemModel extends WalletGroupListItemModel {
  final NetworkConfigModel networkConfigModel;

  NetworkGroupListItemModel({
    required this.networkConfigModel,
    required super.encryptedBool,
    required super.walletsPreview,
    required super.walletGroupModel,
  });

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, networkConfigModel, walletGroupModel, walletsPreview];
}
