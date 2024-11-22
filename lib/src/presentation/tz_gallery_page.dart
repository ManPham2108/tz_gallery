import 'package:flutter/material.dart';
import 'package:tz_gallery/src/widgets/gallery_item.dart';
import 'package:tz_gallery/src/widgets/header_gallery.dart';
import 'package:tz_gallery/tz_gallery.dart';

class TzPickerPage extends StatefulWidget {
  const TzPickerPage({super.key, this.limit, required this.controller});
  final TzGalleryController controller;
  final int? limit;

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
                      builder: (context, value, child) => GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2),
                            itemCount: value?.length ?? 0,
                            itemBuilder: (context, index) => GalleryItem(
                              asset: value![index],
                            ),
                          ))))
        ]),
      ),
    );
  }
}
