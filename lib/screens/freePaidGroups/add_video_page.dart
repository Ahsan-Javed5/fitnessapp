import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddVideoPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  AddVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEditable = Get.arguments?['isEditable'] ?? false;
    final Video? editedVideo = Get.arguments?['video'];
    final controller = Get.find<FreeAndPaidGroupController>();
    controller.videosToBeShared.clear();

    return CustomScreen(
      hasSearchBar: false,
      screenTitleTranslated: isEditable ? 'edit_video'.tr : 'add_video'.tr,
      titleTopMargin: 1.5,
      titleBottomMargin: 3,
      hasRightButton: true,
      rightButton: const HomeButton(),
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLabelField(
                      labelText: isEditable ? 'edit_video'.tr : 'add_video'.tr),
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
                            Get.toNamed(Routes.privateVideoLibrary,
                                arguments: {'shareVideoMode': true});
                          },
                          child: Obx(
                            () => controller.videosToBeShared.isEmpty
                                ? isEditable
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Spaces.normX(2)),
                                        child: CustomNetworkVideo(
                                          key: UniqueKey(),
                                          width: Spaces.normX(100),
                                          height: Spaces.normY(27),
                                          url: editedVideo?.videoUrl ?? '',
                                          thumbnail:
                                              editedVideo?.thumbnail ?? '',
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svgs/ic_video.svg'),
                                          Text(
                                            'Select video',
                                            style:
                                                TextStyles.normalBlueBodyText,
                                          ),
                                        ],
                                      )
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(Spaces.normX(2)),
                                    child: CustomNetworkVideo(
                                      key: UniqueKey(),
                                      width: Spaces.normX(100),
                                      height: Spaces.normY(27),
                                      url: controller
                                          .videosToBeShared[0].videoUrl!,
                                      thumbnail: controller
                                              .videosToBeShared[0].thumbnail ??
                                          '',
                                    ),
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
                ],
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: FormInputBuilder(
                  labelText: 'Video Title',
                  attribute: 'title_en',
                  hintText: 'Enter Video Title',
                  maxLength: 70,
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: editedVideo?.title_en ?? '',
                  validator: FormBuilderValidators.compose(
                    [
                      if (!Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'this_field_is_required'.tr,
                        ),
                    ],
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: FormInputBuilder(
                  labelText: 'عنوان مقطع الفيديو',
                  attribute: 'title_ar',
                  hintText: 'عنوان مقطع الفيديو',
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: editedVideo?.title_ar ?? '',
                  maxLength: 70,
                  validator: FormBuilderValidators.compose(
                    [
                      if (Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'this_field_is_required'.tr,
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
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: editedVideo?.description_en ?? '',
                  maxLength: 300,
                  validator: FormBuilderValidators.compose(
                    [
                      if (!Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'this_field_is_required'.tr,
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
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: editedVideo?.description_ar ?? '',
                  maxLength: 300,
                  validator: FormBuilderValidators.compose(
                    [
                      if (Utils.isRTL())
                        FormBuilderValidators.required(
                          context,
                          errorText: 'this_field_is_required'.tr,
                        ),
                    ],
                  ),
                ),
              ),
              Spaces.y5,
              CustomElevatedButton(
                  text: 'add'.tr,
                  onPressed: () async {
                    if (controller.videosToBeShared.isEmpty && !isEditable) {
                      Utils.showSnack('alert'.tr, 'Select video');
                      return;
                    }

                    if (formKey.currentState!.saveAndValidate()) {
                      Map<String, dynamic> body = {};
                      body.addAll(formKey.currentState!.value);
                      if (controller.videosToBeShared.isNotEmpty) {
                        body['video_id'] = controller.videosToBeShared[0].id;
                      } else if (isEditable) {
                        body['video_id'] = editedVideo!.video_id;
                      }

                      if (isEditable) {
                        controller.editVideoDetails(body, editedVideo!);
                      } else {
                        controller.shareVideosInSelectedGroup(body);
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
