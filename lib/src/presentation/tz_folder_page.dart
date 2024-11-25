part of '../../tz_gallery.dart';

class TzFolderPage extends StatelessWidget {
  const TzFolderPage({super.key, required this.controller});
  final TzGalleryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TzHeaderGallery(
        controller: controller,
        center: Text(
          TzGallery.shared.options?.titleFolderPage ?? "Select folder",
          style: TzGallery.shared.options?.headerTextStyle ??
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xffb1b1b180),
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
