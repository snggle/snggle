import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/entities/salt_entity.dart';
import 'package:snggle/infra/repositories/salt_repository.dart';

void main() {
  SaltRepository actualSaltRepository = SaltRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of SaltRepository.isSaltExist()', () {
    test('Should return false if [salt] not exists in database', () async {
      //  Act
      bool actualIsSaltExists = await actualSaltRepository.isSaltExist();

      // Assert
      expect(actualIsSaltExists, false);
    });

    test('Should return true if [salt] exists in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        DatabaseEntryKey.salt.name: '{"isDefaultPassword": true, "value": "68nKAaQvnMh5Aq8zQClQXkAmivGym3FsGVz72z3Q2BeAU0wfEKnNcsfzi0FA6zCTrBEhA4VJ5ElZqOAkTdUD112/HDzOLGIZtH1Gw2eLG2rDhun2A+sAkpubXLCpqdmWMIlM5g=="}',
      });

      // Act
      bool actualSaltExistValue = await actualSaltRepository.isSaltExist();

      //  Assert
      expect(actualSaltExistValue, true);
    });
  });

  group('Tests of SaltRepository.getSaltEntity()', () {
    test('Should throw Exception, as [salt] is not initialized and does not exist when receiving from database', () async {
      try {
        // Act
        await actualSaltRepository.getSaltEntity();
      } on Exception catch (actualException) {
        // Assert
        Exception expectedException = Exception('No data found for key: salt');

        expect(actualException.toString(), expectedException.toString());
      }
    });

    test('Should return SaltEntity if [salt] exists in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        DatabaseEntryKey.salt.name: '{"isDefaultPassword": true, "value": "68nKAaQvnMh5Aq8zQClQXkAmivGym3FsGVz72z3Q2BeAU0wfEKnNcsfzi0FA6zCTrBEhA4VJ5ElZqOAkTdUD112/HDzOLGIZtH1Gw2eLG2rDhun2A+sAkpubXLCpqdmWMIlM5g=="}',
      });

      //  Act
      SaltEntity actualSaltEntity = await actualSaltRepository.getSaltEntity();

      // Assert
      SaltEntity expectedSaltEntity = const SaltEntity(
        value: '68nKAaQvnMh5Aq8zQClQXkAmivGym3FsGVz72z3Q2BeAU0wfEKnNcsfzi0FA6zCTrBEhA4VJ5ElZqOAkTdUD112/HDzOLGIZtH1Gw2eLG2rDhun2A+sAkpubXLCpqdmWMIlM5g==',
        isDefaultPassword: true,
      );

      expect(actualSaltEntity, expectedSaltEntity);
    });
  });

  group('Tests of SaltRepository.setSaltEntity()', () {
    test('Should return SaltEntity as a string after setting [salt] in database', () async {
      // Arrange
      SaltEntity actualSaltEntity = const SaltEntity(
        value: '68nKAaQvnMh5Aq8zQClQXkAmivGym3FsGVz72z3Q2BeAU0wfEKnNcsfzi0FA6zCTrBEhA4VJ5ElZqOAkTdUD112/HDzOLGIZtH1Gw2eLG2rDhun2A+sAkpubXLCpqdmWMIlM5g==',
        isDefaultPassword: true,
      );

      // Act
      await actualSaltRepository.setSaltEntity(saltEntity: actualSaltEntity);
      String? actualSaltValue = await flutterSecureStorage.read(key: DatabaseEntryKey.salt.name);

      // Assert
      String expectedSaltValue = '{"isDefaultPassword":true,"value":"68nKAaQvnMh5Aq8zQClQXkAmivGym3FsGVz72z3Q2BeAU0wfEKnNcsfzi0FA6zCTrBEhA4VJ5ElZqOAkTdUD112/HDzOLGIZtH1Gw2eLG2rDhun2A+sAkpubXLCpqdmWMIlM5g=="}';

      expect(actualSaltValue, expectedSaltValue);
    });
  });
}
