import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/dialogs/add_video_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../video_player_screen.dart';

class UploadIntroVideoScreen extends StatelessWidget {
  const UploadIntroVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileSetupController controller = Get.find();
    final allowPrivateQus = controller.getUser()!.allowPrivateChat!.obs;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'introduction_video'.tr,
            style: TextStyles.mainScreenHeading,
          ),

          /// Desc
          Spaces.y1_0,
          Text(
            'please_upload_your_introductory_video'.tr,
            textAlign: TextAlign.justify,
          ),

          Spaces.y1_0,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  'introduction_video'.tr.toUpperCase(),
                  maxLines: 1,
                  softWrap: true,
                  style: TextStyles.normalGrayBodyText
                      .copyWith(fontSize: Spaces.normSP(10)),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.closeAllSnackbars();
                  Future.delayed(100.milliseconds,
                      () => _showAddIntroVideoDialog(context, controller));
                },
                icon: SvgPicture.asset('assets/svgs/ic_upload.svg'),
                label: Text(
                  'add_new'.tr,
                  style: TextStyles.normalBlackBodyText.copyWith(
                    fontSize: Spaces.normSP(9),
                  ),
                ),
              ),
              Spaces.x2,
              TextButton.icon(
                onPressed: () {
                  _removeIntroVideo(controller);
                },
                icon: SvgPicture.asset('assets/svgs/ic_close_circled.svg'),
                label: Text(
                  'remove'.tr,
                  style: TextStyles.normalBlackBodyText.copyWith(
                    fontSize: Spaces.normSP(9),
                  ),
                ),
              ),
            ],
          ),

          Spaces.y1_0,
          GetBuilder<ProfileSetupController>(
            id: 'introBuilder',
            builder: (c) {
              return Stack(
                children: [
                  introVideoImage(controller),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (hasIntroVideo(controller)) {
                            showDialog(
                                context: context,
                                builder: (context) => VideoPlayerScreen(
                                      url: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.videoUrl ??
                                          '',
                                      videoId: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.id ??
                                          -1,
                                      processStatus: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.isProcessed ??
                                          1,
                                      videoStreamUrl: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.videoStreamUrl ??
                                          '',
                                      ifCoachIntroVideoThenId:
                                          MyHive.getUser()!.id!.toString(),
                                    ),
                                useSafeArea: false);
                          } else {
                            Utils.showSnack(
                                'alert'.tr, 'no_intro_video_found'.tr);
                          }
                        },
                        child: hasIntroVideo(controller)
                            ? SvgPicture.asset(
                                'assets/svgs/ic_video_play.svg',
                                fit: BoxFit.scaleDown,
                              )
                            : const SizedBox()),
                  )
                ],
              );
            },
          ),

          ///allow private chat checkbox
          Spaces.y3,
          Obx(() {
            return CheckboxListTile(
              value: allowPrivateQus.value,
              onChanged: (b) {
                allowPrivateQus.value = b!;
              },
              dense: true,
              title: Text(
                'allow_private_question'.tr,
                textAlign: TextAlign.start,
                style: TextStyles.normalBlackBodyText,
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),

          /// Save button
          Spaces.y4,
          CustomElevatedButton(
              text: 'next'.tr,
              enabled: controller.isUpdateButtonEnabled,
              onPressed: () {
                if (controller.videoUrl.isEmpty) {
                  Utils.showSnack('alert'.tr, 'Please add intro video');
                  return;
                }
                var allowQus = allowPrivateQus.value;
                controller.body['allow_private_chat'] = allowQus;
                controller.updateCoachProfileDetails();
              }),

          SizedBox(
            height: Spaces.normY(40),
          ),
        ],
      ),
    );
  }

  bool hasIntroVideo(ProfileSetupController controller) {
    return controller.videoUrl.isNotEmpty;
  }

  /// Add intro video dialog
  void _showAddIntroVideoDialog(
      BuildContext context, ProfileSetupController controller) {
    showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (context) {
        return AddVideoDialog(mController: controller);
      },
    );
  }

  /// thumbnail of intro video or placeholder if video is not added
  Widget introVideoImage(ProfileSetupController controller) {
    if (hasIntroVideo(controller)) {
      return CustomNetworkVideo(
        width: Spaces.normX(100),
        height: Spaces.normY(27),
        url: controller.videoUrl.value,
        thumbnail: controller.videoThumbnail,
      );
    } else {
      return Image.asset(
        'assets/images/video_placeholder.png',
        height: Spaces.normY(27),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  void _removeIntroVideo(ProfileSetupController controller) {
    if (hasIntroVideo(controller)) {
      controller.removeIntroVideo();
    } else {
      Utils.showSnack('alert'.tr, 'no_intro_video_found'.tr);
    }
  }
}
