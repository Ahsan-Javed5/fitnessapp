import 'dart:io';
import 'dart:typed_data';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/widgets/asset_picker.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'video_library_controller.dart';

class AddPrivateVideoPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  AddPrivateVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File? selectedVideo;
    Uint8List videoThumbnail;
    String? videoDuration;
    String? name;
    final bool isEditable = Get.arguments?['isEditable'] ?? false;
    final Video? editedVideo = Get.arguments?['video'];
    final controller = Get.find<VideoLibraryController>();

    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated: isEditable ? 'edit_video'.tr : 'add_video'.tr,
      titleTopMargin: 1.5,
      titleBottomMargin: 3,
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              AssetPicker(
                label: isEditable ? 'update_video'.tr : 'upload_video'.tr,
                isImagePicker: false,
                previousAssetUrl: (editedVideo?.thumbnail ?? ''),
                setSelectedVideo:
                    isEditable ? 'update_video'.tr : 'add_video'.tr,
                onAssetSelected: (file, duration, n) {
                  selectedVideo = file;
                  videoDuration = duration;
                  name = n;
                },
              ),
              FormInputBuilder(
                labelText: 'Title',
                attribute: 'title',
                hintText: 'Enter group title',
                maxLength: 70,
                textCapitalization: TextCapitalization.sentences,
                initialValue: editedVideo?.title ?? '',
              ),
              Spaces.y5,
              CustomElevatedButton(
                  text: isEditable ? 'update'.tr : 'add'.tr,
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      Map<String, dynamic> body = {};
                      body.addAll(formKey.currentState!.value);
                      body['duration'] = selectedVideo != null
                          ? videoDuration
                          : editedVideo?.duration ?? '00:00';
                      body['group_id'] =
                          controller.userSelectedPrivateGroup?.id;
                      body['description'] = '';

                      if (isEditable) {
                        body.remove('group_id');
                        controller
                            .editVideo(
                          body,
                          selectedVideo,
                          editedVideo?.id ?? -1,
                          editedVideo!,
                        )
                            .then((v) {
                          controller.clearVideoSelection();
                        });
                      } else {
                        await controller.addVideo(
                            body, selectedVideo!, selectedVideo!.path);
                      }
                    }
                  }),
              Spaces.y5,
            ],
          ),
        )
      ],
    );
  }
}
