// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/presentation/tz_folder_page.dart';
import 'package:tz_gallery/src/presentation/tz_gallery_controller.dart';
import 'package:tz_gallery/src/widgets/transition/slide_up.dart';

class TzHeaderGallery extends StatelessWidget implements PreferredSizeWidget {
  const TzHeaderGallery(
      {super.key, this.leading, required this.controller, this.styles});
  final TzGalleryController controller;
  final Widget? leading;
  final TextStyle? styles;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: Stack(
          children: [
            Row(children: [
              leading ??
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Icon(Icons.arrow_back_ios, size: 24),
                      )),
            ]),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          SlideUp(TzFolderPage(controller: controller))),
                      child: ValueListenableBuilder(
                        valueListenable: controller.currentFolder,
                        builder: (context, value, child) => Text(
                          value?.name ?? "",
                          style: styles,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
