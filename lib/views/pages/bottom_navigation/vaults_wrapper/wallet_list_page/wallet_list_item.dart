import 'package:auto_route/auto_route.dart';
import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/bloc/wallet_list_item/wallet_list_item_cubit.dart';
import 'package:snggle/bloc/wallet_list_item/wallet_list_item_state.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/router/router.gr.dart';

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
  late final WalletListItemCubit walletListItemCubit = WalletListItemCubit(walletModel: widget.walletModel);

  @override
  void initState() {
    super.initState();
    walletListItemCubit.init();
  }

  @override
  void dispose() {
    walletListItemCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletListItemCubit, WalletListItemState>(
      bloc: walletListItemCubit,
      builder: (BuildContext context, WalletListItemState walletListItemState) {
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
            onTap: () => _navigateToWalletDetailsPage(walletListItemState.encryptedBool, walletListItemState.lockedBool),
            leading: SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.string(Blockies(seed: widget.walletModel.address).toSvg(size: 40)),
            ),
            title: Text('Wallet ${widget.walletModel.index}', style: const TextStyle(fontSize: 14)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.walletModel.address,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
                Text(widget.walletModel.derivationPath, style: const TextStyle(fontSize: 10)),
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
                      if (walletListItemState.encryptedBool) ...<Widget>[
                        if (walletListItemState.lockedBool)
                          TextButton(onPressed: _unlock, child: const Text('Unlock'))
                        else ...<Widget>[
                          TextButton(onPressed: _lock, child: const Text('Lock')),
                          const SizedBox(width: 10),
                          TextButton(onPressed: _removePassword, child: const Text('Remove pass')),
                          const SizedBox(width: 10),
                          TextButton(onPressed: _showSecrets, child: const Text('Show Secrets')),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () => _navigateToWalletDetailsPage(walletListItemState.encryptedBool, walletListItemState.lockedBool),
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
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: walletListItemState.encryptedBool ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Icon(
                          Icons.lock,
                          size: 14,
                          color: walletListItemState.encryptedBool ? Colors.green : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: walletListItemState.encryptedBool ? 'With password' : 'Without password'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: walletListItemState.lockedBool ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Icon(
                          Icons.lock,
                          size: 14,
                          color: walletListItemState.lockedBool ? Colors.green : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: walletListItemState.lockedBool ? 'Locked' : 'Unlocked'),
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

  Future<void> _navigateToWalletDetailsPage(bool encryptedBool, bool lockedBool) async {
    if (lockedBool) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet is locked. Unlock it first.')));
      return;
    } else {
      await AutoRouter.of(context).push<void>(WalletDetailsRoute(walletModel: widget.walletModel));
    }
  }

  void _unlock() {
    walletListItemCubit.unlock(mockedPasswordModel);
  }

  void _lock() {
    walletListItemCubit.lock();
  }

  void _setPassword() {
    walletListItemCubit.setPassword(mockedPasswordModel);
  }

  void _removePassword() {
    walletListItemCubit.removePassword(mockedPasswordModel);
  }

  Future<void> _showSecrets() async {
    WalletSecretsModel walletSecretsModel = await walletListItemCubit.getWalletSecrets(mockedPasswordModel);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(walletSecretsModel.toString())));
  }
}
