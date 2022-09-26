import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/config/theme_size.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/view_as_type.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
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

///This screen will show while deep linking

class VideoDetailScreenDeepLinking extends StatelessWidget {
  const VideoDetailScreenDeepLinking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final type = args == null ? ViewAsType.defaultView : args['viewAs'];
    final videoId = args == null ? '' : args['videoID'];
    final controller = Get.find<VideoListController>();

    Future.delayed(const Duration(seconds: 1), () {
      controller.videoDetail = null;
      controller.isDataLoaded.value = false;
      if (videoId.toString().isNotEmpty) {
        controller
            .getVideoFromId(videoId); //get video data from API with video id
      }
    });

    return GradientBackground(
      includePadding: false,
      child: Obx(() {
        return Scaffold(
          key: UniqueKey(),
          backgroundColor:
              controller.isDataLoaded.value ? Colors.transparent : Colors.white,
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
                                      url: controller.videoDetail?.videoUrl
                                              .toString() ??
                                          '',
                                      videoId: -1,
                                      processStatus: 1,
                                      videoStreamUrl: controller
                                              .videoDetail?.videoStreamUrl ??
                                          '',
                                    ),
                                useSafeArea: false);
                          },
                          child: CustomNetworkVideo(
                            width: 100.w,
                            height: 41.h,
                            key: UniqueKey(),
                            url: controller.videoDetail?.videoUrl?.toString() ??
                                '',
                            thumbnail: controller.videoDetail?.thumbnail ?? '',
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
                                      url: controller.videoDetail?.videoUrl
                                              .toString() ??
                                          '',
                                      videoId: -1,
                                      processStatus: 1,
                                      videoStreamUrl: controller
                                              .videoDetail?.videoStreamUrl ??
                                          ''),
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
                              controller.videoDetail?.title ?? '',
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
                          if (type == ViewAsType.defaultView)
                            IconButton(
                              onPressed: () async {
                                int? vId = controller.videoDetail?.id;
                                if (vId != null) {
                                  String url = await Utils.getDynamicLink(
                                      vId.toString(), '', '');
                                  showShareLauncherDialog(url);
                                }
                                /* String? url = controller.videoDetail?.videoUrl.toString();
            ``

                                if (url != null) {
                                  url = '${Routes.baseUrl}$url';
                                  showShareLauncherDialog(url);
                                }*/
                              },
                              icon: SvgPicture.asset(
                                'assets/svgs/ic_share_bg.svg',
                                matchTextDirection: false,
                              ),
                            ),
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
                              text: controller.workoutProgramTypeString ?? '',
                              theme: ThemeSize.small,
                              maxWidth: 70.w,
                            ),
                            Spaces.x4,
                            SingleLineTextTag(
                              text: controller.videoDetail?.formattedTime ?? '',
                              theme: ThemeSize.small,
                            ),
                          ],
                        ),
                      ),

                      Spaces.y1_0,
                      //if (Utils.isSubscribedUser() && controller.isAllowChat)
                      if (MyHive.getUser() != null && controller.isAllowChat)
                        SizedBox(
                          height: 3.8.h,
                          width: 50.w,
                          child: CustomElevatedButton(
                            onPressed: () => Utils.open1to1Chat(
                                MyHive.getUser()?.firebaseKey ?? '',
                                controller.coachFirebaseKey ?? '',
                                context),
                            text: 'ask_coach_a_question'.tr,
                            textStyle: TextStyles.normalWhiteBodyText.copyWith(
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
                        controller.videoDetail?.description ?? '',
                        textAlign: TextAlign.justify,
                      ),
                      Spaces.y4,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
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
