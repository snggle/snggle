import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class GroupListItemModel extends AListItem {
  final List<WalletModel> walletsPreview;
  late GroupModel groupModel;

  GroupListItemModel({
    required super.encryptedBool,
    required super.pinnedBool,
    required this.walletsPreview,
    required this.groupModel,
  });

  @override
  List<Object?> get props => <Object?>[pinnedBool, encryptedBool, walletsPreview, groupModel];
}
