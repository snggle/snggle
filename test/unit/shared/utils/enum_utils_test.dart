import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/shared/utils/enum_utils.dart';

enum TestEnum {
  firstTest,
  secondTest,
}

void main() {
  group('Tests of enumToString() method', () {
    test('Should remove enum name from string and return enum value only', () async {
      // Act
      String actualEnumString = EnumUtils.parseToString(TestEnum.firstTest);
      
      // Assert
      String expectedEnumString = 'firstTest';
      
      expect(actualEnumString, expectedEnumString);
    });
  });
  group('Tests of enumFromString() method', () {
    test('Should return correct enum value based on enum values and name', () async {
      // Act
      TestEnum actualTestEnum = EnumUtils.parseFromString(TestEnum.values, 'firstTest');
      
      // Assert
      TestEnum expectedTestEnum = TestEnum.firstTest;
      
      expect(actualTestEnum, expectedTestEnum);
    });
  });
}
