part of '../../tz_gallery.dart';

class TzPickerPage extends StatefulWidget {
  const TzPickerPage({super.key, required this.controller});
  final TzGalleryController controller;

  @override
  State<TzPickerPage> createState() => _TzPickerPageState();
}

class _TzPickerPageState extends State<TzPickerPage> {
  late final TzGalleryController _controller;
  TzGalleryLimitOptions get limitOptions => TzGallery.shared.limitOptions;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          TzGallery.shared.options?.backgroundColor ?? Colors.white,
      appBar: TzHeaderGallery(
        controller: _controller,
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
              child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter == 0) {
                      _controller._onLoadMore();
                    }
                    return false;
                  },
                  child: ValueListenableBuilder(
                      valueListenable: _controller._entities,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                            valueListenable: _controller._picked,
                            builder: (context, picked, child) =>
                                GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemCount: value?.length ?? 0,
                                  itemBuilder: (context, index) => GalleryItem(
                                    onTap: () => onPick(value[index]),
                                    index: _controller._picked.value.indexWhere(
                                        (element) =>
                                            element.id == value?[index].id),
                                    asset: value![index],
                                  ),
                                ));
                      }))),
          ValueListenableBuilder(
              valueListenable: _controller._picked,
              builder: (context, value, child) => SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: btnColor,
                              splashFactory: NoSplash.splashFactory,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: submit,
                          child: TzGallery.shared.options?.submitTitle ??
                              const Text("Next")),
                    ),
                  )),
        ]),
      ),
    );
  }

  Future<void> onPick(AssetEntity entity) async {
    final index = _controller._picked.value
        .indexWhere((element) => element.id == entity.id);
    if (index != -1) {
      _controller._onRemove(entity);
      return;
    }
    if (!(_controller._picked.value.length < limitOptions.limit)) {
      showWarningToast(ShowTypeToast.typeLimit);
      return;
    }

    if (checkTypeLimit(entity)) {
      final isOverSizeLimit = await checkOverSizeLimit(entity);
      if (!isOverSizeLimit) {
        _controller._onPick(entity);
      }
    }

    if (TzGallery.shared.limitOptions.limit == 1) submit();
  }

  void submit() {
    if (_controller._picked.value.isEmpty) return;
    return Navigator.pop(context, _controller._picked.value.toList());
  }

  bool checkTypeLimit(AssetEntity entity) {
    if (_controller._type == TzType.all) {
      bool isOverLimit = checkOverLimitByType(entity, AssetType.image,
          limitOptions.limitImage, _controller._totalImageType);

      if (isOverLimit) return false;

      isOverLimit = checkOverLimitByType(entity, AssetType.video,
          limitOptions.limitVideo, _controller._totalVideoType);

      if (isOverLimit) return false;
    }
    return true;
  }

  bool isToastNotEmpty(String? toast) => toast?.isNotEmpty == true;

  void showWarningToast(ShowTypeToast type) {
    final toastMessages = {
      ShowTypeToast.sizeLimit: limitOptions.warningSizeLimitMessageToast,
      ShowTypeToast.typeLimit: limitOptions.warningMessageToast,
    };

    final message = toastMessages[type];

    if (isToastNotEmpty(message)) {
      Toast.showToast(context, message ?? "");
    }
  }

  bool checkOverLimitByType(
      AssetEntity entity, AssetType assetType, int? limit, int currentTotal) {
    if (entity.type == assetType && limit != null && currentTotal >= limit) {
      showWarningToast(ShowTypeToast.typeLimit);
      return true;
    }
    return false;
  }

  Future<bool> checkOverSizeLimit(AssetEntity entity) async {
    final sizeLimitMap = {
      AssetType.image:
          Converts.convertMbToBytes(limitOptions.sizeLimitImage ?? 0),
      AssetType.video:
          Converts.convertMbToBytes(limitOptions.sizeLimitVideo ?? 0)
    };

    final sizeLimitByType = sizeLimitMap[entity.type] ?? 0;

    if (sizeLimitByType > 0) {
      int? size = _controller._entitySizes[entity.id];
      if (size == null) {
        size = await entity.getFileSize() ?? 0;
        _controller._entitySizes[entity.id] = size;
      }

      if (size > sizeLimitByType) {
        showWarningToast(ShowTypeToast.sizeLimit);
        return true;
      }
    }

    return false;
  }

  Color get btnColor {
    final options = TzGallery.shared.options;
    if (_controller._picked.value.isEmpty) {
      return options?.inactiveButtonColor ?? Colors.grey;
    }
    return options?.activeButtonColor ?? Colors.black;
  }
}
