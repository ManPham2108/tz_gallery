part of '../../tz_gallery.dart';

class TzPickerPage extends StatefulWidget {
  const TzPickerPage(
      {super.key, required this.limitOptions, required this.controller});
  final TzGalleryController controller;
  final TzGalleryLimitOptions limitOptions;

  @override
  State<TzPickerPage> createState() => _TzPickerPageState();
}

class _TzPickerPageState extends State<TzPickerPage> {
  late final TzGalleryController _controller;
  late TzGalleryLimitOptions limitOptions;

  @override
  void initState() {
    _controller = widget.controller;
    limitOptions = widget.limitOptions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            builder: (context, value, child) => Column(
              children: [
                if (value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 80,
                      child: ListView.separated(
                        itemBuilder: (context, index) => GalleryBottomItem(
                          entity: value[index],
                          onTap: () => _controller._onRemove(value[index]),
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: value.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void onPick(AssetEntity entity) {
    final index = _controller._picked.value
        .indexWhere((element) => element.id == entity.id);
    if (index != -1) {
      _controller._onRemove(entity);
      return;
    }
    if (!(_controller._picked.value.length < limitOptions.limit)) {
      onShowToast();
      return;
    }
    if (checkTypeLimit(entity)) {
      _controller._onPick(entity);
    }
    if (widget.limitOptions.limit == 1) {
      submit();
    }
  }

  void submit() {
    if (_controller._picked.value.isEmpty) return;
    return Navigator.pop(context, _controller._picked.value.toList());
  }

  bool checkTypeLimit(AssetEntity entity) {
    if (_controller._type == TzType.all) {
      bool isOverLimit = checkOverLimitByType(entity, AssetType.image,
          limitOptions.limitImage ?? 0, _controller._totalImageType);

      if (isOverLimit) return false;

      isOverLimit = checkOverLimitByType(entity, AssetType.video,
          limitOptions.limitVideo ?? 0, _controller._totalVideoType);

      if (isOverLimit) return false;
    }
    return true;
  }

  void onShowToast() {
    if (limitOptions.warningMessageToast?.isNotEmpty == true) {
      Toast.showToast(context, limitOptions.warningMessageToast ?? "");
    }
  }

  bool checkOverLimitByType(
      AssetEntity entity, AssetType assetType, int limit, int currentTotal) {
    if (entity.type == assetType && limit > 0 && currentTotal >= limit) {
      onShowToast();
      return true;
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
