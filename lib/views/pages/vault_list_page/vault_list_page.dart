import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/vault_list/vault_list_cubit.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';

class VaultListPage extends StatefulWidget {
  const VaultListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VaultListPageState();
}

class _VaultListPageState extends State<VaultListPage> {
  final VaultListCubit vaultListCubit = VaultListCubit();

  @override
  void initState() {
    super.initState();
    vaultListCubit.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaults'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vaultListCubit.generateNewVault,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<VaultListCubit, List<VaultListItemModel>>(
        bloc: vaultListCubit,
        builder: (BuildContext context, List<VaultListItemModel> vaultListItemModelList) {
          return ListView.builder(
            itemCount: vaultListItemModelList.length,
            itemBuilder: (BuildContext context, int index) {
              VaultListItemModel vaultListItemModel = vaultListItemModelList[index];
              return Dismissible(
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Icon(Icons.delete_outline_outlined),
                      Icon(Icons.delete_outline_outlined),
                    ],
                  ),
                ),
                key: Key(vaultListItemModel.vaultModel.uuid),
                onDismissed: (_) => vaultListCubit.deleteVault(vaultListItemModel),
                child: ListTile(
                  onTap: () => _navigateToWalletListPage(vaultListItemModel),
                  title: Text(vaultListItemModel.vaultModel.name),
                  subtitle: const Text('Wallets: <unimplemented>'),
                  trailing: vaultListItemModel.vaultModel.encrypted
                      ? IconButton(onPressed: () => vaultListCubit.decryptVault(vaultListItemModel, 'password'), icon: const Icon(Icons.lock))
                      : IconButton(onPressed: () => vaultListCubit.encryptVault(vaultListItemModel, 'password'), icon: const Icon(Icons.lock_open)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // TODO(dominik): Navigate to the wallet list page.
  Future<void> _navigateToWalletListPage(VaultListItemModel vaultListItemModel) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 900),
        content: Text(
          vaultListItemModel.vaultModel.vaultSecretsModel.toString(),
        ),
      ),
    );
  }
}
