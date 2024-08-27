import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletCreatePageCubit extends Cubit<WalletCreatePageState> {
  final SecretsService secretsService = globalLocator<SecretsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();

  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController derivationPathTextEditingController = TextEditingController();

  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final NetworkGroupModel networkGroupModel;
  final NetworkTemplateModel networkTemplateModel;
  final FilesystemPath parentFilesystemPath;

  WalletCreatePageCubit({
    required this.vaultModel,
    required this.vaultPasswordModel,
    required this.networkGroupModel,
    required this.parentFilesystemPath,
  })  : networkTemplateModel = networkGroupModel.networkTemplateModel,
        super(const WalletCreatePageState());

  Future<void> init() async {
    int lastDerivationIndex = await _walletsService.getLastDerivationIndex(networkGroupModel.filesystemPath);
    int derivationIndex = lastDerivationIndex + 1;

    nameTextEditingController.text = 'Wallet $derivationIndex';
    derivationPathTextEditingController
      ..text = networkTemplateModel.getCustomizableDerivationPath(addressIndex: derivationIndex)
      ..addListener(_handleDerivationPathChanged);
  }

  @override
  Future<void> close() async {
    nameTextEditingController.dispose();
    derivationPathTextEditingController.dispose();
    await super.close();
  }

  Future<WalletModel?> createNewWallet() async {
    String derivationPathString = networkTemplateModel.mergeCustomDerivationPath(derivationPathTextEditingController.text);

    bool walletExistsBool = await _walletsService.isDerivationPathExists(parentFilesystemPath, derivationPathString);
    if (walletExistsBool == true) {
      emit(const WalletCreatePageState(walletExistsErrorBool: true));
      return null;
    }

    int lastWalletIndex = await _walletsService.getLastIndex(networkGroupModel.filesystemPath);
    int walletIndex = lastWalletIndex + 1;

    VaultSecretsModel vaultSecretsModel = await secretsService.get(vaultModel.filesystemPath, vaultPasswordModel);
    Mnemonic mnemonic = Mnemonic(vaultSecretsModel.mnemonicModel.mnemonicList);
    AHDWallet hdWallet = await networkTemplateModel.deriveWallet(mnemonic, derivationPathString);

    return walletModelFactory.createNewWallet(
      WalletCreationRequestModel(
        index: walletIndex,
        hdWallet: hdWallet,
        derivationPathString: derivationPathString,
        parentFilesystemPath: parentFilesystemPath,
        name: nameTextEditingController.text,
      ),
    );
  }

  void _handleDerivationPathChanged() {
    emit(const WalletCreatePageState(walletExistsErrorBool: false));
  }
}
