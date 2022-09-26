import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_reply_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/text_link_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

class OutgoingTextMessageHandler extends GetWidget<ChatApiController> {
  final Message message;
  final ValueChanged<Message> onSwipedMessage;
  final int? position;
  const OutgoingTextMessageHandler({
    required this.message,
    required this.onSwipedMessage,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onLeftSwipe: () => onSwipedMessage(message),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ///start margin
          SizedBox(
            width: 12.w,
          ),

          ///Main content

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.replyConversation?.isReply ?? false) ...[
                  OutgoingReplyMessageHandler(
                    position: position,
                    message: message,
                  ),
                ] else ...[
                  OutgoingMessageTextChildWidget(
                    message: message,
                    width: null,
                  )
                ],

                SizedBox(
                  height: 0.5.h,
                ),

                ///Time view
                Container(
                  margin: EdgeInsets.only(left: 9.0.h),
                  child: Text(
                    TimeUtils.getTimeInddMMMyyHHMM(message.date ?? 0),
                    style: TextStyle(
                      color: ColorConstants.appBlack,
                      fontSize: 9.0.sp,
                    ),
                  ),
                ),

                ///bottom margin
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),

          ///end margin
          SizedBox(
            width: 1.5.h,
          ),
        ],
      ),
    );
  }
}

class OutgoingMessageTextChildWidget extends StatelessWidget {
  final Message message;
  final double? width;
  const OutgoingMessageTextChildWidget(
      {Key? key, required this.message, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: ColorConstants.grayVeryLight,
        borderRadius: BorderRadius.circular(2.0.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 1.0.h),
        child: GetUtils.isURL(message.meta?.text ?? '')
            ? LinkTextWidget(
                message: message.meta?.text ?? '',
                isMe: true,
              )
            : SelectableText(
                message.meta?.text ?? '',
                style: TextStyle(
                  color: ColorConstants.appBlack,
                  fontSize: 12.0.sp,
                ),
              ),
      ),
    );
  }
}
