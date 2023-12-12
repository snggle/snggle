import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/vault_list_item/vault_list_item_cubit.dart';
import 'package:snggle/bloc/vault_list_item/vault_list_item_state.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';

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
            title: Text(
              'Vault: ${widget.vaultModel.index + 1}',
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
            subtitle: TextButtonTheme(
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
                    ]
                  ] else
                    TextButton(onPressed: _setPassword, child: const Text('Set password')),
                ],
              ),
            ),
          ),
        );
      },
    );
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
