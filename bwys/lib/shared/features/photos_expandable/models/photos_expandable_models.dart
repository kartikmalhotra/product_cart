import 'package:bwys/shared/models/pnm_common_model.dart';

class PhotoItem {
  /// image local file path or Uint8List data
  dynamic imageData;

  /// to identify if image is stored locally or on network
  bool isLocal;

  /// to identify which item is selected in multi selection feature
  bool isSelected;

  /// to identify items marked for deletion
  late bool markedForDeletion;

  /// to assign image type which is to be used while displaying image
  ImageDataType? imageDataType;

  /// optional file name, important if using pre-uploaded images for deletion
  String? fileName;

  PhotoItem(
      {required this.imageData,
      required this.imageDataType,
      this.isLocal = false,
      this.isSelected = false,
      this.fileName});
}
