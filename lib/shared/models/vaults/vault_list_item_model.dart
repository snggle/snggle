import 'package:snuggle/shared/models/address_model.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';

class VaultListItemModel {
  final VaultInfoModel vaultInfoModel;
  final List<AddressModel> addressModelList;

  VaultListItemModel({
    required this.vaultInfoModel,
    required this.addressModelList,
  });
}
