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
  final Color? activeButtonColor;
  final Color? inactiveButtonColor;
  final Color? badgedColor;
  final TextStyle? videoDurationTextStyle;
  TzGalleryOptions(
      {this.headerTextStyle,
      this.folderPrimaryTextStyle,
      this.folderSecondaryTextStyle,
      this.titleFolderPage,
      this.emptyFolder,
      this.submitTitle,
      this.activeButtonColor,
      this.inactiveButtonColor,
      this.badgedColor,
      this.videoDurationTextStyle,
      this.leading});
}

class TzGalleryLimitOptions {
  int limit;
  int? limitVideo;
  int? limitImage;
  String? warningMessageToast;
  int? sizeLimitImage;
  int? sizeLimitVideo;
  String? warningSizeLimitMessageToast;

  TzGalleryLimitOptions({
    required this.limit,
    this.limitVideo,
    this.limitImage,
    this.warningMessageToast,
    this.warningSizeLimitMessageToast,
    this.sizeLimitImage,
    this.sizeLimitVideo,
  }) : assert(
            (limitImage == null && limitVideo == null) ||
                ((limitImage != null || limitVideo != null) &&
                    limit == ((limitImage ?? 0) + (limitVideo ?? 0))),
            "Total limitImage and limitVideo is must equal limit");
}
