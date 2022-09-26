import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/config/theme_size.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/view_as_type.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/coachProfile/video_list_controller.dart';
import 'package:fitnessapp/screens/video_player_screen.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/buttons/multi_line_text_tag.dart';
import 'package:fitnessapp/widgets/buttons/single_line_text_tag.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final type = args == null ? ViewAsType.defaultView : args['viewAs'];

    return GetBuilder<VideoListController>(
        id: 'video_detail_list',
        builder: (controller) {
          return GradientBackground(
            includePadding: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 41.0.h,
                      child: Stack(
                        children: [
                          /// Video background
                          PositionedDirectional(
                            top: 0,
                            start: 0,
                            end: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => VideoPlayerScreen(
                                        url: controller.videoDetail!.videoUrl
                                            .toString(),
                                        videoId: -1,
                                        processStatus: 1,
                                        videoStreamUrl: controller
                                                .videoDetail?.videoStreamUrl ??
                                            ''),
                                    useSafeArea: false);
                              },
                              child: CustomNetworkVideo(
                                width: 100.w,
                                height: 41.h,
                                key: UniqueKey(),
                                url:
                                    controller.videoDetail!.videoUrl.toString(),
                                thumbnail:
                                    controller.videoDetail?.thumbnail ?? '',
                              ),
                            ),
                          ),

                          /// Video play button
                          PositionedDirectional(
                            start: 0,
                            end: 0,
                            top: 0,
                            bottom: 0,
                            child: SizedBox(
                              height: 10.h,
                              width: 10.h,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => VideoPlayerScreen(
                                            url: controller
                                                .videoDetail!.videoUrl
                                                .toString(),
                                            processStatus: 1,
                                            videoId: -1,
                                            videoStreamUrl: controller
                                                    .videoDetail
                                                    ?.videoStreamUrl ??
                                                '',
                                          ),
                                      useSafeArea: false);
                                },
                                child: SvgPicture.asset(
                                  'assets/svgs/ic_video_play.svg',
                                  matchTextDirection: false,
                                  fit: BoxFit.scaleDown,
                                  height: 10.h,
                                  width: 10.h,
                                ),
                              ),
                            ),
                          ),

                          /// Back button
                          PositionedDirectional(
                            top: 0,
                            start: 0,
                            child: IconButton(
                              iconSize: 5.0.h,
                              padding: EdgeInsetsDirectional.only(
                                  top: 4.0.h, start: 4.0.w),
                              icon: SvgPicture.asset(
                                'assets/svgs/ic_back_elevated.svg',
                                matchTextDirection: true,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Remaining body of the screen
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 4.0.w, end: 4.0.w, bottom: Spaces.normY(5)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Video title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.videoDetail?.title,
                                  style: Get.textTheme.headline1,
                                ),
                              ),
                              if (Utils.isUser())
                                IconButton(
                                  onPressed: () => controller.sendReportMessage(
                                      video: controller.videoDetail!),
                                  icon: SvgPicture.asset(
                                    'assets/svgs/ic_report_flag.svg',
                                    matchTextDirection: false,
                                  ),
                                ),
                              //,if (type == ViewAsType.defaultView)
                                // IconButton(
                                //   onPressed: () async {
                                //     int? vId = controller.videoDetail?.id;
                                //     if (vId != null) {
                                //       String url = await Utils.getDynamicLink(
                                //           vId.toString(),
                                //           controller.workoutProgramTypeString ??
                                //               '',
                                //           controller.navigationString ?? '');
                                //       showShareLauncherDialog(url);
                                //     }
                                //     /*String? url = controller
                                //         .videoDetail?.videoUrl
                                //         .toString();
                                //     if (url != null) {
                                //       url = '${Routes.baseUrl}$url';
                                //       showShareLauncherDialog(url);
                                //     }*/
                                //   },
                                //   icon: SvgPicture.asset(
                                //     'assets/svgs/ic_share_bg.svg',
                                //     matchTextDirection: false,
                                //   ),
                                // ),
                            ],
                          ),

                          /// Tags
                          Spaces.y1_0,
                          SizedBox(
                            height: Get.locale == const Locale('ar', 'SA')
                                ? Spaces.normX(6)
                                : Spaces.normX(5.5),
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                SingleLineTextTag(
                                  text: controller.videoDetail?.duration ?? '',
                                  theme: ThemeSize.small,
                                ),
                                Spaces.x4,
                                SingleLineTextTag(
                                  text:
                                      controller.workoutProgramTypeString ?? '',
                                  theme: ThemeSize.small,
                                  maxWidth: 70.w,
                                ),
                                Spaces.x4,
                                SingleLineTextTag(
                                  text: controller.videoDetail?.formattedTime,
                                  theme: ThemeSize.small,
                                ),
                              ],
                            ),
                          ),

                          Spaces.y1_0,
                          if (Utils.isSubscribedUser() &&
                              controller.isAllowChat)
                            SizedBox(
                              height: 3.8.h,
                              width: 50.w,
                              child: CustomElevatedButton(
                                onPressed: () {
                                  controller.sendReportMessage(
                                    video: controller.videoDetail!,
                                    coachId: controller.coachFirebaseKey ?? '',
                                    sendToAdmin: false,
                                    text:
                                        'Hi, I would like to ask about this video.',
                                  );
                                },
                                text: 'ask_coach_a_question'.tr,
                                textStyle:
                                    TextStyles.normalWhiteBodyText.copyWith(
                                  fontFamily: FontConstants.montserratMedium,
                                ),
                              ),
                            ),

                          if (type == ViewAsType.self)
                            MultiLineTextTag(
                                text: controller.navigationString ?? ''),

                          /// Video Description
                          Spaces.y2_0,
                          Text(
                            controller.videoDetail?.description,
                            textAlign: TextAlign.justify,
                          ),
                          Spaces.y4,
                          if (type == ViewAsType.defaultView &&
                              controller.nextVideoList.isNotEmpty)
                            Text(
                              'next_video'.tr,
                              style: TextStyles.subHeadingSemiBold,
                            ),
                          Spaces.y1_0,
                          if (type == ViewAsType.defaultView)
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.nextVideoList.length,
                              itemBuilder: (context, index) {
                                return GroupListItem(
                                    index: index,
                                    translatedTitle:
                                        controller.nextVideoList[index].title!,
                                    showReportIcon: false,
                                    description: controller
                                        .nextVideoList[index].description,
                                    imageUrl: controller
                                        .nextVideoList[index].videoUrl
                                        .toString(),
                                    isVideo: true,
                                    videoImageThumbnail: controller
                                        .nextVideoList[index].thumbnail,
                                    tag2Text: controller
                                        .nextVideoList[index].formattedTime,
                                    onPressed: () {
                                      controller.setVideoDetailListData();
                                    });
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// Launcher dialog to share video URL
  showShareLauncherDialog(String url) async {
    await FlutterShare.share(
        title: 'Video',
        text: 'Hi i am watching this video. ',
        linkUrl: url,
        chooserTitle: 'Share Video');
  }
}
