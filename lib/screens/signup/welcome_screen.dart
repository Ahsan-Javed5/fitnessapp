import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../video_player_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spaces.y9,

            /// Main title
            Padding(
              padding: Spaces.getHoriPadding(),
              child: Text(
                '${Utils.isRTL() ? 'أهلا بك' : 'Welcome'} ${MyHive.getUser()?.getFullName() ?? ''}',
                style: Get.textTheme.headline1,
              ),
            ),
            Spaces.y1_0,
            Padding(
              padding: Spaces.getHoriPadding(),
              child: Text(
                'welcome_desc'.tr,
              ),
            ),

            const Spacer(),

            SizedBox(
              height: Spaces.normY(41),
              child: Stack(
                children: [
                  /// Video background
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    end: 0,
                    child: CustomNetworkVideo(
                      url: '${MyHive.getUser()?.localizedVideo}',
                      thumbnail: '${MyHive.getUser()?.localizedVideoThumbnail}',
                      width: Spaces.normX(100),
                      height: Spaces.normY(41),
                      onPlayButtonClick: () {
                        showDialog(
                            builder: (BuildContext context) =>
                                VideoPlayerScreen(
                                  url: '${MyHive.getUser()?.localizedVideo}',
                                  videoId: -1,
                                  processStatus: 2,
                                  videoStreamUrl: MyHive.getUser()
                                          ?.localizedStreamVideoUrl ??
                                      '',
                                ),
                            context: context,
                            useSafeArea: false);
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// Continue button
            const Spacer(),
            Padding(
              padding: Spaces.getHoriPadding(),
              child: CustomElevatedButton(
                text: 'next'.tr,
                onPressed: () {
                  Get.toNamed(Routes.profileSetupScreen);
                },
              ),
            ),
            Spaces.y5,
          ],
        ),
      ),
    );
  }
}
