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
  bool get isMultiMedia => limitOptions.limit > 1;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomButton = MediaQuery.of(context).viewPadding.bottom + 6;
    return Scaffold(
      backgroundColor:
          TzGallery.shared.options?.backgroundColor ?? Colors.white,
      appBar: TzHeaderGallery(
        controller: _controller,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(children: [
          Positioned.fill(
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
                          builder: (context, picked, child) => GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2),
                            itemCount: value?.length ?? 0,
                            itemBuilder: (context, index) => GalleryItem(
                              onTap: () => onShowMedia(value[index]),
                              onTapChoose: () => onPick(value[index]),
                              index: _controller._picked.value.indexWhere(
                                  (element) => element.id == value?[index].id),
                              asset: value![index],
                              showMultiChoose: isMultiMedia,
                            ),
                            padding: EdgeInsets.only(
                                bottom: 48 + bottomButton + 20 + 2),
                          ),
                        );
                      }))),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder(
                valueListenable: _controller._picked,
                builder: (context, value, child) => ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20)
                              .copyWith(bottom: bottomButton),
                          child: SizedBox(
                            height: 48,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: btnColor,
                                  splashFactory: NoSplash.splashFactory,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: submit,
                              child: TzGallery.shared.options?.submitTitle ??
                                  Text(
                                    "Upload",
                                    style: TextStyle(
                                      color: btnTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )),
          ),
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

  void onShowMedia(AssetEntity entity) {
    if (!isMultiMedia) {
      onPick(entity);
      return;
    }
    final isSelected = _controller._picked.value
            .indexWhere((element) => element.id == entity.id) !=
        -1;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TZMediaDetailPage(
                entity: entity,
                isSelected: isSelected,
              )),
    ).then(
      (value) {
        if (value != null) {
          onPick(entity);
        }
      },
    );
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
      return options?.inactiveButtonColor ?? ColorCommon.color_E3E9DE;
    }

    return options?.activeButtonColor ?? ColorCommon.color_428407;
  }

  Color get btnTextColor {
    if (_controller._picked.value.isEmpty) {
      return ColorCommon.color_B9BDC1;
    }
    return Colors.white;
  }
}
