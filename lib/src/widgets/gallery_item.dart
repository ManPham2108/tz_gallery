import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({super.key, this.index, required this.asset});
  //this is a index of item in a list photo/video picked
  final int? index;
  final AssetEntity asset;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.file,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Image.asset(snapshot.data?.path ?? "", fit: BoxFit.cover);
      },
    );
  }
}
