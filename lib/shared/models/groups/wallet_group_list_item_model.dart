import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletGroupListItemModel extends AListItem {
  final List<WalletModel> walletsPreview;
  late WalletGroupModel walletGroupModel;

  WalletGroupListItemModel({
    required super.encryptedBool,
    required this.walletsPreview,
    required this.walletGroupModel,
  }) : super(pinnedBool: walletGroupModel.pinnedBool);

  @override
  void setPinned({required bool pinnedBool}) {
    super.setPinned(pinnedBool: pinnedBool);
    walletGroupModel = walletGroupModel.copyWith(pinnedBool: pinnedBool);
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, encryptedBool, walletsPreview, walletGroupModel];
}
