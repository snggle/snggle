import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/utils/enum_storage_codec.dart';

void main() {
  EnumStorageCodec<CurveType> actualCurveTypeCodec = EnumStorageCodec<CurveType>(<CurveType, String>{
    CurveType.secp256k1: 'secp256k1',
    CurveType.ed25519: 'ed25519',
  });
  EnumStorageCodec<NetworkIconType> actualNetworkIconTypeCodec = EnumStorageCodec<NetworkIconType>(<NetworkIconType, String>{
    NetworkIconType.bitcoin: 'bitcoin',
    NetworkIconType.cosmos: 'cosmos',
    NetworkIconType.ethereum: 'ethereum',
    NetworkIconType.solana: 'solana',
    NetworkIconType.unknown: 'unknown',
  });
  EnumStorageCodec<WalletType> actualWalletTypeCodec = EnumStorageCodec<WalletType>(<WalletType, String>{
    WalletType.legacy: 'legacy',
  });

  group('Tests of EnumStorageCodec.toStorageValue()', () {
    test('Should [return persisted enum id] if [CurveType enum value is not null]', () {
      // Act
      String? actualPersistedValue = actualCurveTypeCodec.toStorageValue(CurveType.secp256k1);

      // Assert
      String? expectedPersistedValue = 'secp256k1';

      expect(actualPersistedValue, expectedPersistedValue);
    });

    test('Should [return null] if [enum value is null]', () {
      // Act
      String? actualPersistedValue = actualCurveTypeCodec.toStorageValue(null);

      // Assert
      String? expectedPersistedValue;

      expect(actualPersistedValue, expectedPersistedValue);
    });
  });

  group('Tests of EnumStorageCodec.fromStorageValue()', () {
    test('Should [return enum value] if [persisted value matches explicit NetworkIconType enum id]', () {
      // Act
      NetworkIconType? actualEnumValue = actualNetworkIconTypeCodec.fromStorageValue('solana');

      // Assert
      NetworkIconType? expectedEnumValue = NetworkIconType.solana;

      expect(actualEnumValue, expectedEnumValue);
    });

    test('Should [return enum value] if [persisted value matches WalletType enum name for legacy data]', () {
      // Act
      WalletType? actualEnumValue = actualWalletTypeCodec.fromStorageValue('legacy');

      // Assert
      WalletType? expectedEnumValue = WalletType.legacy;

      expect(actualEnumValue, expectedEnumValue);
    });

    test('Should [return null] if [persisted value is null]', () {
      // Act
      CurveType? actualEnumValue = actualCurveTypeCodec.fromStorageValue(null);

      // Assert
      CurveType? expectedEnumValue;

      expect(actualEnumValue, expectedEnumValue);
    });

    test('Should [return null] if [persisted value does not match enum id or enum name]', () {
      // Act
      CurveType? actualEnumValue = actualCurveTypeCodec.fromStorageValue('unknown');

      // Assert
      CurveType? expectedEnumValue;

      expect(actualEnumValue, expectedEnumValue);
    });
  });
}
