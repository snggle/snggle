import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  PasskeyModel createPasskey() => PasskeyModel(
    id: 1,
    encryptedBool: false,
    pinnedBool: false,
    filesystemPath: FilesystemPath.fromString('passkeys/passkey1'),
    name: 'EXAMPLE',
    rpId: 'example.com',
    rpName: 'Example',
    userName: 'alice',
    userDisplayName: 'Alice',
    userId: Uint8List.fromList(<int>[1, 2, 3]),
    credentialId: Uint8List.fromList(<int>[10, 20, 30]),
    algorithm: -7,
    signCount: 0,
  );

  group('Tests of PasskeyModel.name getter', () {
    test('Should [return passkey name]', () {
      // Arrange
      PasskeyModel passkeyModel = createPasskey();

      // Act
      String actualName = passkeyModel.name;

      // Assert
      expect(actualName, 'EXAMPLE');
    });
  });

  group('Tests of PasskeyModel.defaultItemName getter', () {
    test('Should [return default passkey name]', () {
      // Arrange
      PasskeyModel passkeyModel = createPasskey();

      // Act
      String actualDefaultItemName = passkeyModel.defaultItemName;

      // Assert
      expect(actualDefaultItemName, 'Passkey');
    });
  });

  group('Tests of PasskeyModel.copyWith()', () {
    test('Should [preserve all values] if [no arguments provided]', () {
      // Arrange
      PasskeyModel passkeyModel = createPasskey();

      // Act
      PasskeyModel actualPasskeyModel = passkeyModel.copyWith();

      // Assert
      expect(actualPasskeyModel, passkeyModel);
    });

    test('Should [update specified fields] and [preserve remaining fields]', () {
      // Arrange
      PasskeyModel passkeyModel = createPasskey();

      // Act
      PasskeyModel actualPasskeyModel = passkeyModel.copyWith(
        pinnedBool: true,
        name: 'UPDATED',
        credentialId: Uint8List.fromList(<int>[99, 88]),
        signCount: 5,
      );

      // Assert
      PasskeyModel expectedPasskeyModel = createPasskey().copyWith(
        pinnedBool: true,
        name: 'UPDATED',
        credentialId: Uint8List.fromList(<int>[99, 88]),
        signCount: 5,
      );
      expect(actualPasskeyModel, expectedPasskeyModel);
      expect(passkeyModel.pinnedBool, false);
      expect(passkeyModel.signCount, 0);
      expect(actualPasskeyModel.rpId, 'example.com');
      expect(actualPasskeyModel.filesystemPath, FilesystemPath.fromString('passkeys/passkey1'));
    });
  });
}
