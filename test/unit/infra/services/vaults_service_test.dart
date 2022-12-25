import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/dto/vaults/save_vault_request.dart';
import 'package:snuggle/infra/entity/vaults/i_vault_secrets_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_safe_secrets_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_unsafe_secrets_entity.dart';
import 'package:snuggle/infra/repositories/vaults_repository.dart';
import 'package:snuggle/infra/secure_collection_manager.dart';
import 'package:snuggle/infra/services/vaults_service.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snuggle/shared/models/vaults/vault_model.dart';
import 'package:snuggle/shared/models/vaults/vault_safe_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_unsafe_secrets_model.dart';

import '../../../mocks/mock_storage_manager.dart';

void main() {
  late MockStorageManager actualMockStorageManager;
  late SecureCollectionManager<VaultEntity> actualVaultsSecureCollectionManager;
  late VaultsRepository actualVaultsRepository;
  late VaultsService actualVaultsService;

  setUp(() async {
    // @formatter:off
      actualMockStorageManager = MockStorageManager( mockStorage: <String, String>{ 'vaults': 'UM9OoAaMaUKese0qbcdml1bNKN+jT1NkuexwIfEQVipLbLacU/m1YaVYq4I/LUBr490a8Zyke721g87E8EqVH8/qddDjurwbn3pw8c2QXCmr8IDpaSsxkrKaBItIC+C+11KDktRS5VJjgW9LVcMAmHqVnYKVRSOFaZXEnwgSPh5ZCAnXPoaV7LNfQZ8nEeC5lerIClJmL6T4Ab3POS/cyEoFtP/Ysqj1hzuEJ1yZyqzwX0m2YH60PHzIoBwKLiy046Wcm4AyXRqcOwAiwwUD5Vqdgeyb2QLBWzVQiaIwE/be102WR5FGHWpJTxj+VxEu9tYJ3iOCTE7AMTLHJOrxlwdNYZWO42goSIaVXvMVaFDIyaK6bLZHS0Ca5mlrcPhuU2iOrAlyOD9O+QDsg0vKxU8sOsbKn6K6PyMQU+zZyAYNFDEdd0OlU6H0pcjd87Xw/DCMuGMGDrftr9+/QYDPJi7p7KgCAZ/RySHH9JWgiYv59apBhSurbeZbj2GJLX5Od2Z4hBgnOPwOlnJAl3TmSzYSbGr0AEgORZtjQr88AUqZmTOXVtKIF3r3tTrznOfWxUmO7cYFSuBg4RCmhVv7168V6ta+iUaNrsH48CpgWY1tWnMa1tgGF/y51kCaYEtoMb8IAyJYXjeQ8O5tcNSrm3GHBTzrHyMVk5yVGYh7LUvFAxE68BbibLaVgoD+YaZvu50u/vKhpYbmnGSJytx8LpZ4fv7iF2Ig0DIHt1+WmUQ7otFVWCEe4NO2rlMmTA5KJbIM/HInApinHMyA/jG8aBjzuPl4ffrsTW8CYHT/qgjl4Y21piSIEtuZsE6YXclD5Vrpsn78Cx9pQJi/YKeCzX0zWm3rBoMYiwRPsXkmgLxFzzLyYcK9TwAdqDprLQkQ7zaknmbo5ixRINs4gvUseH60hWjwVmEV7js2wxodH8KEYj6odspL2GA5OuOkxgrnr5rhMzL6NA1HgDTmJgRIi29KKk+s9VaxaznvZ8jBwfYF2gtzYv2AzAmWfe9kQLPB35t9rGCzIJcVlyih70c9OW9++6Ro1k2iO5CjWes0Vs7cKlfyGg+Rws3xTN/oRFDvrGY46V1ihCy1skIxPyxgM1TSkI2eDZ/ZCkvoZhk8V+FNGBcUGnTjxW+IXnIfvZXjFTnMjA7kHabgRgv65dqek9NuXtzisLfjyH0q9euaQ51H/rX0sM7QPR/JysOyu0BIB8iImQ=='});
    // @formatter:on

    actualVaultsSecureCollectionManager = SecureCollectionManager<VaultEntity>(
      entityJsonFactory: VaultEntity.fromJson,
      password: '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0',
      storageKey: 'vaults',
      storageManager: actualMockStorageManager,
    );

    actualVaultsRepository = VaultsRepository(vaultsSecureCollectionManager: actualVaultsSecureCollectionManager);
    actualVaultsService = VaultsService(vaultsRepository: actualVaultsRepository);
  });

  group('Tests of VaultsService.deleteVaultById()', () {
    test('Should return collection cache without removed vault', () async {
      // Act
      await actualVaultsService.deleteVaultById('92b43ace-5439-4269-8e27-e999907f4379');
      Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

      // Assert
      // @formatter:off
        Map<String, VaultEntity> expectedCollectionCache = <String, VaultEntity>{
          'b1c2f688-85fc-43ba-9af1-52db40fa3093': VaultEntity(
            uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
            name: 'Test Vault 2',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
        };
      // @formatter:on

      expect(actualCollectionCache, expectedCollectionCache);
    });
  });

  group('Tests of VaultsService.decryptVault()', () {
    test('Should decrypt VaultSafeSecretsModel using provided password and return VaultUnsafeSecretsEntity', () async {
      // Arrange
      VaultModel encryptedVaultModel = const VaultModel(
        uuid: '92b43ace-5439-4269-8e27-e999907f4379',
        name: 'Test Vault 1',
        vaultSecretsModel: VaultSafeSecretsModel(
            hash:
                'hNlWO3+NfZreGGAKA0aYAagYKB9pNqG0RQDkDXBMT3PeM6mqn1oyZaoKClrtl+qbHQlAUER4ZE4QQMho+A+U6cFBmmSXJtxFS9Bpa74Tc/FSuQwHkhppKZI7IcTDmEHNCrxxnxFXTc6Ha/9b5rulVYgM2ccvcm1kMUZ0T/ZdhflwD7N9l0IQsA4/YkcyUdRm6YVK5kDf/Fl2YhtKAHJV5ftSng+AWOqOGVC8gVcFcc6bsMsgOFpHiM3zXsWuFNGoxpyQifrrp+Ix39QytGDhPgAXTZbbD4D7k++H82RCcKWky7OtUF2lRFqj9MuGH992SFT3siISr/gmPI/lMQZgaGRvGIGkPbIx+Ex+WPCqqMh2ZUQ9'),
      );

      // Act
      await actualVaultsService.decryptVault(encryptedVaultModel, '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
      Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

      // Assert
      // @formatter:off
        Map<String, VaultEntity> expectedCollectionCache = <String, VaultEntity>{
          '92b43ace-5439-4269-8e27-e999907f4379': VaultEntity(
            uuid: '92b43ace-5439-4269-8e27-e999907f4379',
            name: 'Test Vault 1',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[38,76,159,233,134,191,239,65,143,237,226,146,226,204,52,9,41,88,198,78,127,17,7,189,229,188,149,26,125,108,131,188,102,138,162,15,141,194,249,165,251,119,7,57,27,11,39,97,210,119,204,110,21,227,251,224,200,52,188,156,168,65,180,239])),
          ),
          'b1c2f688-85fc-43ba-9af1-52db40fa3093': VaultEntity(
            uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
            name: 'Test Vault 2',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
        };
      // @formatter:on

      expect(actualCollectionCache, expectedCollectionCache);
    });
  });

  group('Tests of VaultsService.encryptVault()', () {
    test('Should encrypt VaultUnsafeSecretsModel with provided password and return VaultSafeSecretsEntity', () async {
      // Arrange
      // @formatter:off
        VaultModel actualDecryptedVaultModel = VaultModel(
          uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          name: 'Test Vault 2',
          vaultSecretsModel: VaultUnsafeSecretsModel(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
        );
      // @formatter:on

      // Act
      await actualVaultsService.encryptVault(actualDecryptedVaultModel, 'password');
      Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

      // Assert
      IVaultSecretsEntity? vaultSecretsEntity = actualCollectionCache['b1c2f688-85fc-43ba-9af1-52db40fa3093']?.vaultSecretsEntity;

      // Output is always random String because our hashing method changing initialization vector using Random Secure
      // and we cannot match the hardcoded expected result.
      // So we just check if the result type is not equal expected.
      expect(vaultSecretsEntity, isA<VaultSafeSecretsEntity>());
    });
  });

  group('Tests of VaultsService.getVaultListItems()', () {
    test('Should return list of all VaultListItemModels', () async {
      // Act
      List<VaultListItemModel> actualVaultListItemList = await actualVaultsService.getVaultListItems();

      // Assert
      // @formatter:off
        List<VaultListItemModel> expectedVaultListItem = <VaultListItemModel>[
          const VaultListItemModel(
            vaultModel: VaultModel(
              uuid: '92b43ace-5439-4269-8e27-e999907f4379',
              name: 'Test Vault 1',
              vaultSecretsModel: VaultSafeSecretsModel(hash: 'hNlWO3+NfZreGGAKA0aYAagYKB9pNqG0RQDkDXBMT3PeM6mqn1oyZaoKClrtl+qbHQlAUER4ZE4QQMho+A+U6cFBmmSXJtxFS9Bpa74Tc/FSuQwHkhppKZI7IcTDmEHNCrxxnxFXTc6Ha/9b5rulVYgM2ccvcm1kMUZ0T/ZdhflwD7N9l0IQsA4/YkcyUdRm6YVK5kDf/Fl2YhtKAHJV5ftSng+AWOqOGVC8gVcFcc6bsMsgOFpHiM3zXsWuFNGoxpyQifrrp+Ix39QytGDhPgAXTZbbD4D7k++H82RCcKWky7OtUF2lRFqj9MuGH992SFT3siISr/gmPI/lMQZgaGRvGIGkPbIx+Ex+WPCqqMh2ZUQ9'),
            ),
          ),
          VaultListItemModel(
            vaultModel: VaultModel(
              uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
              name: 'Test Vault 2',
              vaultSecretsModel: VaultUnsafeSecretsModel(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
            ),
          ),
        ];
      // @formatter:on

      expect(actualVaultListItemList, expectedVaultListItem);
    });
  });

  group('Tests of VaultsService.saveVault()', () {
    test('Should return collection cache with updated vault', () async {
      // Arrange
      // @formatter:off
        SaveVaultRequest saveVaultRequest = SaveVaultRequest(
          uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          name: 'UPDATED VAULT',
          vaultSecretsModel: VaultUnsafeSecretsModel(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
        );
      // @formatter:on

      // Act
      await actualVaultsService.saveVault(saveVaultRequest);
      Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

      // Assert
        // @formatter:off
        Map<String, VaultEntity> expectedCollectionCache = <String, VaultEntity>{
          '92b43ace-5439-4269-8e27-e999907f4379': const VaultEntity(
            uuid: '92b43ace-5439-4269-8e27-e999907f4379',
            name: 'Test Vault 1',
            vaultSecretsEntity: VaultSafeSecretsEntity(hash: 'hNlWO3+NfZreGGAKA0aYAagYKB9pNqG0RQDkDXBMT3PeM6mqn1oyZaoKClrtl+qbHQlAUER4ZE4QQMho+A+U6cFBmmSXJtxFS9Bpa74Tc/FSuQwHkhppKZI7IcTDmEHNCrxxnxFXTc6Ha/9b5rulVYgM2ccvcm1kMUZ0T/ZdhflwD7N9l0IQsA4/YkcyUdRm6YVK5kDf/Fl2YhtKAHJV5ftSng+AWOqOGVC8gVcFcc6bsMsgOFpHiM3zXsWuFNGoxpyQifrrp+Ix39QytGDhPgAXTZbbD4D7k++H82RCcKWky7OtUF2lRFqj9MuGH992SFT3siISr/gmPI/lMQZgaGRvGIGkPbIx+Ex+WPCqqMh2ZUQ9'),
          ),
          'b1c2f688-85fc-43ba-9af1-52db40fa3093': VaultEntity(
            uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
            name: 'UPDATED VAULT',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
        };
      // @formatter:on

      expect(actualCollectionCache, expectedCollectionCache);
    });

    test('Should return collection cache with created vault', () async {
      // Arrange
      // @formatter:off
        SaveVaultRequest saveVaultRequest = SaveVaultRequest(
          uuid: '6fff46df-7c31-4fd2-8259-48b32b2ef7d5 ',
          name: 'Test Vault 3',
          vaultSecretsModel: VaultUnsafeSecretsModel(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
        );
      // @formatter:on

      // Act
      await actualVaultsService.saveVault(saveVaultRequest);
      Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

      // Assert
        // @formatter:off
        Map<String, VaultEntity> expectedCollectionCache = <String, VaultEntity>{
          '92b43ace-5439-4269-8e27-e999907f4379': const VaultEntity(
            uuid: '92b43ace-5439-4269-8e27-e999907f4379',
            name: 'Test Vault 1',
            vaultSecretsEntity: VaultSafeSecretsEntity(hash: 'hNlWO3+NfZreGGAKA0aYAagYKB9pNqG0RQDkDXBMT3PeM6mqn1oyZaoKClrtl+qbHQlAUER4ZE4QQMho+A+U6cFBmmSXJtxFS9Bpa74Tc/FSuQwHkhppKZI7IcTDmEHNCrxxnxFXTc6Ha/9b5rulVYgM2ccvcm1kMUZ0T/ZdhflwD7N9l0IQsA4/YkcyUdRm6YVK5kDf/Fl2YhtKAHJV5ftSng+AWOqOGVC8gVcFcc6bsMsgOFpHiM3zXsWuFNGoxpyQifrrp+Ix39QytGDhPgAXTZbbD4D7k++H82RCcKWky7OtUF2lRFqj9MuGH992SFT3siISr/gmPI/lMQZgaGRvGIGkPbIx+Ex+WPCqqMh2ZUQ9'),
          ),
          'b1c2f688-85fc-43ba-9af1-52db40fa3093': VaultEntity(
            uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
            name: 'Test Vault 2',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
          '6fff46df-7c31-4fd2-8259-48b32b2ef7d5 ': VaultEntity(
            uuid: '6fff46df-7c31-4fd2-8259-48b32b2ef7d5 ',
            name: 'Test Vault 3',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
        };
      // @formatter:on

      expect(actualCollectionCache, expectedCollectionCache);
    });
  });
}