import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:snggle/shared/utils/app_logger.dart';
import 'package:zxing2/qrcode.dart';

class MediaProcessor {
  static const List<String> allowedExtensions = <String>['gif', 'jpeg', 'jpg', 'mp4', 'pdf', 'png'];

  Future<String> extractMediaFile(String filePath, String extension) async {
    try {
      if (extension == 'gif') {
        final List<img.Image>? gifFrames = await _decodeGif(filePath);
        return await _processGifFrames(gifFrames);
      } else if (extension == 'mp4') {
        return _decodeVideo(filePath);
      } else {
        return _decodeImage(filePath);
      }
    } catch (error) {
      AppLogger().log(message: 'Failed to extract medial file: $error');
    }
    return '';
  }

  Future<PlatformFile?> getMediaFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    return result?.files.first;
  }

  Future<List<img.Image>?> _decodeGif(String filePath) async {
    final Uint8List gifDataBytes = await File(filePath).readAsBytes();
    return img.GifDecoder().decode(gifDataBytes)?.frames;
  }

  Future<String> _processGifFrames(List<img.Image>? gifFramesImageList) async {
    StringBuffer gifDataStringBuffer = StringBuffer();
    if (gifFramesImageList != null) {
      for (final img.Image gifImage in gifFramesImageList) {
        final Result? qrCodeResult = await _decodeQRCode(gifImage);
        gifDataStringBuffer.write(
          qrCodeResult.toString(),
        );
      }
      return gifDataStringBuffer.toString();
    } else {
      AppLogger().log(message: 'Failed to decode gif: gifFrames return null');
    }
    return '';
  }

  Future<Result?> _decodeQRCode(img.Image image) async {
    try {
      final QRCodeReader qrCodeReader = QRCodeReader();
      final RGBLuminanceSource grayScaleQrCode = RGBLuminanceSource(image.width, image.height, image.convert(numChannels: 4).getBytes(order: img.ChannelOrder.abgr).buffer.asInt32List());
      final BinaryBitmap qrCodeImageBitmap = BinaryBitmap(GlobalHistogramBinarizer(grayScaleQrCode));

      return qrCodeReader.decode(qrCodeImageBitmap);
    } catch (error) {
      AppLogger().log(message: 'QrcodeReader failed to decode: $error');
    }
    return Result('', null, BarcodeFormat.qrCode);
  }

  Future<String> _decodeVideo(String filePath) async {
    String outputFilePath = '${Directory.systemTemp.path}/video_frame_%d.png';
    AppLogger().log(message: 'Output Path\n$outputFilePath');
    return _extractVideoFrames(filePath, outputFilePath);
  }

  Future<String> _extractVideoFrames(String filePath, String outputFilePath) async {
    Completer<String> completer = Completer<String>();
    await FFmpegKit.executeAsync(
      '-i $filePath -vf "fps=1" $outputFilePath',
      (FFmpegSession session) async {
        completer.complete(
          await _videoExtractionCompletedSession(session),
        );
      },
    );
    return completer.future;
  }

  Future<String> _videoExtractionCompletedSession(FFmpegSession session) async {
    AppLogger().log(message: 'FFmpeg session completed');
    ReturnCode? returnCode = await session.getReturnCode();

    if (returnCode != null && returnCode.isValueSuccess()) {
      AppLogger().log(message: 'FFmpeg operation was successful');
      StringBuffer qrCodeDataStringBuffer = await _processVideoFrames();
      return qrCodeDataStringBuffer.toString();
    } else {
      AppLogger().log(message: 'FFmpeg operation failed with return code: $returnCode');
      return '';
    }
  }

  Future<StringBuffer> _processVideoFrames() async {
    List<FileSystemEntity> videoFramesList = await _retrieveTemporaryFrames();

    StringBuffer framesDataStringBuffer = StringBuffer();
    for (FileSystemEntity videoFrame in videoFramesList) {
      Uint8List framesBytes = await File(videoFrame.path).readAsBytes();
      img.Image? frameImage = img.decodeImage(framesBytes);
      if (frameImage != null) {
        Result? qrCodeResult = await _decodeQRCode(frameImage);
        if (qrCodeResult != null && qrCodeResult.text.isNotEmpty) {
          framesDataStringBuffer.write(qrCodeResult.toString());
        } else {
          AppLogger().log(message: 'QRCode decode failed');
          break;
        }
      }
      await videoFrame.delete();
    }
    return framesDataStringBuffer;
  }

  Future<List<FileSystemEntity>> _retrieveTemporaryFrames() async {
    Directory tempVideoFramesDir = Directory(Directory.systemTemp.path);
    List<FileSystemEntity> videoFramesList = await tempVideoFramesDir.list(followLinks: false).where(
      (FileSystemEntity entity) {
        return entity is File && (entity.path.endsWith('.png')) && (entity.path.contains(RegExp(r'video_frame_\d+\.png')));
      },
    ).toList();
    return videoFramesList;
  }

  Future<String> _decodeImage(String filePath) async {
    final Uint8List imageDataBytes = await File(filePath).readAsBytes();
    img.Image? fileImage;

    try {
      fileImage = img.decodeImage(imageDataBytes);
    } catch (error) {
      AppLogger().log(message: 'Failed to decode image: $error');
    }
    if (fileImage == null) {
      AppLogger().log(message: 'Image file is null');
      return '';
    }

    final Result? qrCodeResult = await _decodeQRCode(fileImage);
    if (qrCodeResult.toString().isEmpty) {
      AppLogger().log(message: 'Failed to decode qrcode: Image file exists but inner qrCode data is empty');
      return '';
    }
    return qrCodeResult.toString();
  }
}
