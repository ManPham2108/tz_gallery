import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({super.key, this.index, required this.asset});
  //this is a index of item in a list photo/video picked
  final int? index;
  final AssetEntity asset;
  @override
  Widget build(BuildContext context) {
    return AssetEntityImage(
      asset,
      isOriginal: false,
      fit: BoxFit.cover,
    );
  }
}
