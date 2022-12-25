import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/entity/vaults/vault_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_safe_secrets_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_unsafe_secrets_entity.dart';
import 'package:snuggle/infra/repositories/vaults_repository.dart';
import 'package:snuggle/infra/secure_collection_manager.dart';

import '../../../mocks/mock_storage_manager.dart';

void main() {
  late MockStorageManager actualMockStorageManager;
  late SecureCollectionManager<VaultEntity> actualVaultsSecureCollectionManager;
  late VaultsRepository actualVaultsRepository;

  setUp(() async {
    // @formatter:off
      actualMockStorageManager = MockStorageManager( mockStorage: <String, String>{'vaults': 'UM9OoAaMaUKese0qbcdml1bNKN+jT1NkuexwIfEQVipLbLacU/m1YaVYq4I/LUBr490a8Zyke721g87E8EqVH8/qddDjurwbn3pw8c2QXCmr8IDpaSsxkrKaBItIC+C+11KDktRS5VJjgW9LVcMAmHqVnYKVRSOFaZXEnwgSPh5ZCAnXPoaV7LNfQZ8nEeC5lerIClJmL6T4Ab3POS/cyEoFtP/Ysqj1hzuEJ1yZyqzwX0m2YH60PHzIoBwKLiy046Wcm4AyXRqcOwAiwwUD5Vqdgeyb2QLBWzVQiaIwE/be102WR5FGHWpJTxj+VxEu9tYJ3iOCTE7AMTLHJOrxlwdNYZWO42goSIaVXvMVaFDIyaK6bLZHS0Ca5mlrcPhuU2iOrAlyOD9O+QDsg0vKxU8sOsbKn6K6PyMQU+zZyAYNFDEdd0OlU6H0pcjd87Xw/DCMuGMGDrftr9+/QYDPJi7p7KgCAZ/RySHH9JWgiYv59apBhSurbeZbj2GJLX5Od2Z4hBgnOPwOlnJAl3TmSzYSbGr0AEgORZtjQr88AUqZmTOXVtKIF3r3tTrznOfWxUmO7cYFSuBg4RCmhVv7168V6ta+iUaNrsH48CpgWY1tWnMa1tgGF/y51kCaYEtoMb8IAyJYXjeQ8O5tcNSrm3GHBTzrHyMVk5yVGYh7LUvFAxE68BbibLaVgoD+YaZvu50u/vKhpYbmnGSJytx8LpZ4fv7iF2Ig0DIHt1+WmUQ7otFVWCEe4NO2rlMmTA5KJbIM/HInApinHMyA/jG8aBjzuPl4ffrsTW8CYHT/qgjl4Y21piSIEtuZsE6YXclD5Vrpsn78Cx9pQJi/YKeCzX0zWm3rBoMYiwRPsXkmgLxFzzLyYcK9TwAdqDprLQkQ7zaknmbo5ixRINs4gvUseH60hWjwVmEV7js2wxodH8KEYj6odspL2GA5OuOkxgrnr5rhMzL6NA1HgDTmJgRIi29KKk+s9VaxaznvZ8jBwfYF2gtzYv2AzAmWfe9kQLPB35t9rGCzIJcVlyih70c9OW9++6Ro1k2iO5CjWes0Vs7cKlfyGg+Rws3xTN/oRFDvrGY46V1ihCy1skIxPyxgM1TSkI2eDZ/ZCkvoZhk8V+FNGBcUGnTjxW+IXnIfvZXjFTnMjA7kHabgRgv65dqek9NuXtzisLfjyH0q9euaQ51H/rX0sM7QPR/JysOyu0BIB8iImQ=='});
    // @formatter:on

    actualVaultsSecureCollectionManager = SecureCollectionManager<VaultEntity>(
      password: '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0',
      storageKey: 'vaults',
      storageManager: actualMockStorageManager,
      entityJsonFactory: VaultEntity.fromJson,
    );

    actualVaultsRepository = VaultsRepository(vaultsSecureCollectionManager: actualVaultsSecureCollectionManager);
  });

  group('Tests of VaultsRepository.deleteById()', () {
    test('Should return all vaults without deleted entity', () async {
      // Act
      await actualVaultsRepository.deleteById('92b43ace-5439-4269-8e27-e999907f4379');
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

  group('Tests of VaultsRepository.getAll()', () {
    test('Should return all vaults from storage', () async {
      // Act
      List<VaultEntity> actualVaultEntityList = await actualVaultsRepository.getAll();

      // Assert
      // @formatter:off
        List<VaultEntity> expectedVaultEntityList = <VaultEntity>[
          const VaultEntity(
            uuid: '92b43ace-5439-4269-8e27-e999907f4379',
            name: 'Test Vault 1',
            vaultSecretsEntity: VaultSafeSecretsEntity(hash: 'hNlWO3+NfZreGGAKA0aYAagYKB9pNqG0RQDkDXBMT3PeM6mqn1oyZaoKClrtl+qbHQlAUER4ZE4QQMho+A+U6cFBmmSXJtxFS9Bpa74Tc/FSuQwHkhppKZI7IcTDmEHNCrxxnxFXTc6Ha/9b5rulVYgM2ccvcm1kMUZ0T/ZdhflwD7N9l0IQsA4/YkcyUdRm6YVK5kDf/Fl2YhtKAHJV5ftSng+AWOqOGVC8gVcFcc6bsMsgOFpHiM3zXsWuFNGoxpyQifrrp+Ix39QytGDhPgAXTZbbD4D7k++H82RCcKWky7OtUF2lRFqj9MuGH992SFT3siISr/gmPI/lMQZgaGRvGIGkPbIx+Ex+WPCqqMh2ZUQ9'),
          ),
          VaultEntity(
            uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
            name: 'Test Vault 2',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
        ];
      // @formatter:on

      expect(actualVaultEntityList, expectedVaultEntityList);
    });
  });

  group('Tests of VaultsRepository.getById()', () {
    test('Should return VaultEntity with specified id', () async {
      // Arrange
      String actualVaultId = '92b43ace-5439-4269-8e27-e999907f4379';

      // Act
      VaultEntity actualVaultEntity = await actualVaultsRepository.getById(actualVaultId);

      // Assert
      // @formatter:off
        VaultEntity expectedVaultEntity = const VaultEntity(
          uuid: '92b43ace-5439-4269-8e27-e999907f4379',
          name: 'Test Vault 1',
          vaultSecretsEntity: VaultSafeSecretsEntity(hash: 'hNlWO3+NfZreGGAKA0aYAagYKB9pNqG0RQDkDXBMT3PeM6mqn1oyZaoKClrtl+qbHQlAUER4ZE4QQMho+A+U6cFBmmSXJtxFS9Bpa74Tc/FSuQwHkhppKZI7IcTDmEHNCrxxnxFXTc6Ha/9b5rulVYgM2ccvcm1kMUZ0T/ZdhflwD7N9l0IQsA4/YkcyUdRm6YVK5kDf/Fl2YhtKAHJV5ftSng+AWOqOGVC8gVcFcc6bsMsgOFpHiM3zXsWuFNGoxpyQifrrp+Ix39QytGDhPgAXTZbbD4D7k++H82RCcKWky7OtUF2lRFqj9MuGH992SFT3siISr/gmPI/lMQZgaGRvGIGkPbIx+Ex+WPCqqMh2ZUQ9'),
        );
      // @formatter:on

      expect(actualVaultEntity, expectedVaultEntity);
    });
  });

  group('Tests of VaultsRepository.save()', () {
    test('Should return all vaults with updated entity', () async {
      // @formatter:off
        
        // Arrange
        VaultEntity actualUpdatedVaultEntity = VaultEntity(
          uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          name: 'UPDATED VAULT',
          vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
        );

        // Act
        await actualVaultsRepository.save(actualUpdatedVaultEntity);
        Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

        // Assert
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

    test('Should return all vaults with created entity', () async {
      // @formatter:off
        
        // Arrange
        VaultEntity actualNewVaultEntity = VaultEntity(
          uuid: '6fff46df-7c31-4fd2-8259-48b32b2ef7d5',
          name: 'Test Vault 3',
          vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
        );

        // Act
        await actualVaultsRepository.save(actualNewVaultEntity);
        Map<String, VaultEntity> actualCollectionCache = actualVaultsSecureCollectionManager.decryptedCollectionCache;

        // Assert
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
          '6fff46df-7c31-4fd2-8259-48b32b2ef7d5': VaultEntity(
            uuid: '6fff46df-7c31-4fd2-8259-48b32b2ef7d5',
            name: 'Test Vault 3',
            vaultSecretsEntity: VaultUnsafeSecretsEntity(seed: Uint8List.fromList(<int>[188,234,92,126,140,162,114,55,230,79,110,198,81,183,192,102,151,165,176,166,115,23,132,85,66,118,238,149,160,228,1,204,125,252,55,180,88,125,211,211,18,103,180,31,64,203,7,44,212,5,111,147,152,130,20,124,78,29,252,141,184,4,209,37])),
          ),
        };
      // @formatter:on

      expect(actualCollectionCache, expectedCollectionCache);
    });
  });
}
