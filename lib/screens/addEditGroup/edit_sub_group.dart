import 'dart:io';
import 'dart:ui';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/models/sub_group.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/asset_picker.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditSubGroup extends StatelessWidget {
  EditSubGroup({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final FreeAndPaidGroupController c = Get.find();
    final subGroup = Get.arguments as SubGroup;
    File? _imageFile;
    Future.delayed(1.milliseconds, () {
      c.clearSelection();
    });
    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated: 'edit_sub_group'.tr,
      hasRightButton: true,
      rightButton: const HomeButton(),
      titleTopMargin: 2,
      children: [
        Spaces.y4,
        FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AssetPicker(
                label: 'upload_photo'.tr,
                isImagePicker: true,
                previousAssetUrl: subGroup.groupThumbnail ?? '',
                onAssetSelected: (file, _, __) => _imageFile = file,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: FormInputBuilder(
                  labelText: 'Title',
                  attribute: 'title_en',
                  initialValue: subGroup.titleEnglish,
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
                  initialValue: subGroup.titleArabic,
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
                  hintText: 'Write here...',
                  maxLines: 4,
                  maxLength: 2000,
                  initialValue: subGroup.descriptionEnglish,
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
                  hintText: 'اكتب هنا',
                  initialValue: subGroup.descriptionArabic,
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
              /*Spaces.y2_0,
              CustomLabelField(labelText: 'upload_video'.tr),
              Spaces.y1,
              GetBuilder<FreeAndPaidGroupController>(
                builder: (controller) => GridView.builder(
                  itemCount: controller.editSubGroupVideos.length + 1,
                  padding: EdgeInsets.all(Spaces.normY(0.5)),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: Spaces.normX(2),
                      mainAxisSpacing: Spaces.normY(1)),
                  itemBuilder: (context, index) => index <
                          controller.editSubGroupVideos.length
                      ? UploadedVideoItem(
                          index: index,
                          isSelected: controller.selectedVideos
                              .contains(controller.editSubGroupVideos[index]),
                          onPressed: () => controller.updateSelectedVideos(
                              controller.editSubGroupVideos[index]))
                      : controller.editSubGroupVideos.length < 6
                          ? AddNewVideoButton(
                              onPressed: () =>
                                  Routes.to(Routes.selectVideoScreen),
                            )
                          : const SizedBox(),
                ),
              ),
              const Divider(
                color: ColorConstants.appBlack,
                thickness: 1.4,
              ),*/
              Spaces.y3,
              CustomElevatedButton(
                text: 'save'.tr,
                onPressed: () {
                  /*for (final e in c.selectedVideos) {
                    c.updateSubGroupVideoList(e, notify: false);
                  }
                  c.clearSelection();
                  Routes.back();*/

                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final body = {
                      ...?formKey.currentState?.value,
                      'parent_id': c.userSelectedMainGroup!.id,
                      'type': 'SUB_GROUP',
                      'notify_subscriber': true,
                    };

                    c.editSubGroupDetails(body, subGroup,
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

class UploadedVideoItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onPressed;

  const UploadedVideoItem({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: Spaces.normY(8),
        width: Spaces.normY(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Spaces.normX(1)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/dummy_group.png',
                fit: BoxFit.cover,
              ),
              Positioned(
                height: Spaces.normY(4.5),
                width: Spaces.normY(4.5),
                child: AnimatedOpacity(
                  duration: 200.milliseconds,
                  opacity: isSelected ? 1 : 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_close_circled.svg',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spaces.normX(1)),
        ),
      ),
    );
  }
}
/*
class AddNewVideoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddNewVideoButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DottedBorder(
        child: Center(
          child: SizedBox(
            height: Spaces.normY(8),
            width: Spaces.normY(8),
            child: SvgPicture.asset(
              'assets/svgs/ic_add_circle.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        strokeWidth: 2,
        radius: Radius.circular(Spaces.normX(1)),
        dashPattern: const [6, 3, 6, 3],
        borderType: BorderType.RRect,
        color: ColorConstants.grayDark,
      ),
    );
  }
}*/
