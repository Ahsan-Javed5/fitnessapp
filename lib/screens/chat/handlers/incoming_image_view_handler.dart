import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/widgets/chat/chat_image_widget.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/chat/full_photo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:sizer/sizer.dart';

class IncomingImageViewHandler extends StatelessWidget {
  final Message message;
  final ValueChanged<Message> onSwipedMessage;
  final int position;
  const IncomingImageViewHandler(
      {Key? key,
      required this.message,
      required this.onSwipedMessage,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onRightSwipe: () => onSwipedMessage(message),

      child: GestureDetector(
        onTap: () {
          final imageUrl = message.meta?.fileUrl;
          Get.dialog(
            FullPhoto(
              imageUrl: imageUrl!,
            ),
          );
        },
        child: ChatImageView(
          endMargin: 12.0.w,
          position: position,
          timeMargin: EdgeInsets.only(right: 12.0.h),
          imageBackgroundColor: ColorConstants.appBlue,
          mainAxisAlignment: MainAxisAlignment.start,
          message: message,
          startMargin: 1.5.h,
        ),
      ),
    );
  }
}
