import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/media_processor.dart';
import 'package:snggle/shared/utils/app_logger.dart';

class QRCodeCubit extends Cubit<String> {
  QRCodeCubit() : super('');

  Future<void> fetchMemoryQrCode() async {
    final PlatformFile? mediaFilePicked = await _pickMediaFile();

    final String mediaFilePath = mediaFilePicked!.path!;
    final String mediaFileExtension = mediaFilePicked.extension!.toLowerCase();

    if (!_isMediaExtensionAllowed(mediaFileExtension)) {
      AppLogger().log(message: 'Unsupported media extension: $mediaFileExtension');
      return;
    } else {
      String? mediaFileValueString = await _extractMediaFileValue(mediaFilePath, mediaFileExtension);
      if (mediaFileValueString != null || mediaFileValueString!.isNotEmpty) {
        emit(state + mediaFileValueString);
      }
    }
  }

  Future<PlatformFile?> _pickMediaFile() async {
    final MediaProcessor mediaProcessor = MediaProcessor();
    return mediaProcessor.getMediaFile();
  }

  bool _isMediaExtensionAllowed(String mediaFileExtension) {
    return MediaProcessor.allowedExtensions.contains(mediaFileExtension);
  }

  Future<String?> _extractMediaFileValue(String mediaFilePath, String mediaFileExtension) async {
    final MediaProcessor mediaProcessor = MediaProcessor();
    try {
      String mediaFileValueString = await mediaProcessor.extractMediaFile(mediaFilePath, mediaFileExtension);

      if (mediaFileValueString.isEmpty) {
        AppLogger().log(message: 'The content of media file is empty: $mediaFileValueString');
        return null;
      } else {
        return mediaFileValueString;
      }
    } catch (error) {
      AppLogger().log(message: 'Error processing media file: $error');
      return null;
    }
  }
}
