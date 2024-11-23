import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tz_gallery/tz_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TZ Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TZ Gallery example'),
    );
  }
}

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
