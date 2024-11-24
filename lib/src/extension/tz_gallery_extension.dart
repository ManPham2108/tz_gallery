import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/presentation/tz_gallery_page.dart';
import 'package:tz_gallery/tz_gallery.dart';

extension TzGalleryExtension on TzGalleryController {
  Future<List<AssetEntity>> openGallery(BuildContext context,
      {int limit = 1,
      TzGalleryOptions? options,
      List<AssetEntity> entities = const []}) async {
    if (options != null) {
      TzGallery.shared.setOptions(options);
    }

    if (entities.isNotEmpty) {
      picked.value = entities;
    }

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps.hasAccess) {
      await getFolders();
    } else {
      PhotoManager.openSetting();
      return [];
    }
    if (!context.mounted) return [];
    // Navigate and fetch the callback (list of AssetEntities)
    List<AssetEntity>? callback = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TzPickerPage(limit: limit, controller: this)),
    );
    picked.value.clear();
    // If no items were selected, return an empty list.
    if (callback == null) return [];

    return callback;
    // Create a list of Future<File?> where each future corresponds to a file for each AssetEntity
  }
}

extension AssetEntityListExt on List<AssetEntity> {
  Future<List<File>> fromAssetEntitiesToFiles() async {
    List<Future<File?>> fileFutures = map((item) => item.file).toList();

    // Wait for all file fetch operations to complete in parallel
    List<File?> files = await Future.wait(fileFutures);

    // Filter out any null values and maintain the original order
    // Here we make sure to map the future results back in their original index order
    List<File> shouldReturn = files.whereType<File>().toList();
    return shouldReturn;
  }
}

extension DurationExt on Duration {
  String get formatDuration {
    int hours = inHours;
    int minutes = inMinutes % 60;
    int seconds = inSeconds % 60;
    if (hours > 0) {
      return '$hours:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }
}
