import 'package:flutter/material.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

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
  @override
  Widget build(BuildContext context) {
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
        subtitle: const Text('Wallets: <unimplemented>'),
      ),
    );
  }
}
