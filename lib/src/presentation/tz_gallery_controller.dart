import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tz_gallery/src/repositories/gallery_repository.dart';
import 'package:tz_gallery/tz_gallery.dart';

class TzGalleryController {
  final IGalleryRepository _galleryRepository = GalleryRepository();

  final ValueNotifier<List<AssetEntity>?> entities = ValueNotifier(null);
  final ValueNotifier<List<AssetPathEntity>> folders = ValueNotifier([]);
  final ValueNotifier<AssetPathEntity?> currentFolder = ValueNotifier(null);
  final StreamController<bool> _loadController = StreamController();

  final ValueNotifier<List<AssetEntity>> picked = ValueNotifier([]);

  int _page = 0;
  bool outOfContent = false;

  TzGalleryController({TzType? type}) {
    currentFolder.addListener(() {
      _getEntitiesInFolder();
    });
    _initialize(type);

    _loadController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) {
      if (outOfContent) return;
      _loadMore();
    });
  }

  Future<void> _initialize(TzType? type) async {
    try {
      // Fetch paths asynchronously
      final flds = await _galleryRepository.getAssetsPath(type ?? TzType.all);
      // Update paths only if it's different from the current value to prevent unnecessary UI updates
      if (folders.value != flds) {
        folders.value = flds;
      }
      // Fetch assets if paths are not empty, avoid fetching if already done
      if (folders.value.isNotEmpty) {
        currentFolder.value = folders.value.first;
      }
    } catch (e) {
      print('Error loading assets or paths: $e');
    }
  }

  Future<void> _getEntitiesInFolder() async {
    final assets = await _galleryRepository.getAssets(currentFolder.value!);
    // Update entities only if there are changes
    if (entities.value != assets) {
      entities.value = assets;
    }
  }

  Future<void> _loadMore() async {
    if (outOfContent) return;
    _page += 1;
    final assets =
        await _galleryRepository.getAssets(currentFolder.value!, page: _page);
    if (entities.value != assets) {
      entities.value = List.from([...entities.value! + assets]);
    }
    if (assets.length < 40) {
      outOfContent = true;
    }
  }

  void onLoadMore() {
    _loadController.sink.add(true);
  }

  void onPick(AssetEntity entity, {int? limit}) {
    if (limit != null && picked.value.length > limit) return;
    picked.value = List.from([...picked.value, entity]);
  }

  void onRemove(AssetEntity entity) {
    picked.value.removeWhere((element) => element.id == entity.id);
    picked.value = List.from(picked.value);
  }

  void dispose() {
    entities.dispose();
    folders.dispose();
    _loadController.close();
    TzGallery.shared.release();
  }
}
