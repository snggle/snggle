import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/media_processor.dart';

void main() {
  final MediaProcessor mediaProcessor = MediaProcessor();

  group('Tests of MediaProcessor.extractMediaFile', () {
    test('Should return decoded value of qrcode image file', () async {
      // Arrange
      const String imageMediaFilePath = 'test/assets/qr_code_valid_png.png';
      String imageMediaFileExtension = imageMediaFilePath.split('.').last;

      // Act
      final String actualDecodedMediaFileValue = await mediaProcessor.extractMediaFile(imageMediaFilePath, imageMediaFileExtension);

      // Assert
      String expectedDecodedMediaFileValue = '["","",5,6,"b3N0cnVkIGV4ZXJjaXRhdGlvbiB1bGxhbWNvIGxhYm9yaXMgbmlzaSB1dCBhbGlxdWlwIGV4IGVhIGNvbW1vZG8gY29uc2VxdWF0LiBEdWlzIGF1dGUgaXJ1cmUgZG9sb3IgaW4gcmVwcmVoZW5kZXJpdCBpbiB2b2x1cHRhdGUgdmVsaXQgZXNzZSBjaWxsdW0gZG9s"]';
      expect(actualDecodedMediaFileValue, expectedDecodedMediaFileValue);
    });

    test('Should return empty value of qrcode image file', () async {
      // Arrange
      const String imageMediaFilePath = 'test/assets/qr_code_empty_data.png';
      String imageMediaFileExtension = imageMediaFilePath.split('.').last;

      // Act
      final String actualDecodedMediaFileValue = await mediaProcessor.extractMediaFile(imageMediaFilePath, imageMediaFileExtension);

      // Assert
      expect(actualDecodedMediaFileValue, isEmpty);
    });

    test('Should return empty value for Exception when media file path is invalid', () async {
      // Arrange
      const String mediaFilePath = '';
      String mediaFileExtension = mediaFilePath.split('.').last;

      // Act
      final String actualDecodedMediaFileValue = await mediaProcessor.extractMediaFile(mediaFilePath, mediaFileExtension);

      // Assert
      expect(actualDecodedMediaFileValue, isEmpty);
    });

    //  Should return decoded value of qrcode image file
    test('Should return decoded value of qr code gif file', () async {
      // Arrange
      const String gifMediaFilePath = 'test/assets/qr_code_valid_gif.gif';
      String gifMediaFileExtension = gifMediaFilePath.split('.').last;

      // Act
      final String actualDecodedMediaFileValue = await mediaProcessor.extractMediaFile(gifMediaFilePath, gifMediaFileExtension);

      // Asset
      const String expectedDecodedValue =
          '["","",4,8,"FtZXQsIGNv"]["","",4,8,"FtZXQsIGNv"]["","",4,8,"FtZXQsIGNv"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",5,8,"bnNlY3RldH"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",6,8,"VyIGFkaXBp"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",7,8,"c2NpbmcgZW"]["","",8,8,"xpdA=="]["","",8,8,"xpdA=="]["","",8,8,"xpdA=="]["","",8,8,"xpdA=="]["","",8,8,"xpdA=="]["","",8,8,"xpdA=="]["","",8,8,"xpdA=="]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["Text Transfer",".exe",1,8,"TG9yZW0gaX"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",2,8,"BzdW0gZG9s"]["","",3,8,"b3Igc2l0IG"]["","",3,8,"b3Igc2l0IG"]["","",3,8,"b3Igc2l0IG"]["","",3,8,"b3Igc2l0IG"]';
      expect(actualDecodedMediaFileValue, expectedDecodedValue);
    });
  });
}

//Should return a valid PlatformFile object for a png file'
//Should return null if no file is picked
//Should return null if user cancels file picker dialog
//Should return null if file is not of an allowed extension
//Should return null if file has no extension
