import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/widgets/choose_button_widget.dart';
import 'package:tz_gallery/tz_gallery.dart';

const brightness = Brightness.light;

class TZMediaDetailPage extends StatefulWidget {
  final AssetEntity entity;
  final bool isSelected;
  const TZMediaDetailPage(
      {super.key, required this.entity, required this.isSelected});

  @override
  State<TZMediaDetailPage> createState() => _TZMediaDetailPageState();
}

class _TZMediaDetailPageState extends State<TZMediaDetailPage> {
  AssetEntity get entity => widget.entity;
  bool get isSelected => widget.isSelected;
  bool get isVideo => entity.type == AssetType.video;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarBrightness:
            brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22.22, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, isSelected);
                      },
                      child: Row(
                        children: [
                          ChooseButtonWidget(
                            isSelect: isSelected,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSelected ? "Deselect" : "Select",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: isVideo ? _buildVideoMedia() : _buildImageMedia(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageMedia() {
    return AssetEntityImage(
      entity,
      fit: BoxFit.contain,
    );
  }

  Widget _buildVideoMedia() {
    return AssetEntityImage(
      entity,
      fit: BoxFit.contain,
    );
  }
}
