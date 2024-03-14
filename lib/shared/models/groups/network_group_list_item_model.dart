import 'package:snggle/shared/models/groups/wallet_group_list_item_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';

class NetworkGroupListItemModel extends WalletGroupListItemModel {
  final NetworkConfigModel networkConfigModel;

  NetworkGroupListItemModel({
    required this.networkConfigModel,
    required super.encryptedBool,
    required super.walletAddressesPreview,
    required super.walletGroupModel,
  });

  @override
  NetworkGroupListItemModel copyWith({
    NetworkConfigModel? networkConfigModel,
    bool? encryptedBool,
    bool? pinnedBool,
    WalletGroupModel? walletGroupModel,
    List<String>? walletAddressesPreview,
  }) {
    return NetworkGroupListItemModel(
      networkConfigModel: networkConfigModel ?? this.networkConfigModel,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      walletGroupModel: (walletGroupModel ?? this.walletGroupModel).copyWith(
        pinnedBool: pinnedBool ?? this.pinnedBool,
      ),
      walletAddressesPreview: walletAddressesPreview ?? this.walletAddressesPreview,
    );
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, networkConfigModel, walletGroupModel, walletAddressesPreview];
}
