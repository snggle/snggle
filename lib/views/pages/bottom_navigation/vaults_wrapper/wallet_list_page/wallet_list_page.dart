import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_item.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

@RoutePage()
class WalletListPage extends StatefulWidget {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;

  const WalletListPage({
    required this.vaultModel,
    required this.vaultPasswordModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => WalletListPageState();
}

class WalletListPageState extends State<WalletListPage> {
  late final WalletListPageCubit walletListPageCubit = WalletListPageCubit(vaultModel: widget.vaultModel, vaultPasswordModel: widget.vaultPasswordModel);

  @override
  void initState() {
    walletListPageCubit.refresh();
    super.initState();
  }

  @override
  void dispose() {
    walletListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Wallets'),
      body: BlocBuilder<WalletListPageCubit, List<WalletModel>>(
        bloc: walletListPageCubit,
        builder: (BuildContext context, List<WalletModel> walletModelList) {
          return ListView.builder(
            itemCount: walletModelList.length + 2,
            itemBuilder: (BuildContext context, int index) {
              bool paddingItemBool = index == walletModelList.length + 1;
              bool buttonItemBool = index == walletModelList.length;
              if (paddingItemBool) {
                return const SizedBox(height: 100);
              } else if (buttonItemBool) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: _createNewWallet,
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
              WalletModel walletModel = walletModelList[index];
              return WalletListItem(
                key: Key(walletModel.uuid),
                walletModel: walletModel,
                onDelete: () => _deleteWallet(walletModel),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _createNewWallet() async {
    try {
      await walletListPageCubit.createNewWallet();
    } catch (e) {
      AppLogger().log(message: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create a new wallet')));
    }
  }

  Future<void> _deleteWallet(WalletModel walletModel) async {
    try {
      await walletListPageCubit.deleteVault(walletModel);
    } catch (e) {
      AppLogger().log(message: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete wallet')));
    }
  }
}
