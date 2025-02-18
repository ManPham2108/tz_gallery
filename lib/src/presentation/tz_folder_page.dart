part of '../../tz_gallery.dart';

class TzFolderPage extends StatelessWidget {
  const TzFolderPage({super.key, required this.controller});
  final TzGalleryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          TzGallery.shared.options?.backgroundColor ?? Colors.white,
      appBar: TzHeaderGallery(
        shouldPop: 2,
        controller: controller,
        center: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                TzGallery.shared.options?.titleFolderPage ?? "Select folder",
                style: TzGallery.shared.options?.headerTextStyle ??
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: 1.5,
                    color: ColorCommon.color_141415,
                  ),
                ),
                child: Transform.flip(
                  flipY: true,
                  child: TzGallery.shared.options?.arrowDownIcon ??
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                      ),
                ),
              ))
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ColorCommon.color_B1B1B180,
              height: .5,
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: controller._folders,
              builder: (context, value, child) => GridView.builder(
                itemCount: value.length,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemBuilder: (context, index) => FutureBuilder(
                  future: value[index].getAssetListPaged(page: 0, size: 1),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FolderItem(
                        asset: snapshot.data!.isEmpty
                            ? null
                            : snapshot.data!.first,
                        folder: value[index],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
