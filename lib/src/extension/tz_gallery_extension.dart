part of '../../tz_gallery.dart';

extension TzGalleryExtension on TzGalleryController {
  ///  [options] your custom styles
  ///
  /// [entities] pass your previous selection here, if you want to reload it to gallery
  Future<List<AssetEntity>> openGallery(BuildContext context,
      {int limit = 1,
      TzGalleryOptions? options,
      List<AssetEntity> entities = const []}) async {
    if (options != null) {
      TzGallery.shared.setOptions(options);
    }

    if (entities.isNotEmpty) {
      _picked.value = entities;
    }

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps.hasAccess) {
      if (_folders.value.isEmpty) {
        await _getFolders();
      }
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
    _picked.value.clear();
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

extension AssetEntityExt on AssetEntity {
  Future<File?> fromAssetEntityToFile() async {
    File? file = await this.file;
    file;
    return file;
  }

  Future<int?> getFileSize() async {
    final file = await this.fromAssetEntityToFile();
    return await file?.length();
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
