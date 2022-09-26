import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_reply_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_sub_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

class ChatImageView extends StatelessWidget {
  final Message message;
  final MainAxisAlignment mainAxisAlignment;
  final double startMargin;
  final double endMargin;
  final double? height;
  final double? width;
  final Color imageBackgroundColor;
  final int position;
  final EdgeInsets timeMargin;

  const ChatImageView(
      {Key? key,
      required this.message,
      required this.mainAxisAlignment,
      required this.startMargin,
      this.height,
      this.width,
      required this.endMargin,
      required this.imageBackgroundColor,
      required this.position,
      required this.timeMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        ///Start margin
        SizedBox(
          width: startMargin,
        ),

        ///Main Content
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.replyConversation?.isReply ?? false) ...[
                OutgoingReplyMessageHandler(
                  message: message,
                  position: position,
                ),
              ] else ...[
                ChatNetworkImage(
                  position: position,
                  imageBackgroundColor: imageBackgroundColor,
                  message: message,
                  isReplaying: false,
                  height: height,
                  width: width,
                )
              ],

              SizedBox(
                height: 0.5.h,
              ),

              ///Time view
              Container(
                margin: timeMargin,
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
          width: endMargin,
        ),
      ],
    );
  }
}
