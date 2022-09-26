import 'dart:ui';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/config/theme_size.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/widgets/buttons/single_line_text_tag.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

/// if [isVideo] is true then we need to show its thumbnail
/// if [videoImageThumbnail] that means video has image thumbnail so feed it to the
/// the [CustomNetworkVideo] else feed the video url and we can download the thumbnail
/// from the video url in [CustomNetworkVideo] class
class GroupListItem extends StatelessWidget {
  final int index;
  final String translatedTitle;
  final String? tag1Text;
  final String? tag2Text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool showDivider;
  final Color? tagBackgroundColor;
  final Color? tagTextColor;
  final bool hasDesc;
  final bool isTitleBold;
  final String imageUrl;
  final String description;
  final bool isSelected;
  final Widget? imagePaddingSpace;
  final VoidCallback? onLongPress;
  final VoidCallback? onReportButtonPress;
  final bool showReportIcon;
  final bool isVideo;
  final String? customPlaceholder;
  final String? videoImageThumbnail;
  final bool showNotifyButton;
  final VoidCallback? onNotifyPressed;
  final int? videoStatus;

  const GroupListItem({
    Key? key,
    required this.index,
    required this.translatedTitle,
    this.tag1Text,
    this.tag2Text,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.showDivider = true,
    this.tagBackgroundColor,
    this.tagTextColor,
    this.hasDesc = true,
    this.imageUrl = 'assets/images/dummy_group.png',
    this.onLongPress,
    this.isSelected = false,
    this.showReportIcon = false,
    this.description = '',
    this.imagePaddingSpace,
    this.isTitleBold = true,
    this.isVideo = false,
    this.customPlaceholder,
    this.showNotifyButton = false,
    this.onNotifyPressed,
    this.onReportButtonPress,
    this.videoImageThumbnail,
    this.videoStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shadowColor: Colors.transparent,
        padding: padding,
      ),
      child: Container(
        padding: EdgeInsets.all(0.8.h),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Spaces.normX(2.0)),
            border: Border.all(color: ColorConstants.containerBorderColor)),
        child: Row(
          children: [
            ///Image
            Container(
              height: 10.5.h,
              width: 10.5.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.0.w),
                child: Stack(
                  children: [
                    SizedBox(
                        height: 14.h,
                        width: 14.h,
                        child: isVideo
                            ? CustomNetworkVideo(
                                width: 14.h,
                                height: 14.h,
                                url: imageUrl,
                                key: Key(imageUrl),
                                thumbnail: videoImageThumbnail ?? '',
                              )
                            : CustomNetworkImage(
                                imageUrl: imageUrl,
                                placeholderUrl: customPlaceholder,
                              )),
                    if (isSelected)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            height: 2.h,
                            width: 2.h,
                            color: ColorConstants.appBlue.withOpacity(0.6),
                            child: SvgPicture.asset(
                              'assets/svgs/ic_check_mark_circle.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0.w),
                  border: Border.all(color: ColorConstants.appBlack),
                  shape: BoxShape.rectangle),
            ),

            imagePaddingSpace ?? Spaces.x3,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title and Flag icon
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 54.w,
                      child: Text(
                        translatedTitle,
                        textAlign: TextAlign.start,
                        style: TextStyles.subHeadingSemiBold.copyWith(
                            fontFamily: FontConstants.montserratMedium,
                            fontSize: Spaces.normSP(12)),
                      ),
                    ),
                    if (showNotifyButton)
                      SizedBox(
                        height: 2.5.h,
                        width: 2.5.h,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.notifications,
                            color: ColorConstants.appBlue,
                          ),
                          onPressed: onNotifyPressed,
                        ),
                      ),
                    if (showReportIcon)
                      SizedBox(
                        height: 2.5.h,
                        width: 2.5.h,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            'assets/svgs/ic_report_flag.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          onPressed: onReportButtonPress,
                        ),
                      ),
                  ],
                ),

                /// Description
                if (hasDesc) Spaces.y1,
                if (hasDesc)
                  LimitedBox(
                    maxWidth: 59.w,
                    child: Text(
                      description,
                      style: TextStyles.normalGrayBodyText.copyWith(
                          fontSize: 9.5.sp,
                          fontFamily: FontConstants.montserratMedium),
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                /// Tags
                Spaces.y1,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tag1Text != null)
                      SingleLineTextTag(
                        text: tag1Text!,
                        backgroundColor: tagBackgroundColor,
                        textColor: tagTextColor,
                        theme: ThemeSize.small,
                      ),
                    if (tag1Text != null)
                      SizedBox(
                        width: 1.0.w,
                      ),
                    if (tag2Text != null)
                      SingleLineTextTag(
                        text: tag2Text ?? '',
                        theme: ThemeSize.small,
                      ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
