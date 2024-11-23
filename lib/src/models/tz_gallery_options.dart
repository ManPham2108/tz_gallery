// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TzGalleryOptions {
  final TextStyle? headerTextStyle;
  final TextStyle? folderPrimaryTextStyle;
  final TextStyle? folderSecondaryTextStyle;
  final Widget? leading;
  final String? titleFolderPage;
  final Widget? emptyFolder;
  final Text? submitTitle;
  TzGalleryOptions(
      {this.headerTextStyle,
      this.folderPrimaryTextStyle,
      this.folderSecondaryTextStyle,
      this.titleFolderPage,
      this.emptyFolder,
      this.submitTitle,
      this.leading});
}
