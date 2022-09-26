import 'dart:io';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/coachProfile/coachOwnProfile/coach_own_profile_controller.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../asset_picker.dart';

class AddVideoDialog extends StatelessWidget {
  final GetxController? mController;
  final ValueChanged<File>? onSavedClick;
  final String? saveBtnTitle;
  final Color? backgroundColor;

  const AddVideoDialog(
      {Key? key,
      this.mController,
      this.onSavedClick,
      this.saveBtnTitle,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.closeAllSnackbars();
    File? selectedVideo;
    return Scaffold(
      backgroundColor: backgroundColor ?? ColorConstants.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
            padding:
                EdgeInsets.only(bottom: Spaces.normY(4), top: Spaces.normY(1)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spaces.normX(2)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                /// Cross button
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                  child: AssetPicker(
                    maxVideoHeight: 30.h,
                    label: 'upload_video'.tr,
                    isImagePicker: false,
                    setSelectedVideo: 'add_video'.tr,
                    onAssetSelected: (file, duration, __) {
                      selectedVideo = file;
                    },
                  ),
                ),

                Spaces.y3,

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: Text('cancel'.tr),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spaces.normX(10),
                              vertical: Spaces.normY(2),
                            ),
                          ),
                        ),
                      ),
                      Spaces.x3,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedVideo == null) {
                              Utils.showSnack('alert'.tr, 'Select video');
                            } else {
                              if (onSavedClick == null) {
                                onSaveClick(selectedVideo);
                              } else {
                                Get.back();
                                onSavedClick!.call(selectedVideo!);
                              }
                            }
                          },
                          child: FittedBox(
                            child: Text(
                              (saveBtnTitle?.isNotEmpty ?? false)
                                  ? saveBtnTitle!.tr
                                  : 'save'.tr,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: ColorConstants.appBlue,
                            padding: EdgeInsets.symmetric(
                              horizontal: Spaces.normX(10),
                              vertical: Spaces.normY(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSaveClick(File? selectedVideo) async {
    if (selectedVideo == null) {
      //Utils.showSnack('alert'.tr, 'Select video');
      return;
    }
    await Get.closeCurrentSnackbar();
    Get.back();
    if (mController is CoachOwnProfileController) {
      CoachOwnProfileController controller =
          mController as CoachOwnProfileController;
      controller.addIntroVideo(selectedVideo.path, selectedVideo);
    } else if (mController is ProfileSetupController) {
      ProfileSetupController controller = mController as ProfileSetupController;
      controller.addIntroVideo(selectedVideo.path, selectedVideo);
    }
  }
}
