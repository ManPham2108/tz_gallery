# TZ Gallery
## A Flutter package for iOS and Android for picking images, videos from the library


## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Installation
Add this to `pubspec.yaml`
```yaml
  tz_gallery:
    git:
      url: https://github.com/phamminhlong10/tz_gallery.git
```

#### Adding Permissions to AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" /> <!-- read images or videos-->
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" /> <!-- read videos or images-->
<uses-permission android:name="android.permission.READ_MEDIA_VISUAL_USER_SELECTED" />  <!-- If you want to use the limited access feature. -->
```
If your `compileSdkVersion` or `targetSdkVersion` is `29` or above, you can consider adding `android:requestLegacyExternalStorage="true"` to your `AndroidManifest.xml` in order to obtain resources:
```xml
<application
        android:label="example"
        android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true">
</application>
```
#### Adding Permissions to Info.plist
Define the `NSPhotoLibraryUsageDescription` key-value in the `ios/Runner/Info.plist`:
```plist
<key>NSPhotoLibraryUsageDescription</key>
<string>In order to access your photo library</string>
```

#### iOS extra configs

Localized system albums name
By default, iOS will retrieve system album names only in English no matter what language has been set to devices. To change the default language, see the following steps:

Open your iOS project (Runner.xcworkspace) using Xcode.
![](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/iosFlutterProjectEditinginXcode.png)
Select the project "Runner" and in the localizations table, click on the + icon.
![](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/iosFlutterAddLocalization.png)
## Usage
TZ Gallery provides a helper class called TzGalleryOptions that wraps all properties and can be used to customize UI in the library.

## TzType Enum

The `TzType` enum defines the different types of media that can be handled by the gallery. It has the following values:

| Value  | Description                       |
|--------|-----------------------------------|
| `photo`| Represents a photo type.          |
| `video`| Represents a video type.          |
| `all`  | Represents both photos and videos. |

## TzGalleryOptions Class Properties

| Property                   | Type                        | Description                                                                                     |
|----------------------------|-----------------------------|-------------------------------------------------------------------------------------------------|
| `headerTextStyle`           | `TextStyle?`                | The style for the header text.                                                                  |
| `folderPrimaryTextStyle`    | `TextStyle?`                | The style for the primary text in the folder.                                                   |
| `folderSecondaryTextStyle`  | `TextStyle?`                | The style for the secondary text in the folder.                                                 |
| `leading`                   | `Widget?`                   | The widget displayed as the leading icon or element (e.g., an icon or an image).                |
| `titleFolderPage`           | `String?`                   | The title of the folder page.                                                                   |
| `emptyFolder`               | `Widget?`                   | The widget displayed when the folder is empty.                                                 |
| `submitTitle`               | `Text?`                     | The text displayed on the submit button.                                                        |
| `activeButtonColor`         | `Color?`                    | The color of the active button.                                                                 |
| `inactiveButtonColor`       | `Color?`                    | The color of the inactive button.                                                               |
| `badgedColor`               | `Color?`                    | The color used for badges.                                                                      |
| `videoDurationTextStyle`    | `TextStyle?`                | The style for the video duration text.                                                          |

# Example
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TzGalleryController controller = TzGalleryController();
  List<File> files = [];

  void _open(BuildContext context) async {
    final List<AssetEntity> data = await controller.openGallery(context,
        options: TzGalleryOptions(titleFolderPage: "Albums"), limit: 10);
    final summary = await data.fromAssetEntitiesToFiles();
    setState(() {
      files = summary;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: files.isEmpty
            ? const Text('No image picked')
            : ListView.builder(
                itemBuilder: (context, index) =>
                    Image.file(files[index], fit: BoxFit.cover),
                itemCount: files.length,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _open(context),
        tooltip: 'Open',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```

