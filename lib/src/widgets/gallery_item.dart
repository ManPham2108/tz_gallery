import 'package:flutter/material.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:tz_gallery/tz_gallery.dart';

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Badge(
                  backgroundColor:
                      TzGallery.shared.options?.badgedColor ?? Colors.green,
                  label: Text(
                    "${(index ?? 0) + 1}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          if (asset.videoDuration != Duration.zero)
            Positioned(bottom: 6, right: 6, child: _buildDuration())
        ],
      ),
    );
  }

  Widget _buildDuration() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: Colors.black45),
      child: Text(
        asset.videoDuration.formatDuration,
        style: TzGallery.shared.options?.videoDurationTextStyle ??
            const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
      ),
    );
  }
}
