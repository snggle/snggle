import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/multi_qr_code_utils.dart';

void main() {
  const String actualDataString = 'Lorem ipsum dolor sit amet consectetur adipiscing eli sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';

  group('Tests of MultiQrCodeUtils.splitQrCodeData()', () {
    test('Should return a structured data, with max character length of 200 characters', () {
      // Act
      List<String> actualSplitData = MultiQrCodeUtils.splitQrCodeData(dataString: actualDataString);

      // Assert
      List<String> expectedSplitData = <String>[
        '["","",1,1,"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQgY29uc2VjdGV0dXIgYWRpcGlzY2luZyBlbGkgc2VkIGRvIGVpdXNtb2QgdGVtcG9yIGluY2lkaWR1bnQgdXQgbGFib3JlIGV0IGRvbG9yZSBtYWduYSBhbGlxdWE="]',
      ];

      expect(actualSplitData, expectedSplitData);
    });

    test('Should return structured split data with a name and type specified', () {
      // Act
      List<String> actualSplitData = MultiQrCodeUtils.splitQrCodeData(dataString: actualDataString, maxCharacters: 10, name: 'file transfer', type: '.pdf');

      // Assert
      List<String> expectedSplitData = <String>[
        '["file transfer",".pdf",1,16,"TG9yZW0gaX"]',
        '["","",2,16,"BzdW0gZG9s"]',
        '["","",3,16,"b3Igc2l0IG"]',
        '["","",4,16,"FtZXQgY29u"]',
        '["","",5,16,"c2VjdGV0dX"]',
        '["","",6,16,"IgYWRpcGlz"]',
        '["","",7,16,"Y2luZyBlbG"]',
        '["","",8,16,"kgc2VkIGRv"]',
        '["","",9,16,"IGVpdXNtb2"]',
        '["","",10,16,"QgdGVtcG9y"]',
        '["","",11,16,"IGluY2lkaW"]',
        '["","",12,16,"R1bnQgdXQg"]',
        '["","",13,16,"bGFib3JlIG"]',
        '["","",14,16,"V0IGRvbG9y"]',
        '["","",15,16,"ZSBtYWduYS"]',
        '["","",16,16,"BhbGlxdWE="]'
      ];

      expect(actualSplitData, expectedSplitData);
    });

    test('Should throw assertion error for when maxCharacters <= 0', () {
      //  Assert
      expect(
          () => MultiQrCodeUtils.splitQrCodeData(
                dataString: actualDataString,
                maxCharacters: 0,
                name: 'file transfer',
                type: '.pdf',
              ),
          throwsA(isA<AssertionError>()));
    });
  });
}
