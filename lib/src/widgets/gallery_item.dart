import 'package:flutter/material.dart';
import 'package:tz_gallery/src/widgets/choose_button_widget.dart';
import 'package:tz_gallery/tz_gallery.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem(
      {super.key,
      this.index,
      required this.asset,
      this.onTapChoose,
      this.onTap,
      required this.showMultiChoose});
  //this is a index of item in a list photo/video picked
  final int? index;
  final AssetEntity asset;
  final Function()? onTap;
  final Function()? onTapChoose;
  final bool showMultiChoose;
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
          showMultiChoose
              ? GestureDetector(
                  onTap: onTapChoose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: (index != null && index != -1)
                          ? Badge(
                              backgroundColor:
                                  TzGallery.shared.options?.badgedColor ??
                                      Colors.green,
                              label: Text(
                                "${(index ?? 0) + 1}",
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            )
                          : const ChooseButtonWidget(),
                    ),
                  ),
                )
              : const SizedBox(),
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
