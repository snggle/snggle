import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/wallet_list/wallet_list_cubit.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dao/vault/vault_decrypted_secrets_dao.dart';
import 'package:snuggle/infra/services/wallets_service.dart';
import 'package:snuggle/shared/models/address_model.dart';
import 'package:snuggle/shared/models/vaults/vault_decrypted_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';
import 'package:snuggle/shared/models/wallet/wallet_decrypted_secrets_model.dart';
import 'package:snuggle/shared/models/wallet/wallet_model.dart';
import 'package:snuggle/shared/utils/crypto/secp256k1.dart';
import 'package:uuid/uuid.dart';

class WalletsListPage extends StatefulWidget {
  final VaultInfoModel vaultInfoModel;

  const WalletsListPage({
    required this.vaultInfoModel,
    super.key,
  });

  @override
  _WalletsListPageState createState() => _WalletsListPageState();
}

class _WalletsListPageState extends State<WalletsListPage> {
  late final WalletListCubit walletListCubit = WalletListCubit(vaultInfoModel: widget.vaultInfoModel);
  
  @override
  void initState() {
    super.initState();
    walletListCubit.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateNewWallet,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<WalletListCubit, List<WalletModel>>(
        bloc: walletListCubit,
        builder: (BuildContext context, List<WalletModel> walletListItemModelList) {
          return ListView.builder(
            itemCount: walletListItemModelList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(walletListItemModelList[index].name),
                subtitle: Text('Wallets: ${walletListItemModelList[index].addressModel.bech32Address}'),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _generateNewWallet() async {
      for( int i = 0; i < 5000; i++ ) {
        print('Generating wallet $i');
        await _generateNewWallet2();
      }
      print('finished');
  }
  Future<void> _generateNewWallet2() async {
    WalletsService walletsService = globalLocator<WalletsService>();
    if (widget.vaultInfoModel.vaultsSecretsModel is VaultDecryptedSecretsModel) {
      VaultDecryptedSecretsModel vaultDecryptedSecretsModel = widget.vaultInfoModel.vaultsSecretsModel as VaultDecryptedSecretsModel;
      // Convert the mnemonic to a BIP32 instance
      final bip32.BIP32 root = bip32.BIP32.fromSeed(vaultDecryptedSecretsModel.seed);

      // Get the node from the derivation path
      final bip32.BIP32 derivedNode = root.derivePath("m/44'/118'/0'/0/${walletListCubit.state.length}");

      final Uint8List publicKeyBytes = Secp256k1.privateKeyBytesToPublic(derivedNode.privateKey!);
      
      WalletModel walletModel = WalletModel(
        id: const Uuid().v4(),
        name: 'Wallet ${walletListCubit.state.length}',
        addressModel: AddressModel.fromPublicKey(publicKeyBytes, bech32Hrp: 'kira'),
        parentVaultInfoModel: widget.vaultInfoModel,
        walletSecretsModel: WalletDecryptedSecretsModel(
          privateKey: derivedNode.privateKey!,
        ),
      );

      await walletsService.save(walletModel);
      await walletListCubit.reload();
    }
  }
}
