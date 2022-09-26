import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/widgets/chat/chat_image_widget.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/chat/full_photo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:sizer/sizer.dart';

class OutGoingImageViewHandler extends StatelessWidget {
  final Message message;
  final ValueChanged<Message> onSwipedMessage;
  final int position;
  const OutGoingImageViewHandler(
      {Key? key,
      required this.message,
      required this.onSwipedMessage,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onLeftSwipe: () => onSwipedMessage(message),
      child: GestureDetector(
        onTap: () {
          ///no needs to pass [MyHive.sasKey] because [CustomNetworkImage] is auto adding it inside the url
          final imageUrl = message.meta?.fileUrl ?? '';
          Get.dialog(
            FullPhoto(
              imageUrl: imageUrl,
            ),
          );
        },
        child: ChatImageView(
          position: position,
          endMargin: 1.5.h,
          timeMargin: EdgeInsets.only(left: 9.0.h),
          imageBackgroundColor: ColorConstants.grayVeryLight,
          mainAxisAlignment: MainAxisAlignment.end,
          message: message,
          startMargin: 12.w,
        ),
      ),
    );
  }
}
