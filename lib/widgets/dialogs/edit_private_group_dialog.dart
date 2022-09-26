import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EditPrivateGroupDialog extends StatelessWidget {
  final Function(String) saveButtonListener;

  //final ValueSetter<String> getvalue;

  var groupTitle;

  EditPrivateGroupDialog(
      {Key? key, required this.saveButtonListener, this.groupTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  'edit_private_group'.tr,
                  style: TextStyles.subHeadingSemiBold.copyWith(
                    fontSize: Spaces.normSP(15),
                    fontFamily: FontConstants.montserratExtraBold,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                  child: FormInputBuilder(
                    labelText: 'name'.tr,
                    hintText: 'your_private_group_name'.tr,
                    attribute: 'group_name',
                    initialValue: groupTitle,
                    onChanged: (s) {
                      groupTitle = s!;
                    },
                  ),
                ),

                /// Add videos view
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: Spaces.normY(2.5), top: Spaces.normY(1.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'add_videos'.tr,
                          style: TextStyles.heading6AppBlackSemiBold.copyWith(
                              fontSize: Spaces.normSP(12),
                              color: ColorConstants.appBlue),
                        ),
                        Spaces.x3,
                        SvgPicture.asset(
                          'assets/svgs/ic_chevron_right.svg',
                          matchTextDirection: true,
                          color: ColorConstants.appBlue,
                        ),
                        Spaces.x5,
                      ],
                    ),
                  ),
                ),

                /// Bottom buttons row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: FittedBox(child: Text('cancel'.tr)),
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
                          text: 'save'.tr,
                          onPressed: () {
                            saveButtonListener(groupTitle);
                          },
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
