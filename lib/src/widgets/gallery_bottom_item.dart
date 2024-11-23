import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GalleryBottomItem extends StatelessWidget {
  const GalleryBottomItem({super.key, required this.entity, this.onTap});
  final AssetEntity entity;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: AspectRatio(
              aspectRatio: 1,
              child: AssetEntityImage(
                entity,
                isOriginal: false,
                fit: BoxFit.cover,
              ),
            )),
        Positioned(
            right: 0,
            child: _CloseWidget(
              onTap: onTap,
            ))
      ],
    );
  }
}

class _CloseWidget extends StatelessWidget {
  const _CloseWidget({super.key, this.onTap});
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(4.0),
                  topLeft: Radius.circular(4.0)),
              color: Colors.black),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 16,
          )),
    );
  }
}
