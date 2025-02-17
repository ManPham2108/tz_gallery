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
  final Color? backgroundColor;
  final TextStyle? videoDurationTextStyle;
  final Widget? arrowDownIcon;
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
      this.backgroundColor,
      this.arrowDownIcon,
      this.leading});

  TzGalleryOptions copyWith({
    TextStyle? headerTextStyle,
    TextStyle? folderPrimaryTextStyle,
    TextStyle? folderSecondaryTextStyle,
    Widget? leading,
    String? titleFolderPage,
    Widget? emptyFolder,
    Text? submitTitle,
    Color? activeButtonColor,
    Color? inactiveButtonColor,
    Color? badgedColor,
    Color? backgroundColor,
    TextStyle? videoDurationTextStyle,
  }) {
    return TzGalleryOptions(
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      folderPrimaryTextStyle:
          folderPrimaryTextStyle ?? this.folderPrimaryTextStyle,
      folderSecondaryTextStyle:
          folderSecondaryTextStyle ?? this.folderSecondaryTextStyle,
      leading: leading ?? this.leading,
      titleFolderPage: titleFolderPage ?? this.titleFolderPage,
      emptyFolder: emptyFolder ?? this.emptyFolder,
      submitTitle: submitTitle ?? this.submitTitle,
      activeButtonColor: activeButtonColor ?? this.activeButtonColor,
      inactiveButtonColor: inactiveButtonColor ?? this.inactiveButtonColor,
      badgedColor: badgedColor ?? this.badgedColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      videoDurationTextStyle:
          videoDurationTextStyle ?? this.videoDurationTextStyle,
    );
  }
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

  TzGalleryLimitOptions copyWith({
    int? limit,
    int? limitVideo,
    int? limitImage,
    String? warningMessageToast,
    int? sizeLimitImage,
    int? sizeLimitVideo,
    String? warningSizeLimitMessageToast,
  }) {
    return TzGalleryLimitOptions(
      limit: limit ?? this.limit,
      limitVideo: limitVideo ?? this.limitVideo,
      limitImage: limitImage ?? this.limitImage,
      warningMessageToast: warningMessageToast ?? this.warningMessageToast,
      sizeLimitImage: sizeLimitImage ?? this.sizeLimitImage,
      sizeLimitVideo: sizeLimitVideo ?? this.sizeLimitVideo,
      warningSizeLimitMessageToast:
          warningSizeLimitMessageToast ?? this.warningSizeLimitMessageToast,
    );
  }
}
