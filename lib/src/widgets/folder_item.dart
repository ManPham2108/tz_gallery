import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:tz_gallery/tz_gallery.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({super.key, this.asset, required this.folder});
  final AssetEntity? asset;
  final AssetPathEntity folder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, folder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: asset != null
                  ? AssetEntityImage(
                      asset!,
                      isOriginal: false,
                      fit: BoxFit.cover,
                    )
                  : TzGallery.shared.options?.emptyFolder ??
                      Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.folder_copy_outlined,
                          color: Colors.grey[400],
                          size: 64,
                        ),
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              folder.name,
              overflow: TextOverflow.ellipsis,
              style: TzGallery.shared.options?.folderPrimaryTextStyle,
            ),
          ),
          FutureBuilder(
            future: folder.assetCountAsync,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  "${snapshot.data}",
                  style: TzGallery.shared.options?.folderPrimaryTextStyle,
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
