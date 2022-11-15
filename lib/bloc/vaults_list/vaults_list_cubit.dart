import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/infra/services/vaults_service.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';

class VaultsListCubit extends Cubit<List<VaultListItemModel>> {
  final VaultsService _vaultsService = VaultsService();

  VaultsListCubit() : super(<VaultListItemModel>[]);

  Future<void> reload() async {
    emit(await _vaultsService.getAll());
  }
}
