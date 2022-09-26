import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_text_message_handler.dart';
import 'package:fitnessapp/screens/chat/handlers/incoming_video_message_handler.dart';
import 'package:fitnessapp/widgets/chat/chat_sub_network_image.dart';
import 'package:fitnessapp/widgets/chat/full_photo.dart';
import 'package:fitnessapp/widgets/chat/voice_message_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/model/MessageType.dart';
import 'package:sizer/sizer.dart';

/// we can also replace other widgets with this because
/// all the related widgets available in this
class IncomingReplyMessageHandler extends StatelessWidget {
  final Message message;

  const IncomingReplyMessageHandler({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      width: Get.width / 1.6,

      ///replay background color
      decoration: BoxDecoration(
        color: message.type == MessageType.Video
            ? ColorConstants.transparent
            : ColorConstants.appBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// replayed Widgets Content
          GestureDetector(
            onTap: () {
              if (message.replyConversation?.type == MessageType.Image) {
                final imageUrl = (message.replyConversation?.isReply ?? false)
                    ? message.replyConversation!.message
                    : message.meta?.fileUrl ?? '';
                Get.dialog(
                  FullPhoto(
                    imageUrl: imageUrl!,
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///user name to whom i am replying
                  Text(
                    message.replyConversation?.userId ?? '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.appBlack,
                    ),
                  ),
                  Spaces.y1,

                  ///replying content
                  if (message.replyConversation?.type == MessageType.Text) ...[
                    Text(
                      message.replyConversation?.message ?? 'No Message Found',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.gray,
                        fontSize: 10.sp,
                      ),
                    ),
                  ] else if (message.replyConversation?.type ==
                      MessageType.Image) ...[
                    ChatNetworkImage(
                      imageBackgroundColor: ColorConstants.transparent,
                      message: message,
                      isReplaying: true,
                      height: 23.h,
                      width: Get.width / 1.6,
                    ),
                  ] else if (message.replyConversation?.type ==
                      MessageType.Audio) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: AudioPlayerWidget(
                        playUrl: message.replyConversation!.message!,
                        durationTextColor: ColorConstants.appBlack,
                        thumbColor: ColorConstants.appBlue,
                        playBtnBackgroundColor: ColorConstants.appBlue,
                        playBtnColor: ColorConstants.whiteColor,
                        message: message,
                        seekBarColor: ColorConstants.appBlue,
                        backgroundCardColor: ColorConstants.grayVeryLight,
                      ),
                    )
                  ] else if (message.replyConversation?.type ==
                      MessageType.Video) ...[
                    ///isReply this will show this is inner message
                    IncomingChildVideoWidget(
                      extraMap: message.meta?.extraMap,
                      isReply: true,
                      thumbURl:
                          message.replyConversation?.video_thumbnail ?? '',
                      videoUrlV2: message.replyConversation?.message ?? '',
                    )
                  ],
                  Spaces.y1,
                ],
              ),
            ),
          ),

          /// here i will have to put some checks on the ui building
          /// image , audio , text , video

          if (message.meta?.type == MessageType.Text) ...[
            IncomingMessageTextChildWidget(
              message: message,
              width: Get.width,
            ),
          ] else if (message.meta?.type == MessageType.Image) ...[
            ChatNetworkImage(
              imageBackgroundColor: ColorConstants.whiteColor,
              message: message,
              isReplaying: false,
              height: 23.h,
              width: Get.width / 1.6,
            ),
          ] else if (message.meta?.type == MessageType.Audio) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: AudioPlayerWidget(
                playUrl: '${message.meta!.audioUrl!}${MyHive.sasKey}',
                durationTextColor: ColorConstants.whiteColor,
                thumbColor: ColorConstants.whiteColor,
                playBtnBackgroundColor: ColorConstants.whiteColor,
                playBtnColor: ColorConstants.appBlue,
                message: message,
                seekBarColor: ColorConstants.whiteColor,
                backgroundCardColor: ColorConstants.appBlue,
              ),
            )
          ] else if (message.meta?.type == MessageType.Video) ...[
            IncomingChildVideoWidget(
              extraMap: message.meta!.extraMap!,
              isReply: false,
              thumbURl: message.meta?.extraMap?['video_thumbnail'] ?? '',
              videoUrlV2:
                  message.meta?.extraMap?['video_url'] ?? message.meta?.fileUrl,
            )
          ],
        ],
      ),
    );
  }
}

