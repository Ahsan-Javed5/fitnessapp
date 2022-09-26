import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/screens/videoLibrary/video_library_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NewPrivateGroupDialog extends StatelessWidget {
  final VoidCallback? addVideoClick;

  const NewPrivateGroupDialog({Key? key, this.addVideoClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoLibraryController>();
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      backgroundColor: ColorConstants.buttonGradientStartColor,
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
            alignment: Alignment.center,
            child: Column(
              children: [
                /// Cross button
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                  ),
                ),

                /// Title
                Spaces.y2,
                Text(
                  'new_private_group'.tr,
                  style: TextStyles.subHeadingSemiBold.copyWith(
                    fontSize: Spaces.normSP(15),
                    fontFamily: FontConstants.montserratExtraBold,
                  ),
                ),

                FormBuilder(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                    child: FormInputBuilder(
                      labelText: 'name'.tr,
                      hintText: 'your_private_group_name'.tr,
                      attribute: 'title',
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 50,
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            context,
                            errorText: 'this_field_is_required'.tr,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Spaces.y5,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: FittedBox(child: Text('later'.tr)),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spaces.normX(8),
                              vertical: Spaces.normY(2),
                            ),
                          ),
                        ),
                      ),
                      Spaces.x3,
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.saveAndValidate()) {
                              controller.createPrivateGroup(
                                  formKey.currentState!.value);
                            }
                          },
                          text: 'add_videos'.tr,
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
}
