import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_reply_message_handler.dart';
import 'package:fitnessapp/screens/video_player_controller.dart';
import 'package:fitnessapp/widgets/chat/chat_swipe_widget.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/utils/time_utils.dart';
import 'package:sizer/sizer.dart';

import '../../video_player_screen.dart';

class IncomingVideoMessageHandler extends GetWidget<ChatApiController> {
  final Message message;
  final ValueChanged<Message> onSwipedMessage;
  final int? position;

  const IncomingVideoMessageHandler(
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
                Container(
                  // decoration: BoxDecoration(
                  //   color: ColorConstants.appBlue.withOpacity(0.2),
                  //   borderRadius: BorderRadius.circular(2.0.w),
                  // ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.0.h,
                      horizontal: 1.0.h,
                    ),
                    child: Column(
                      children: [
                        if (message.replyConversation?.isReply ?? false) ...[
                          IncomingReplyMessageHandler(
                            message: message,
                          ),
                        ] else ...[
                          IncomingChildVideoWidget(
                            extraMap: message.meta!.extraMap!,
                            isReply: false,
                            thumbURl:
                                message.meta?.extraMap?['video_thumbnail'] ??
                                    '',
                            videoUrlV2: message.meta?.extraMap?['video_url'] ??
                                message.meta?.fileUrl,
                          )
                        ],
                      ],
                    ),
                  ),
                ),
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

class IncomingChildVideoWidget extends GetWidget<ChatApiController> {
  final String thumbURl;
  final String videoUrlV2;
  final bool isReply;
  final Map? extraMap;

  const IncomingChildVideoWidget({
    Key? key,
    required this.extraMap,
    required this.thumbURl,
    required this.videoUrlV2,
    required this.isReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoPlayerController controller = Get.isRegistered<VideoPlayerController>()
        ? Get.find<VideoPlayerController>()
        : Get.put(VideoPlayerController());
    String? videoUrl = videoUrlV2;
    String? vThumb = thumbURl;
    String navKey = extraMap != null ? extraMap!['nav_path'] : '';
    bool isHavePathKeys = navKey.isEmpty ? false : true;
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: SizedBox(
                width: double.infinity,
                height: isReply ? 17.h : 20.h,
                child: CustomNetworkVideo(
                  url: videoUrl,
                  inChat: true,
                  thumbnail: vThumb,
                  width: double.infinity,
                  height: isReply ? 17.h : 27.h,
                  onPlayButtonClick: () {
                    showDialog(
                      context: context,
                      builder: (context) => VideoPlayerScreen(
                        url: videoUrl,
                        videoId: -1,
                        processStatus: 1,
                        videoStreamUrl: controller.isStreamingVideo(videoUrl)
                            ? videoUrl
                            : '',
                      ),
                      useSafeArea: false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        if (isHavePathKeys) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              extraMap?['reason'] ?? 'Nothing',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0.sp,
              ),
            ),
          ),
          SizedBox(height: 1.0.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              extraMap?['nav_path'].toString().toUpperCase() ?? 'Nothing',
              softWrap: true,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorConstants.bodyTextColor,
                fontSize: 10.0.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
