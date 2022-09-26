import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:sizer/sizer.dart';

import '../../data/local/my_hive.dart';

/// New ImageWidget thats why i needs to include [MyHive.sasKey] inside the url
class ChatNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final bool isReplaying;
  final Color imageBackgroundColor;
  final Message message;
  final int? position;
  const ChatNetworkImage(
      {Key? key,
      this.height,
      this.width,
      required this.imageBackgroundColor,
      required this.message,
      required this.isReplaying,
      this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///the issue was here because i did remove sas key from message section because in reply section from web i was getting key with the image
    ///url that's why i remove this and now i decided to put a check whether it contains or not , handle it accordingly

    bool hasSasKey =
        (message.replyConversation?.message?.contains('?sv=') ?? false)
            ? true
            : false;
    final imageUrl = (isReplaying)
        ? !hasSasKey
            ? '${message.replyConversation?.message}${MyHive.sasKey}'
            : message.replyConversation?.message
        : '${message.meta?.fileUrl}${MyHive.sasKey}';
    return Container(
      padding: EdgeInsets.all(1.h),
      height: height ?? 23.h,
      width: width ?? Get.width / 2.1,
      decoration: BoxDecoration(
        color: imageBackgroundColor,
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: CachedNetworkImage(
        height: 23.h,
        width: Get.width / 2.1,
        alignment: Alignment.center,
        fadeInCurve: Curves.easeIn,
        fit: BoxFit.scaleDown,
        color: ColorConstants.appBlue,

        ///[isReplaying] is true then the image url is inside the message body
        ///else image url will be inside meta
        imageUrl: '$imageUrl',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Image.asset(
          'assets/images/splash_bg_with_logo.png',
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/splash_bg_with_logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
