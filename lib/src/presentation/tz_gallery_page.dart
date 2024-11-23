import 'package:flutter/material.dart';
import 'package:tz_gallery/src/widgets/gallery_bottom_item.dart';
import 'package:tz_gallery/src/widgets/gallery_item.dart';
import 'package:tz_gallery/src/widgets/header_gallery.dart';
import 'package:tz_gallery/tz_gallery.dart';

class TzPickerPage extends StatefulWidget {
  const TzPickerPage(
      {super.key, required this.limit, required this.controller});
  final TzGalleryController controller;
  final int limit;

  @override
  State<TzPickerPage> createState() => _TzPickerPageState();
}

class _TzPickerPageState extends State<TzPickerPage> {
  late final TzGalleryController _controller;
  @override
  void initState() {
    _controller = widget.controller;
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
                      _controller.onLoadMore();
                    }
                    return false;
                  },
                  child: ValueListenableBuilder(
                      valueListenable: _controller.entities,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                            valueListenable: _controller.picked,
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
                                    index: _controller.picked.value.indexWhere(
                                        (element) =>
                                            element.id == value?[index].id),
                                    asset: value![index],
                                  ),
                                ));
                      }))),
          ValueListenableBuilder(
            valueListenable: _controller.picked,
            builder: (context, value, child) => Column(
              children: [
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    itemBuilder: (context, index) => GalleryBottomItem(
                      entity: value[index],
                      onTap: () => _controller.onRemove(value[index]),
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: value.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor:
                                value.isEmpty ? Colors.grey : Colors.black,
                            splashFactory: NoSplash.splashFactory,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: submit,
                        child: TzGallery.shared.options?.submitTitle ??
                            const Text("Complete")),
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
    final index = _controller.picked.value
        .indexWhere((element) => element.id == entity.id);
    if (index != -1) {
      _controller.onRemove(entity);
      return;
    }
    if (!(_controller.picked.value.length < widget.limit)) return;
    _controller.onPick(entity);
  }

  void submit() {
    if (_controller.picked.value.isEmpty) return;
    return Navigator.pop(context, _controller.picked.value.toList());
  }
}
