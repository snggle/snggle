import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListItem extends StatefulWidget {
  final WalletModel walletModel;
  final VoidCallback onDelete;

  const WalletListItem({
    required this.walletModel,
    required this.onDelete,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletListItemState();
}

class _WalletListItemState extends State<WalletListItem> {
  final PasswordModel mockedPasswordModel = PasswordModel.fromPlaintext('1111');

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
      key: Key(widget.walletModel.uuid),
      onDismissed: (_) => widget.onDelete(),
      child: ListTile(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: SvgPicture.string(Blockies(seed: widget.walletModel.address).toSvg(size: 40)),
        ),
        title: Text('Wallet ${widget.walletModel.index}', style: const TextStyle(fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.walletModel.address, style: const TextStyle(fontSize: 10)),
            Text(widget.walletModel.derivationPath, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
