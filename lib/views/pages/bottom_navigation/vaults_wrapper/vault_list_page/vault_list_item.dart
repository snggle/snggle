import 'package:auto_route/auto_route.dart';
import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/bloc/vault_list_item/vault_list_item_cubit.dart';
import 'package:snggle/bloc/vault_list_item/vault_list_item_state.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.gr.dart';

class VaultListItem extends StatefulWidget {
  final VaultModel vaultModel;
  final VoidCallback onDelete;

  const VaultListItem({
    required this.vaultModel,
    required this.onDelete,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VaultListItemState();
}

class _VaultListItemState extends State<VaultListItem> {
  final PasswordModel mockedPasswordModel = PasswordModel.fromPlaintext('1111');
  late final VaultListItemCubit vaultListItemCubit = VaultListItemCubit(vaultModel: widget.vaultModel);

  @override
  void initState() {
    super.initState();
    vaultListItemCubit.init();
  }

  @override
  void dispose() {
    vaultListItemCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultListItemCubit, VaultListItemState>(
      bloc: vaultListItemCubit,
      builder: (BuildContext context, VaultListItemState vaultListItemState) {
        return Dismissible(
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.all(15),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.delete_outline_outlined),
                Icon(Icons.delete_outline_outlined),
              ],
            ),
          ),
          key: Key(widget.vaultModel.uuid),
          onDismissed: (_) => widget.onDelete(),
          child: ListTile(
            onTap: () => _navigateToWalletsPage(vaultListItemState.encryptedBool, vaultListItemState.lockedBool),
            title: Text(
              (widget.vaultModel.name != null && widget.vaultModel.name!.isNotEmpty) ? widget.vaultModel.name! : 'Vault: ${widget.vaultModel.index + 1}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: vaultListItemState.encryptedBool ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Icon(
                          Icons.lock,
                          size: 14,
                          color: vaultListItemState.encryptedBool ? Colors.green : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: vaultListItemState.encryptedBool ? 'With password' : 'Without password'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: vaultListItemState.lockedBool ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Icon(
                          Icons.lock,
                          size: 14,
                          color: vaultListItemState.lockedBool ? Colors.green : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: vaultListItemState.lockedBool ? 'Locked' : 'Unlocked'),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ...vaultListItemState.vaultWalletsPreview.map((WalletModel walletModel) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: ClipOval(
                          child: SvgPicture.string(Blockies(seed: walletModel.address).toSvg(size: 15)),
                        ),
                      );
                    }).toList(),
                    if (vaultListItemState.totalWalletsCount > 9)
                      Text('  +${vaultListItemState.totalWalletsCount - 9}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                TextButtonTheme(
                  data: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(10, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                  ),
                  child: Wrap(
                    children: <Widget>[
                      if (vaultListItemState.encryptedBool) ...<Widget>[
                        if (vaultListItemState.lockedBool)
                          TextButton(onPressed: _unlock, child: const Text('Unlock'))
                        else ...<Widget>[
                          TextButton(onPressed: _lock, child: const Text('Lock')),
                          const SizedBox(width: 10),
                          TextButton(onPressed: _removePassword, child: const Text('Remove pass')),
                          const SizedBox(width: 10),
                          TextButton(onPressed: _showSecrets, child: const Text('Show Secrets')),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () => _navigateToWalletsPage(vaultListItemState.encryptedBool, vaultListItemState.lockedBool),
                            child: const Text('Open'),
                          ),
                        ]
                      ] else
                        TextButton(onPressed: _setPassword, child: const Text('Set password')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToWalletsPage(bool encryptedBool, bool lockedBool) async {
    if (lockedBool) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vault is locked. Unlock it first.')));
      return;
    } else {
      await AutoRouter.of(context).push<void>(
        WalletListRoute(vaultModel: widget.vaultModel, vaultPasswordModel: encryptedBool ? mockedPasswordModel : PasswordModel.defaultPassword()),
      );
      await vaultListItemCubit.reload();
    }
  }

  void _unlock() {
    vaultListItemCubit.unlock(mockedPasswordModel);
  }

  void _lock() {
    vaultListItemCubit.lock();
  }

  void _setPassword() {
    vaultListItemCubit.setPassword(mockedPasswordModel);
  }

  void _removePassword() {
    vaultListItemCubit.removePassword(mockedPasswordModel);
  }

  Future<void> _showSecrets() async {
    VaultSecretsModel vaultSecretsModel = await vaultListItemCubit.getVaultSecrets(mockedPasswordModel);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vaultSecretsModel.toString())));
  }
}
