library tz_gallery;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tz_gallery/src/repositories/gallery_repository.dart';
import 'package:tz_gallery/src/widgets/folder_item.dart';
import 'package:tz_gallery/src/widgets/gallery_bottom_item.dart';
import 'package:tz_gallery/src/widgets/gallery_item.dart';
import 'package:tz_gallery/src/widgets/transitions/slide_down.dart';
import 'package:tz_gallery/tz_gallery.dart';

export 'package:photo_manager/src/types/entity.dart';
export 'package:tz_gallery/src/common/tz_enum.dart';
export 'package:tz_gallery/src/models/tz_gallery_options.dart';

part 'src/extension/tz_gallery_extension.dart';
part 'src/presentation/tz_folder_page.dart';
part 'src/presentation/tz_gallery_controller.dart';
part 'src/presentation/tz_gallery_page.dart';
part 'src/widgets/header_gallery.dart';

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
