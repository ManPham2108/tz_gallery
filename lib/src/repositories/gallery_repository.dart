import 'package:photo_manager/photo_manager.dart';

abstract class IGalleryRepository {
  Future<List<AssetPathEntity>> getAssetsPath(RequestType type);
  Future<List<AssetEntity>> getAssets(int offset, int limit);
}
