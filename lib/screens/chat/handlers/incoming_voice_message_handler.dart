import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_reply_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/chat/voice_message_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

class IncomingVoiceMessageHandler extends StatelessWidget {
  final Message message;
  final ValueChanged<Message>? onSwipedMessage;
  final int? position;
  const IncomingVoiceMessageHandler(
      {Key? key,
      required this.message,
      required this.onSwipedMessage,
      this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeMessage(
      ///will return swiped message
      onRightSwipe: () => onSwipedMessage?.call(message),
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
                ///audio incoming voice message
                if (message.replyConversation?.isReply ?? false) ...[
                  IncomingReplyMessageHandler(message: message),
                ] else ...[
                  /// if replay was false
                  AudioPlayerWidget(
                    playUrl: '${message.meta!.audioUrl!}${MyHive.sasKey}',
                    playBtnBackgroundColor: ColorConstants.whiteColor,
                    playBtnColor: ColorConstants.appBlue,
                    message: message,
                    durationTextColor: ColorConstants.whiteColor,
                    position: position,
                    thumbColor: ColorConstants.whiteColor,
                    seekBarColor: ColorConstants.whiteColor,
                    backgroundCardColor: ColorConstants.appBlue,
                  ),
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
            width: 18.0.w,
          ),
        ],
      ),
    );
  }
}
