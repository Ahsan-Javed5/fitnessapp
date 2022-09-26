import 'dart:io';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/asset_picker.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_radio_group_builder.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class EditMainGroupScreen extends StatelessWidget {
  EditMainGroupScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final mainGroup = Get.arguments as MainGroup;
    final _controller = Get.find<FreeAndPaidGroupController>();
    File? _imageFile;

    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated: 'edit_group'.tr,
      hasRightButton: true,
      rightButton: const HomeButton(),
      titleTopMargin: 2,
      children: [
        Spaces.y4,
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              AssetPicker(
                label: 'upload_photo'.tr,
                isImagePicker: true,
                previousAssetUrl: mainGroup.groupThumbnail ?? '',
                onAssetSelected: (file, _, __) => _imageFile = file,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: FormInputBuilder(
                  labelText: 'Title',
                  attribute: 'title_en',
                  initialValue: mainGroup.titleEnglish,
                  textCapitalization: TextCapitalization.sentences,
                  validator: FormBuilderValidators.compose(
                    [
                      if (!Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'This field is required',
                        ),
                    ],
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: FormInputBuilder(
                  labelText: 'عنوان',
                  attribute: 'title_ar',
                  hintText: 'عنوان ',
                  initialValue: mainGroup.titleArabic,
                  textCapitalization: TextCapitalization.sentences,
                  validator: FormBuilderValidators.compose(
                    [
                      if (Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'هذه الخانة مطلوبه',
                        ),
                    ],
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: FormInputBuilder(
                  labelText: 'Description',
                  attribute: 'description_en',
                  maxLines: 4,
                  hintText: 'Write here...',
                  maxLength: 2000,
                  initialValue: mainGroup.descriptionEnglish,
                  textCapitalization: TextCapitalization.sentences,
                  validator: FormBuilderValidators.compose(
                    [
                      if (!Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'This field is required',
                        ),
                    ],
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: FormInputBuilder(
                  labelText: 'وصف',
                  attribute: 'description_ar',
                  maxLines: 4,
                  hintText: 'اكتب هنا',
                  maxLength: 300,
                  initialValue: mainGroup.descriptionArabic,
                  textCapitalization: TextCapitalization.sentences,
                  validator: FormBuilderValidators.compose(
                    [
                      if (Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'هذه الخانة مطلوبه',
                        ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: FormRadioGroupBuilder(
                  options: const ['free', 'paid'],
                  label: 'group_plan'.tr,
                  initialValue: mainGroup.groupPlain,
                  wrapAlignment: WrapAlignment.start,
                  attribute: 'group_plain',
                ),
              ),
              FormRadioGroupBuilder(
                options: const ['male', 'female', 'both'],
                label: 'workout_for'.tr,
                initialValue: mainGroup.forGender,
                wrapAlignment: WrapAlignment.spaceBetween,
                attribute: 'for_gender',
              ),
              Spaces.y5,
              CustomElevatedButton(
                text: 'save'.tr,
                onPressed: () {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final body = {
                      ...?formKey.currentState?.value,
                      'parent_id': 0,
                      'type': 'MAIN_GROUP',
                      'notify_subscriber': true,
                      'group_plain': mainGroup.groupPlain,
                    };

                    _controller.editMainGroupDetails(body, mainGroup,
                        imageFile: _imageFile);
                  }
                },
              ),
              Spaces.y5,
            ],
          ),
        )
      ],
    );
  }
}
