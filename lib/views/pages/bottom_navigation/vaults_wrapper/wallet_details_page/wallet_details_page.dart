import 'package:auto_route/annotations.dart';
import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

@RoutePage()
class WalletDetailsPage extends StatelessWidget {
  final WalletModel walletModel;

  const WalletDetailsPage({
    required this.walletModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Wallet details'),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SvgPicture.string(Blockies(seed: walletModel.address).toSvg(size: 100)),
              const SizedBox(height: 20),
              const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(walletModel.address),
              const SizedBox(height: 10),
              const Text('Derivation path:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(walletModel.derivationPath),
            ],
          ),
        ),
      ),
    );
  }
}
