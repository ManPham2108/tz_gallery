import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart' show AssetType;
import 'package:tz_gallery/tz_gallery.dart';

AssetEntity image(String id) =>
    AssetEntity(id: id, typeInt: AssetType.image.index, width: 10, height: 10);

Future<TzGalleryController> openPicker(
  WidgetTester tester, {
  required TzType type,
  required Future<AssetEntity?> Function() capture,
  int limit = 2,
}) async {
  late BuildContext context;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (value) {
          context = value;
          return const SizedBox();
        },
      ),
    ),
  );

  final controller = TzGalleryController(type: type);
  TzGallery.shared.setOptions(TzGalleryOptions(onCameraCapture: capture));
  TzGallery.shared.setLimitOptions(TzGalleryLimitOptions(limit: limit));
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => TzPickerPage(controller: controller)),
  );
  await tester.pumpAndSettle();
  return controller;
}

Future<void> closePicker(
  WidgetTester tester,
  TzGalleryController controller,
) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pumpAndSettle();
  controller.dispose();
}

void main() {
  tearDown(TzGallery.shared.release);

  testWidgets('shows camera first for photo and all galleries', (tester) async {
    for (final type in [TzType.photo, TzType.all]) {
      final controller = await openPicker(
        tester,
        type: type,
        capture: () async => null,
      );
      expect(
        find.byKey(const ValueKey('tz_gallery_camera_tile')),
        findsOneWidget,
      );
      await closePicker(tester, controller);
      TzGallery.shared.release();
    }
  });

  testWidgets('hides camera for video galleries', (tester) async {
    final controller = await openPicker(
      tester,
      type: TzType.video,
      capture: () async => null,
    );
    expect(find.byKey(const ValueKey('tz_gallery_camera_tile')), findsNothing);
    await closePicker(tester, controller);
  });

  testWidgets('camera cancellation leaves selection unchanged', (tester) async {
    final controller = await openPicker(
      tester,
      type: TzType.photo,
      capture: () async => null,
    );
    await tester.tap(find.byKey(const ValueKey('tz_gallery_camera_tile')));
    await tester.pump();
    expect(controller.selectedEntities, isEmpty);
    await closePicker(tester, controller);
  });

  testWidgets('captured photos use selection limits', (tester) async {
    final captures = [image('1'), image('2'), image('3')];
    var captureCount = 0;
    final controller = await openPicker(
      tester,
      type: TzType.photo,
      capture: () async => captures[captureCount++],
    );

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('tz_gallery_camera_tile')));
      await tester.pump();
    }

    expect(controller.selectedEntities.map((entity) => entity.id), ['1', '2']);
    expect(captureCount, 2);
    await closePicker(tester, controller);
  });

  testWidgets('single captured photo auto-submits', (tester) async {
    final controller = await openPicker(
      tester,
      type: TzType.photo,
      limit: 1,
      capture: () async => image('camera'),
    );

    await tester.tap(find.byKey(const ValueKey('tz_gallery_camera_tile')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('tz_gallery_camera_tile')), findsNothing);
    await closePicker(tester, controller);
  });
}