/// we can also replace other widgets with this because
/// all the related widgets available in this
// class OutgoingReplyMessageHandler extends StatelessWidget {
//   final Message message;
//   final int? position;
//   const OutgoingReplyMessageHandler({
//     Key? key,
//     required this.message,
//     this.position,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//       width: Get.width / 1.6,
//       decoration: BoxDecoration(
//         color: ColorConstants.appBlue.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// replayed Widgets Content
//           GestureDetector(
//             onTap: () {
//               if (message.replyConversation?.type == MessageType.Image) {
//                 final imageUrl = (message.replyConversation?.isReply ?? false)
//                     ? message.replyConversation!.message
//                     : message.meta?.fileUrl ?? '';
//                 Get.dialog(
//                   FullPhoto(
//                     imageUrl: imageUrl!,
//                   ),
//                 );
//               }
//             },
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ///user name to whom i am replying
//                   Text(
//                     message.replyConversation?.userId ?? '',
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: ColorConstants.appBlack,
//                     ),
//                   ),
//                   Spaces.y1,
//
//                   ///inside reply content
//                   if (message.replyConversation?.type == MessageType.Text) ...[
//                     Text(
//                       message.replyConversation?.message ?? 'No Message Found',
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: ColorConstants.gray,
//                         fontSize: 10.sp,
//                       ),
//                     ),
//                   ] else if (message.replyConversation?.type ==
//                       MessageType.Image) ...[
//                     ChatNetworkImage(
//                       position: position,
//                       imageBackgroundColor: ColorConstants.transparent,
//                       message: message,
//                       isReplaying: true,
//                       height: 23.h,
//                       width: Get.width / 1.6,
//                     ),
//                   ] else if (message.replyConversation?.type ==
//                       MessageType.Audio) ...[
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 1.w),
//                       child: AudioPlayerWidget(
//                         position: position,
//                         playUrl: message.replyConversation!.message!,
//                         durationTextColor: ColorConstants.appBlack,
//                         thumbColor: ColorConstants.appBlue,
//                         playBtnBackgroundColor: ColorConstants.appBlue,
//                         playBtnColor: ColorConstants.whiteColor,
//                         message: message,
//                         seekBarColor: ColorConstants.appBlue,
//                         backgroundCardColor: ColorConstants.grayVeryLight,
//                       ),
//                     )
//                   ] else if (message.replyConversation?.type ==
//                       MessageType.Video) ...[
//                     OutGoingChildVideoWidget(
//                       videoUrlV2: message.replyConversation?.message ?? '',
//                       thumbURl:
//                       message.replyConversation?.video_thumbnail ?? '',
//                       isReply: false,
//                       extraMap: message.meta?.extraMap,
//                     ),
//                   ],
//                   Spaces.y1,
//                 ],
//               ),
//             ),
//           ),
//
//           ///outer reply of the mention message
//           if (message.meta?.type == MessageType.Text) ...[
//             OutgoingMessageTextChildWidget(
//               message: message,
//               width: Get.width,
//             ),
//           ] else if (message.meta?.type == MessageType.Image) ...[
//             ChatNetworkImage(
//               position: position,
//               imageBackgroundColor: ColorConstants.whiteColor,
//               message: message,
//               isReplaying: false,
//               height: 17.h,
//               width: Get.width / 1.6,
//             ),
//           ] else if (message.meta?.type == MessageType.Audio) ...[
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 1.w),
//               child: AudioPlayerWidget(
//                 playUrl: '${message.meta!.audioUrl!}${MyHive.sasKey}',
//                 position: position,
//                 durationTextColor: ColorConstants.appBlack,
//                 thumbColor: ColorConstants.appBlue,
//                 playBtnBackgroundColor: ColorConstants.appBlue,
//                 playBtnColor: ColorConstants.whiteColor,
//                 message: message,
//                 seekBarColor: ColorConstants.appBlue,
//                 backgroundCardColor: ColorConstants.grayVeryLight,
//               ),
//             )
//           ] else if (message.meta?.type == MessageType.Video) ...[
//             OutGoingChildVideoWidget(
//               extraMap: message.meta?.extraMap,
//               isReply: false,
//               videoUrlV2:
//               message.meta?.extraMap?['video_url'] ?? message.meta?.fileUrl,
//               thumbURl: message.meta?.extraMap?['video_thumbnail'] ?? '',
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
