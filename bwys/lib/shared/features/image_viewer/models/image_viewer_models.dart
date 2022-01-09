import 'package:bwys/shared/models/pnm_common_model.dart';

class ImageItem {
  /// image local file path or Uint8List data
  dynamic imageData;

  /// to identify if image is stored locally or on network
  bool isLocal;

  ImageDataType? imageDataType;

  ImageItem(
      {required this.imageData,
      required this.imageDataType,
      this.isLocal = false});
}
