import 'package:fitnessapp/config/form_validators.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/asset_picker.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/drop_down_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_date_picker_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class UploadDocumentPage extends StatelessWidget {
  const UploadDocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileSetupController controller = Get.find();
    controller.documentImageFile = null;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'upload_document'.tr,
            style: TextStyles.mainScreenHeading,
          ),

          /// Form
          Spaces.y1_0,
          FormBuilder(
            key: controller.uploadDocumentKey,
            initialValue: const {'document_number': 3440231239801293},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownBuilder(
                  attribute: 'document_type',
                  items: const ['national_id', 'passport'],
                  hintText: 'document_type'.tr,
                  labelText: 'document_type'.tr,
                ),
                FormInputBuilder(
                  labelText: 'document_number'.tr,
                  attribute: 'document_number',
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  validator: MyFormValidators.textInputRequiredBuilder(
                      context: context),
                ),
                FormDatePickerBuilder(
                  attribute: 'expiry_date',
                  labelText: 'expiry_date'.tr,
                ),
                Spaces.y3,
                AssetPicker(
                  label: 'upload_document_image'.tr,
                  onAssetSelected: (file, _, __) {
                    controller.documentImageFile = file;
                  },
                ),
              ],
            ),
          ),

          /// Next button
          Spaces.y4,
          CustomElevatedButton(
            text: 'next'.tr,
            onPressed: () {
              controller.uploadDocumentKey.currentState!.save();
              if (controller.documentImageFile == null) {
                Utils.showSnack('alert'.tr, 'Document image is required'.tr);
                return;
              }
              if (controller.uploadDocumentKey.currentState!
                  .saveAndValidate()) {
                controller.body.addAll(
                    controller.uploadDocumentKey.currentState?.value ?? {});
                controller.navigateForward();
              }
            },
          ),
          Spaces.y6,
        ],
      ),
    );
  }
}
