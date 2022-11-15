import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/vaults_list/vaults_list_cubit.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/vaults_service.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/models/vaults/vault_decrypted_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snuggle/shared/router/router.gr.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';
import 'package:uuid/uuid.dart';

class VaultListPage extends StatefulWidget {
  const VaultListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VaultListPageState();
}

class _VaultListPageState extends State<VaultListPage> {
  final VaultsListCubit vaultsListCubit = VaultsListCubit();
  
  @override
  void initState() {
    super.initState();
    vaultsListCubit.reload();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaults'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateNewVault,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<VaultsListCubit, List<VaultListItemModel>>(
        bloc: vaultsListCubit,
        builder: (BuildContext context, List<VaultListItemModel> vaultListItemModelList) {
          return ListView.builder(
            itemCount: vaultListItemModelList.length,
            itemBuilder: (BuildContext context, int index) {
              VaultListItemModel vaultListItemModel = vaultListItemModelList[index];
              return ListTile(
                onTap: () => _navigateToWalletListPage(vaultListItemModel),
                title: Text(vaultListItemModel.vaultInfoModel.name),
                subtitle: Text('Wallets: ${vaultListItemModel.addressModelList.length}'),
              );
            },
          );
        },
      ),
    );
  }
  
  Future<void> _generateNewVault() async {
    VaultsService vaultsService = globalLocator<VaultsService>();
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    VaultInfoModel vaultInfoModel = VaultInfoModel(
      id: const Uuid().v4(),
      name: 'Vault ${vaultsListCubit.state.length}',
      vaultsSecretsModel: VaultDecryptedSecretsModel(
        seed: seed,
      ),
    );

    await vaultsService.saveVault(vaultInfoModel);
    await vaultsListCubit.reload();
  }
  
  Future<void> _navigateToWalletListPage(VaultListItemModel vaultListItemModel) async {
    await AutoRouter.of(context).push(WalletsListRoute(vaultInfoModel: vaultListItemModel.vaultInfoModel));
    await vaultsListCubit.reload();
  }
}
