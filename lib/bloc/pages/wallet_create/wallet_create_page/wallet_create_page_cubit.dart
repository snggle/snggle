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

  final VaultModel _vaultModel;
  final PasswordModel _vaultPasswordModel;
  final NetworkGroupModel _networkGroupModel;
  final NetworkTemplateModel _networkTemplateModel;
  final FilesystemPath _parentFilesystemPath;

  WalletCreatePageCubit({
    required VaultModel vaultModel,
    required PasswordModel vaultPasswordModel,
    required NetworkGroupModel networkGroupModel,
    required FilesystemPath parentFilesystemPath,
  })  : _parentFilesystemPath = parentFilesystemPath,
        _networkGroupModel = networkGroupModel,
        _vaultPasswordModel = vaultPasswordModel,
        _vaultModel = vaultModel,
        _networkTemplateModel = networkGroupModel.networkTemplateModel,
        super(const WalletCreatePageState());

  Future<void> init({required String defaultWalletName}) async {
    int lastDerivationIndex = await _walletsService.getLastDerivationIndex(_networkGroupModel.filesystemPath);
    int derivationIndex = lastDerivationIndex + 1;

    if (derivationIndex != 0) {
      nameTextEditingController.text = '$defaultWalletName $derivationIndex';
    } else {
      nameTextEditingController.text = defaultWalletName;
    }

    derivationPathTextEditingController
      ..text = _networkTemplateModel.getCustomizableDerivationPath(addressIndex: derivationIndex)
      ..addListener(_handleDerivationPathChanged);
  }

  @override
  Future<void> close() async {
    nameTextEditingController.dispose();
    derivationPathTextEditingController.dispose();
    await super.close();
  }

  Future<WalletModel?> createNewWallet() async {
    if (derivationPathTextEditingController.text.isEmpty) {
      emit(const WalletCreatePageState(emptyDerivationPathBool: true));
      return null;
    }

    String derivationPathString = _networkTemplateModel.mergeCustomDerivationPath(derivationPathTextEditingController.text);

    bool walletExistsBool = await _walletsService.isDerivationPathExists(_parentFilesystemPath, derivationPathString);
    if (walletExistsBool == true) {
      emit(const WalletCreatePageState(walletExistsErrorBool: true));
      return null;
    }

    VaultSecretsModel vaultSecretsModel = await secretsService.get(_vaultModel.filesystemPath, _vaultPasswordModel);
    Mnemonic mnemonic = Mnemonic(vaultSecretsModel.mnemonicModel.mnemonicList);
    AHDWallet hdWallet = await _networkTemplateModel.deriveWallet(mnemonic, derivationPathString);

    return walletModelFactory.createNewWallet(
      WalletCreationRequestModel(
        hdWallet: hdWallet,
        derivationPathString: derivationPathString,
        parentFilesystemPath: _parentFilesystemPath,
        name: nameTextEditingController.text,
      ),
    );
  }

  void _handleDerivationPathChanged() {
    emit(const WalletCreatePageState(walletExistsErrorBool: false));
  }
}
