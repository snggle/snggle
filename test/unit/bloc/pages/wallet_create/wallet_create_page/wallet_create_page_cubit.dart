import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_cubit.dart';
import 'package:snggle/bloc/pages/wallet_create/wallet_create_page/wallet_create_page_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';
import '../../../../../utils/test_network_templates.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late WalletCreatePageCubit actualWalletCreatePageCubit;

  setUpAll(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      databaseMock: DatabaseMock.fullDatabaseMock,
    );

    actualWalletCreatePageCubit = WalletCreatePageCubit(
      parentFilesystemPath: FilesystemPath.fromString('vault1/network1'),
      vaultPasswordModel: PasswordModel.defaultPassword(),
      vaultModel: VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[],
      ),
      networkGroupModel: NetworkGroupModel(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        filesystemPath: FilesystemPath.fromString('vault1/network1'),
        networkTemplateModel: TestNetworkTemplates.ethereum,
        listItemsPreview: <AListItemModel>[],
        name: 'Ethereum1',
      ),
    );
  });

  group('Tests of WalletCreatePageCubit process', () {
    test('Should [emit WalletCreatePageState] with initial values', () {
      // Act
      WalletCreatePageState actualWalletCreatePageState = actualWalletCreatePageCubit.state;
      String actualName = actualWalletCreatePageCubit.nameTextEditingController.text;
      String actualDerivationPath = actualWalletCreatePageCubit.derivationPathTextEditingController.text;

      // Assert
      WalletCreatePageState expectedWalletCreatePageState = const WalletCreatePageState();
      String expectedName = '';
      String expectedDerivationPath = '';

      expect(actualWalletCreatePageState, expectedWalletCreatePageState);
      expect(actualName, expectedName);
      expect(actualDerivationPath, expectedDerivationPath);
    });

    group('Tests of WalletCreatePageCubit.init()', () {
      test('Should [emit WalletCreatePageState] with initialized values', () async {
        // Act
        await actualWalletCreatePageCubit.init();

        WalletCreatePageState actualWalletCreatePageState = actualWalletCreatePageCubit.state;
        String actualName = actualWalletCreatePageCubit.nameTextEditingController.text;
        String actualDerivationPath = actualWalletCreatePageCubit.derivationPathTextEditingController.text;

        // Assert
        WalletCreatePageState expectedWalletCreatePageState = const WalletCreatePageState();
        String expectedName = 'Wallet 5';
        String expectedDerivationPath = "m/44'/60'/0'/0/5";

        expect(actualWalletCreatePageState, expectedWalletCreatePageState);
        expect(actualName, expectedName);
        expect(actualDerivationPath, expectedDerivationPath);
      });
    });

    group('Tests of WalletCreatePageCubit.createNewWallet()', () {
      test('Should [return null] and [emit WalletCreatePageState] with [walletExistsErrorBool == TRUE]', () async {
        // Act
        actualWalletCreatePageCubit.derivationPathTextEditingController.text = '0/1';
        await actualWalletCreatePageCubit.createNewWallet();

        WalletCreatePageState actualWalletCreatePageState = actualWalletCreatePageCubit.state;

        // Assert
        WalletCreatePageState expectedWalletCreatePageState = const WalletCreatePageState(walletExistsErrorBool: true);

        expect(actualWalletCreatePageState, expectedWalletCreatePageState);
      });

      test('Should [return WalletModel] and [emit WalletCreatePageState] with [walletExistsErrorBool == FALSE]', () async {
        // Act
        actualWalletCreatePageCubit.derivationPathTextEditingController.text = '0/99999';
        WalletModel? actualWalletModel = await actualWalletCreatePageCubit.createNewWallet();

        WalletCreatePageState actualWalletCreatePageState = actualWalletCreatePageCubit.state;

        // Assert
        WalletModel expectedWalletModel = WalletModel(
          id: 6,
          encryptedBool: false,
          pinnedBool: false,
          index: 5,
          address: '0x58d66B2F427936f1245f181fAaAaC51A176BF485',
          derivationPath: "m/44'/60'/0'/0/99999",
          filesystemPath: FilesystemPath.fromString('vault1/network1/wallet6'),
          name: 'Wallet 5',
        );
        WalletCreatePageState expectedWalletCreatePageState = const WalletCreatePageState(walletExistsErrorBool: false);

        expect(actualWalletModel, expectedWalletModel);
        expect(actualWalletCreatePageState, expectedWalletCreatePageState);
      });
    });
  });
}
