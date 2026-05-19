import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/utils.dart';

class MediaService {
  MediaService._();
  static final MediaService instance = MediaService._();

  final ImagePicker _imagePicker = ImagePicker();

  FutureEither<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return runTask(() async {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      return file;
    });
  }

  FutureEither<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return runTask(() async {
      final List<XFile> files = await _imagePicker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      return files;
    });
  }

  FutureEither<XFile?> pickVideo({
    required ImageSource source,
    Duration? maxDuration,
  }) async {
    return runTask(() async {
      final XFile? file = await _imagePicker.pickVideo(
        source: source,
        maxDuration: maxDuration,
      );
      return file;
    });
  }

  FutureEither<List<PlatformFile>> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    return runTask(() async {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result == null || result.files.isEmpty) return [];
      return result.files;
    });
  }
}
