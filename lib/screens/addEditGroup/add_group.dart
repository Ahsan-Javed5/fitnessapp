import 'dart:io';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
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

class AddGroup extends StatelessWidget {
  AddGroup({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    /// [0] is for add group
    /// [1] is for add sub group
    final args = Get.arguments;
    final type = args == null ? 0 : args['groupType'];
    String title = 'add_group'.tr;
    if (type == 1) title = 'add_sub_group'.tr;

    bool _isModeEdit = args == null ? false : args['isEditable'] ?? false;
    int _mainGroupId = args == null ? 0 : args['data'] ?? 0;
    final _controller = Get.find<FreeAndPaidGroupController>();
    bool _notifySubscriber = false;
    File? _imageFile;

    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated: _isModeEdit ? 'edit_group'.tr : title,
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
                onAssetSelected: (file, _, __) => _imageFile = file,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: FormInputBuilder(
                  labelText: 'Title',
                  attribute: 'title_en',
                  maxLines: null,
                  maxLength: 2000,
                  keyboardType: TextInputType.multiline,
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
              if (type == 0)
                FormRadioGroupBuilder(
                  options: const ['free', 'paid'],
                  label: 'group_plan'.tr,
                  initialValue:
                      _controller.initialPageIndex == 0 ? 'free' : 'paid',
                  wrapAlignment: WrapAlignment.start,
                  attribute: 'group_plain',
                ),
              if (type == 0)
                FormRadioGroupBuilder(
                  options: const ['male', 'female', 'both'],
                  label: 'workout_for'.tr,
                  wrapAlignment: WrapAlignment.spaceBetween,
                  attribute: 'for_gender',
                ),
              Spaces.y3,
              Visibility(
                visible: false,
                child: Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (v) => _notifySubscriber = v ?? true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(
                      'Notify subscribers',
                      style: TextStyles.subHeadingWhiteMedium
                          .copyWith(color: ColorConstants.appBlack),
                    )
                  ],
                ),
              ),
              Spaces.y5,
              CustomElevatedButton(
                text: 'add'.tr,
                onPressed: () {
                  if (_imageFile == null) {
                    Utils.showSnack(
                        'alert'.tr, 'Select thumbnail for this group');
                    return;
                  }

                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final body = {
                      ...?formKey.currentState?.value,
                      'notify_subscribers': _notifySubscriber,
                      'parent_id': _mainGroupId,
                      'type': type == 0 ? 'MAIN_GROUP' : 'SUB_GROUP',
                    };

                    _controller.createGroup(body, _imageFile!, type == 0);
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
