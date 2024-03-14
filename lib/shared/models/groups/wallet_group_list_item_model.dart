import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';

class WalletGroupListItemModel extends AListItemModel {
  final List<String> walletAddressesPreview;
  late WalletGroupModel walletGroupModel;

  WalletGroupListItemModel({
    required super.encryptedBool,
    required this.walletAddressesPreview,
    required this.walletGroupModel,
  }) : super(pinnedBool: walletGroupModel.pinnedBool);

  @override
  WalletGroupListItemModel copyWith({
    bool? encryptedBool,
    bool? pinnedBool,
    List<String>? walletAddressesPreview,
    WalletGroupModel? walletGroupModel,
  }) {
    return WalletGroupListItemModel(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      walletAddressesPreview: walletAddressesPreview ?? this.walletAddressesPreview,
      walletGroupModel: (walletGroupModel ?? this.walletGroupModel).copyWith(
        pinnedBool: pinnedBool ?? this.pinnedBool,
      ),
    );
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, encryptedBool, walletAddressesPreview, walletGroupModel];
}
