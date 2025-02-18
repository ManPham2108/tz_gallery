// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../tz_gallery.dart';

class TzHeaderGallery extends StatelessWidget implements PreferredSizeWidget {
  const TzHeaderGallery(
      {super.key, required this.controller, this.center, this.shouldPop = 1});
  final TzGalleryController controller;
  final Widget? center;
  final int shouldPop;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Row(children: [
            GestureDetector(
                onTap: () => onClose(context, shouldPop),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TzGallery.shared.options?.leading ??
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  ),
                )),
          ]),
          if (controller._currentFolder.value != null)
            Container(
                padding: const EdgeInsets.only(bottom: 6.5),
                alignment: Alignment.center,
                child: center ??
                    GestureDetector(
                      onTap: () => onSelectFolder(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: controller._currentFolder,
                            builder: (context, value, child) => Text(
                              value?.name ?? "",
                              style:
                                  TzGallery.shared.options?.headerTextStyle ??
                                      const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TzGallery.shared.options?.arrowDownIcon ??
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 1.5,
                                    color: const Color(0xFF141415),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                ),
                              )
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
      controller._currentFolder.value = callback;
    }
  }

  void onClose(BuildContext context, int numberPop) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == numberPop;
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
