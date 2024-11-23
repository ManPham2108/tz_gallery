import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({super.key, this.index, required this.asset, this.onTap});
  //this is a index of item in a list photo/video picked
  final int? index;
  final AssetEntity asset;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: AssetEntityImage(
              asset,
              isOriginal: false,
              fit: BoxFit.cover,
            ),
          ),
          if (index != null && index != -1)
            Align(
              alignment: Alignment.topRight,
              child: Badge(
                backgroundColor: Colors.green,
                label: Text(
                  "${(index ?? 0) + 1}",
                ),
              ),
            )
        ],
      ),
    );
  }
}
