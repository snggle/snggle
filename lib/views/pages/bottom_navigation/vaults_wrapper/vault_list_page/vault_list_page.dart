import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

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
    return CustomScaffold(
      title: 'Vaults',
      popButtonVisible: false,
      body: BlocBuilder<VaultListPageCubit, List<VaultModel>>(
        bloc: vaultListPageCubit,
        builder: (BuildContext context, List<VaultModel> vaultModelList) {
          return ListView.builder(
            itemCount: vaultModelList.length + 2,
            itemBuilder: (BuildContext context, int index) {
              bool paddingItemBool = index == vaultModelList.length + 1;
              bool buttonItemBool = index == vaultModelList.length;
              if (paddingItemBool) {
                return const SizedBox(height: 100);
              } else if (buttonItemBool) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: _navigateToVaultCreateRecoverRoute,
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

  Future<void> _navigateToVaultCreateRecoverRoute() async {
    VaultCreateRecoverStatus? vaultCreateRecoverStatus = await AutoRouter.of(context).push<VaultCreateRecoverStatus?>(
      VaultCreateRecoverRoute(children: <PageRouteInfo>[
        VaultInitRoute(parentFilesystemPath: const FilesystemPath.empty()),
      ]),
    );
    if (vaultCreateRecoverStatus != null) {
      unawaited(vaultListPageCubit.refresh());
      await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) => CustomDialog(
          title: 'Success',
          content: switch (vaultCreateRecoverStatus) {
            VaultCreateRecoverStatus.creationSuccessful => 'The vault creation process has been completed',
            VaultCreateRecoverStatus.recoverySuccessful => 'The vault recovery process has been completed',
          },
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Done',
              onPressed: () {},
            ),
          ],
        ),
      );
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
