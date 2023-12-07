import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/bottom_navigation/vault_list_page/vault_list_item.dart';

@RoutePage()
class VaultListPage extends StatefulWidget {
  const VaultListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VaultListPageState();
}

class _VaultListPageState extends State<VaultListPage> {
  final VaultListPageCubit vaultListPageCubit = VaultListPageCubit();

  @override
  void initState() {
    super.initState();
    vaultListPageCubit.refresh();
  }

  @override
  void dispose() {
    vaultListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaults'),
      ),
      body: BlocBuilder<VaultListPageCubit, List<VaultModel>>(
        bloc: vaultListPageCubit,
        builder: (BuildContext context, List<VaultModel> vaultModelList) {
          return ListView.builder(
            itemCount: vaultModelList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              bool lastItemBool = index == vaultModelList.length;
              if (lastItemBool) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: _createNewVault,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                );
              }
              VaultModel vaultModel = vaultModelList[index];
              return VaultListItem(
                key: Key(vaultModel.uuid),
                vaultModel: vaultModel,
                onDelete: () => _deleteVault(vaultModel),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _createNewVault() async {
    try {
      await vaultListPageCubit.createNewVault();
    } catch (e) {
      AppLogger().log(message: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create a new vault')));
    }
  }

  Future<void> _deleteVault(VaultModel vaultModel) async {
    try {
      await vaultListPageCubit.deleteVault(vaultModel);
    } catch (e) {
      AppLogger().log(message: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete a vault')));
    }
  }
}
