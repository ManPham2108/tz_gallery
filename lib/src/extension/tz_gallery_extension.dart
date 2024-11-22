import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/presentation/tz_gallery_page.dart';
import 'package:tz_gallery/tz_gallery.dart';

extension TzGalleryExtension on TzGalleryController {
  Future<List<File>> openGallery(BuildContext context,
      {int? limit, TzGalleryOptions? options}) async {
    if (options != null) {
      TzGallery.shared.setOptions(options);
    }

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps.hasAccess) {
    } else {
      PhotoManager.openSetting();
      return [];
    }

    // Navigate and fetch the callback (list of AssetEntities)
    List<AssetEntity>? callback = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TzPickerPage(limit: limit, controller: this)),
    );

    // If no items were selected, return an empty list.
    if (callback == null) return [];

    // Create a list of Future<File?> where each future corresponds to a file for each AssetEntity
    List<Future<File?>> fileFutures =
        callback.map((item) => item.file).toList();

    // Wait for all file fetch operations to complete in parallel
    List<File?> files = await Future.wait(fileFutures);

    // Filter out any null values and maintain the original order
    // Here we make sure to map the future results back in their original index order
    List<File> shouldReturn = files.whereType<File>().toList();

    return shouldReturn;
  }
}
