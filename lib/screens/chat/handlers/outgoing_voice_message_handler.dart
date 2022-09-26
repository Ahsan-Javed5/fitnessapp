import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/chat/handlers/outgoing_reply_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/chat/voice_message_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

class OutgoingVoiceMessageHandler extends StatelessWidget {
  final Message message;
  final ValueChanged<Message>? onSwipedMessage;
  final int? position;
  const OutgoingVoiceMessageHandler({
    Key? key,
    required this.message,
    required this.onSwipedMessage,
    this.position,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onLeftSwipe: () => onSwipedMessage?.call(message),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ///start margin
          SizedBox(
            width: 18.w,
          ),

          ///Main content
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ///audio widet
                if (message.replyConversation?.isReply ?? false) ...[
                  OutgoingReplyMessageHandler(
                      message: message, position: position),
                ] else ...[
                  AudioPlayerWidget(
                    playUrl: '${message.meta!.audioUrl!}${MyHive.sasKey}',
                    position: position,
                    durationTextColor: ColorConstants.appBlack,
                    thumbColor: ColorConstants.appBlue,
                    playBtnBackgroundColor: ColorConstants.appBlue,
                    playBtnColor: ColorConstants.whiteColor,
                    message: message,
                    seekBarColor: ColorConstants.appBlue,
                    backgroundCardColor: ColorConstants.grayVeryLight,
                  ),
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
                  height: 0.5.h,
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
