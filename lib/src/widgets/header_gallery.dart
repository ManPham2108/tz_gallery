// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/presentation/tz_folder_page.dart';
import 'package:tz_gallery/src/widgets/transition/slide_down.dart';
import 'package:tz_gallery/tz_gallery.dart';

class TzHeaderGallery extends StatelessWidget implements PreferredSizeWidget {
  const TzHeaderGallery({super.key, required this.controller, this.center});
  final TzGalleryController controller;
  final Widget? center;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Row(children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TzGallery.shared.options?.leading ??
                        const Icon(Icons.arrow_back_ios, size: 24),
                  ),
                )),
          ]),
          Align(
              alignment: Alignment.center,
              child: center ??
                  GestureDetector(
                    onTap: () => onSelectFolder(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller.currentFolder,
                          builder: (context, value, child) => Text(
                            value?.name ?? "",
                            style: TzGallery.shared.options?.headerTextStyle ??
                                const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  ))
        ],
      ),
    );
  }

  Future onSelectFolder(BuildContext context) async {
    AssetPathEntity? callback = await Navigator.push(
        context, SlideDown(TzFolderPage(controller: controller)));
    if (callback != null) {
      controller.currentFolder.value = callback;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
