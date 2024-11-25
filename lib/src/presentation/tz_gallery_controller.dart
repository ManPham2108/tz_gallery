part of '../../tz_gallery.dart';

class TzGalleryController {
  final IGalleryRepository _galleryRepository = GalleryRepository();

  final ValueNotifier<List<AssetEntity>?> _entities = ValueNotifier(null);
  final ValueNotifier<List<AssetPathEntity>> _folders = ValueNotifier([]);
  final ValueNotifier<AssetPathEntity?> _currentFolder = ValueNotifier(null);
  final StreamController<bool> _loadController = StreamController();

  final ValueNotifier<List<AssetEntity>> _picked = ValueNotifier([]);

  int _page = 0;
  bool _outOfContent = false;
  late TzType _type;
  TzGalleryController({TzType? type}) {
    _type = type ?? TzType.all;
    _currentFolder.addListener(() {
      _getEntitiesInFolder();
    });
    _getFolders();

    _loadController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) {
      if (_outOfContent) return;
      _loadMore();
    });
  }

  Future<void> _getFolders() async {
    try {
      // Fetch paths asynchronously
      final flds = await _galleryRepository.getAssetsPath(_type);
      // Update paths only if it's different from the current value to prevent unnecessary UI updates
      if (_folders.value != flds) {
        _folders.value = flds;
      }
      // Fetch assets if paths are not empty, avoid fetching if already done
      if (_folders.value.isNotEmpty) {
        _currentFolder.value = _folders.value.first;
      }
    } catch (e) {
      print('Error loading assets or paths: $e');
    }
  }

  Future<void> _getEntitiesInFolder() async {
    _clearLoadMoreState();
    final assets = await _galleryRepository.getAssets(_currentFolder.value!);
    // Update entities only if there are changes
    if (_entities.value != assets) {
      _entities.value = assets;
    }
  }

  Future<void> _loadMore() async {
    if (_outOfContent) return;
    _page += 1;
    final assets =
        await _galleryRepository.getAssets(_currentFolder.value!, page: _page);
    if (_entities.value != assets) {
      _entities.value = List.from([..._entities.value! + assets]);
    }
    if (assets.length < 40) {
      _outOfContent = true;
    }
  }

  void _onLoadMore() {
    _loadController.sink.add(true);
  }

  void _onPick(AssetEntity entity) {
    _picked.value = List.from([..._picked.value, entity]);
  }

  void _onRemove(AssetEntity entity) {
    _picked.value.removeWhere((element) => element.id == entity.id);
    _picked.value = List.from(_picked.value);
  }

  void _clearLoadMoreState() {
    _page = 0;
    _outOfContent = false;
  }

  void dispose() {
    _entities.dispose();
    _folders.dispose();
    _currentFolder.dispose();
    _loadController.close();
    TzGallery.shared.release();
  }
}
