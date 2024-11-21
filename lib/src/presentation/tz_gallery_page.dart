import 'package:flutter/material.dart';
import 'package:tz_gallery/src/extension/tz_gallery_extension.dart';
import 'package:tz_gallery/src/presentation/tz_gallery_controller.dart';
import 'package:tz_gallery/src/widgets/gallery_item.dart';
import 'package:tz_gallery/src/widgets/header_gallery.dart';

class TzPickerPage extends StatefulWidget {
  const TzPickerPage({super.key, this.leading, this.style, this.limit});
  final TextStyle? style;
  final Widget? leading;
  final int? limit;
  @override
  State<TzPickerPage> createState() => _TzPickerPageState();
}

class _TzPickerPageState extends State<TzPickerPage> {
  final TzGalleryController _controller = TzGalleryController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TzHeaderGallery(
          controller: _controller,
          styles: widget.style,
          leading: widget.leading),
      body: Column(children: [
        Expanded(
            child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter == 0) {
              _controller.onLoadMore();
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: 40,
            itemBuilder: (context, index) => Container(),
          ),
        ))
      ]),
    );
  }
}
