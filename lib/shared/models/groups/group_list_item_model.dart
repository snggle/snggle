import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class GroupListItemModel extends AListItem {
  final ContainerPathModel containerPathModel;
  final List<WalletModel> walletsPreview;

  GroupListItemModel({
    required super.encryptedBool,
    required super.pinnedBool,
    required this.containerPathModel,
    required this.walletsPreview,
  });

  @override
  List<Object?> get props => <Object?>[encryptedBool, walletsPreview];
}
