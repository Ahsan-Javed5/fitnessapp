import 'dart:io';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/models/private_group.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/asset_picker.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'video_library_controller.dart';

/// This is new page to add private group according to the new requirement
class AddPrivateGroupPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  AddPrivateGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoLibraryController>();
    final bool isEditable = Get.arguments?['isEditable'] ?? false;
    PrivateGroup? initialGroup = Get.arguments?['group'];
    File? selectedImage;

    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated:
          isEditable ? 'edit_private_group'.tr : 'new_private_group'.tr,
      titleTopMargin: 1.5,
      titleBottomMargin: 3,
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              AssetPicker(
                label: 'upload_photo'.tr,
                isImagePicker: true,
                previousAssetUrl: initialGroup?.imageUrl ?? '',
                onAssetSelected: (file, _, __) {
                  selectedImage = file;
                },
              ),
              FormInputBuilder(
                labelText: 'Title',
                attribute: 'title',
                hintText: 'Enter video title',
                maxLength: 70,
                textCapitalization: TextCapitalization.sentences,
                initialValue: initialGroup?.title ?? '',
              ),
              Spaces.y3,
              CustomElevatedButton(
                  text: isEditable ? 'update'.tr : 'add'.tr,
                  onPressed: () async {
                    if (selectedImage == null && !isEditable) {
                      Utils.showSnack(
                          'alert'.tr, 'Please select an image first',
                          isError: true);
                      return;
                    }
                    if (formKey.currentState!.saveAndValidate()) {
                      if (isEditable) {
                        controller.updatePrivateGroup(
                            formKey.currentState!.value, initialGroup!,
                            imageFile: selectedImage);
                      } else {
                        controller.createPrivateGroup(
                            formKey.currentState!.value,
                            imageFile: selectedImage);
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
