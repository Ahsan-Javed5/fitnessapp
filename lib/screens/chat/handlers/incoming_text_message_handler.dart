import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_reply_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/text_link_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

class IncomingTextMessageHandler extends GetWidget<ChatApiController> {
  final Message message;
  final int? position;

  ///this will be callback(contain Message) that i will receive in the main chat page
  final ValueChanged<Message> onSwipedMessage;

  const IncomingTextMessageHandler(
      {required this.message,
      required this.onSwipedMessage,
      this.position,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onRightSwipe: () => onSwipedMessage(message),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///Start margin
          SizedBox(
            width: 1.5.h,
          ),

          ///Main Content
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.replyConversation?.isReply ?? false) ...[
                  IncomingReplyMessageHandler(
                    message: message,
                  ),
                ] else ...[
                  IncomingMessageTextChildWidget(
                    message: message,
                  )
                ],
                SizedBox(
                  height: 0.5.h,
                ),

                ///Time view
                Container(
                  margin: EdgeInsets.only(right: 9.0.h),
                  child: Text(
                    TimeUtils.getTimeInddMMMyyHHMM(message.date ?? 0),
                    style: TextStyle(
                      color: ColorConstants.appBlack,
                      fontSize: 9.0.sp,
                    ),
                  ),
                ),

                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),

          ///end margin
          SizedBox(
            width: 12.0.w,
          ),
        ],
      ),
    );
  }
}

class IncomingMessageTextChildWidget extends StatelessWidget {
  final Message message;
  final double? width;
  const IncomingMessageTextChildWidget(
      {Key? key, required this.message, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: ColorConstants.appBlue,
        borderRadius: BorderRadius.circular(2.0.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 1.0.h),
        child: GetUtils.isURL(message.meta?.text ?? '')
            ? LinkTextWidget(
                message: message.meta?.text ?? '',
                isMe: false,
              )
            : SelectableText(
                message.meta?.text ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0.sp,
                ),
              ),
      ),
    );
  }
}
