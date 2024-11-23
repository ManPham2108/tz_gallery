library tz_gallery;

import 'package:tz_gallery/src/models/tz_gallery_options.dart';

export 'package:photo_manager/src/types/entity.dart';
export 'package:tz_gallery/src/common/tz_enum.dart';
export 'package:tz_gallery/src/extension/tz_gallery_extension.dart';
export 'package:tz_gallery/src/models/tz_gallery_options.dart';
export 'package:tz_gallery/src/presentation/tz_gallery_controller.dart';

class TzGallery {
  TzGalleryOptions? _options;

  // Private constructor
  TzGallery._internal();

  // Singleton instance
  static final TzGallery _instance = TzGallery._internal();

  // Expose singleton instance
  static TzGallery get shared => _instance;

  // Set options once, using null-aware assignment
  void setOptions(TzGalleryOptions options) {
    _options ??= options;
  }

  void release() {
    _options = null;
  }

  // Getter for options
  TzGalleryOptions? get options => _options;
}
