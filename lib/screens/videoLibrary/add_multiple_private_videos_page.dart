import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'video_library_controller.dart';

class AddMultiplePrivateVideosPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  AddMultiplePrivateVideosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoLibraryController>();
    controller.selectedVideoFiles.clear();
    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated: 'upload_videos'.tr,
      titleTopMargin: 1.5,
      titleBottomMargin: 3,
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Asset picker ui
              CustomLabelField(
                  labelText: 'You can upload 3 videos at a time'.tr),
              Container(
                margin: EdgeInsets.only(top: Spaces.normY(2)),
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: Spaces.normY(25),
                  maxHeight: Spaces.normY(25),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Spaces.normX(1)),
                  color: ColorConstants.veryVeryLightGray,
                  boxShadow: const [
                    BoxShadow(
                      color: ColorConstants.veryVeryLightGray,
                      offset: Offset(0, 1.5),
                      blurRadius: 1.5,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Spaces.normX(2)),
                      onTap: () async {
                        controller.openMultiVideoPicker();
                      },
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // show icons nothing is selected yet
                            if (controller.selectedVideoFiles.isEmpty)
                              SvgPicture.asset('assets/svgs/ic_video.svg')
                            else // show preview, image or video is selected
                              SizedBox(
                                height: Spaces.normY(25),
                                child: Stack(
                                  children: controller.selectedVideoFiles
                                      .map((element) {
                                    return SelectedVideoItemDesign(
                                      file: element,
                                      margin: controller.startMarginFactor *
                                          controller.selectedVideoFiles
                                              .indexOf(element),
                                      thumbnail: controller
                                          .selectedVideoAndThumbnails[element]!,
                                    );
                                  }).toList(),
                                ),
                              ),
                            if (controller.selectedVideoFiles.isEmpty)
                              Spaces.y1_0,
                            if (controller.selectedVideoFiles.isEmpty)
                              Text(
                                'upload_videos'.tr,
                                style: TextStyles.normalBlueBodyText,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spaces.y1,
              const Divider(
                color: ColorConstants.appBlack,
                thickness: 1.1,
              ),
              Obx(
                () => Text(
                  '${'selected_videos'.tr} ${controller.selectedVideoFiles.length}/3',
                  style: TextStyles.normalBlueBodyText,
                ),
              ),
              Spaces.y3,
              CustomElevatedButton(
                  text: 'upload'.tr,
                  onPressed: () => controller.uploadVideoFiles()),
              Spaces.y2,
            ],
          ),
        )
      ],
    );
  }
}

class SelectedVideoItemDesign extends StatelessWidget {
  final PlatformFile file;
  final double margin;
  final Uint8List thumbnail;

  const SelectedVideoItemDesign({
    Key? key,
    required this.file,
    required this.margin,
    required this.thumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: margin),
      child: Material(
        elevation: 5,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            Spaces.normX(2),
          ),
          child: SizedBox(
            width: double.infinity,
            height: Spaces.normY(27),
            child: Image.memory(
              thumbnail,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
