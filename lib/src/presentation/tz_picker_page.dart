import 'package:flutter/material.dart';
import 'package:tz_gallery/tz_gallery.dart';

class TzPickerPage extends StatefulWidget {
  const TzPickerPage({super.key});

  @override
  State<TzPickerPage> createState() => _TzPickerPageState();
}

class _TzPickerPageState extends State<TzPickerPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TzHeaderGallery(title: "Recently"),
      body: Column(children: []),
    );
  }
}
