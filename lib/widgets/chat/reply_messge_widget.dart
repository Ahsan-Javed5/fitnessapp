import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/model/MessageType.dart';
import 'package:sizer/sizer.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Message? message;
  final VoidCallback onCancelReply;

  const ReplyMessageWidget({
    required this.message,
    required this.onCancelReply,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 2.h),
          child: Row(
            children: [
              Spaces.x5,
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Replying to ',
                          style: TextStyle(
                            color: ColorConstants.gray,
                            fontSize: 10.0.sp,
                          ),
                          children: [
                            TextSpan(
                              text: '${message?.from}',
                              style: TextStyle(
                                  color: ColorConstants.appBlack,
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spaces.y1,
                    Obx(
                      () => Text(
                        getMessage(message!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorConstants.gray,
                          fontSize: 10.0.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spaces.x5,
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: SvgPicture.asset('assets/svgs/ic_chat_cross_icon.svg'),
                  onTap: onCancelReply,
                ),
              ),
            ],
          ),
        ),
      );

  String getMessage(Message message) {
    RxString status = 'Undefined'.obs;
    if (message.meta?.type == MessageType.Text) {
      status.value = message.meta!.text!;
    } else if (message.meta?.type == MessageType.Image) {
      status.value = 'Image';
    } else if (message.meta?.type == MessageType.Video) {
      status.value = 'Video';
    } else {
      status.value = 'Audio';
    }
    return status.value;
  }
}
