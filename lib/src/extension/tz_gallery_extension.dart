import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/presentation/tz_gallery_controller.dart';
import 'package:tz_gallery/src/presentation/tz_gallery_page.dart';

extension TzGalleryExtension on TzGalleryController {
  Future<List<File>> pick(BuildContext context, {int? limit}) async {
    // Navigate and fetch the callback (list of AssetEntities)
    List<AssetEntity>? callback = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TzPickerPage(limit: limit)),
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
