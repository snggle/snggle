import 'package:snggle/bloc/network_groups_page/network_groups_page_cubit.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class GroupListItemModel extends AContainerModel {
  final bool encryptedBool;
  final List<WalletModel> walletsPreview;

  const GroupListItemModel({
    required this.encryptedBool,
    required this.walletsPreview,
    required super.containerPathModel,
  });

  @override
  List<Object?> get props => <Object?>[encryptedBool, walletsPreview];
}
