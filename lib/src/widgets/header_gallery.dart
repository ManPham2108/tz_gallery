// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TzHeaderGallery extends StatelessWidget implements PreferredSizeWidget {
  const TzHeaderGallery(
      {super.key, this.leading, required this.title, this.styles});
  final Widget? leading;
  final String title;
  final TextStyle? styles;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: Stack(
          children: [
            Row(children: [
              leading ??
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Icon(Icons.arrow_back_ios, size: 24),
                      )),
            ]),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: styles,
                    ),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
