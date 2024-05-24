import 'dart:typed_data';

import 'package:blockchain_utils/hex/hex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() async {
  group('Tests of WalletModelFactory.createNewWallet()', () {
    test('Should [return WalletModel] from [provided WalletCreationRequestModel] with [randomly generated UUID]', () async {
      // Arrange
      WalletModelFactory actualWalletModelFactory = WalletModelFactory();

      // Act
      WalletModel actualWalletModel = await actualWalletModelFactory.createNewWallet(WalletCreationRequestModel(
        index: 0,
        parentFilesystemPath: FilesystemPath.fromString('7d871464-f352-432d-ad70-b001b38a17c9'),
        network: 'kira',
        derivationPath: "m/44'/118'/0'/0/0",
        publicKey: Uint8List.fromList(hex.decode('0252dab3c089ea59b9c9927c87453942ef67cd5be0bec9201ee5113c1de3bd4c7c')),
      ));

      // Assert
      expect(actualWalletModel.index, 0);
      expect(actualWalletModel.address, 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx');
      expect(actualWalletModel.derivationPath, "m/44'/118'/0'/0/0");
      expect(actualWalletModel.uuid, isNotNull);
    });
  });

  group('Tests of WalletModelFactory.createFromEntity()', () {
    test('Should [return WalletModel] with values from given WalletEntity', () {
      // Arrange
      WalletModelFactory actualWalletModelFactory = WalletModelFactory();
      WalletEntity actualWalletEntity = WalletEntity(
        pinnedBool: false,
        encryptedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
      );

      // Act
      WalletModel actualWalletModel = actualWalletModelFactory.createFromEntity(actualWalletEntity);

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        pinnedBool: false,
        encryptedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'kira',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        filesystemPath: FilesystemPath.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6/4e66ba36-966e-49ed-b639-191388ce38de'),
        name: 'WALLET 0',
      );

      expect(actualWalletModel, expectedWalletModel);
    });
  });
}
