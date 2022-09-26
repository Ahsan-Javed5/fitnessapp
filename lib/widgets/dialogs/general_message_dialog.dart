import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class GeneralMessageDialog extends StatelessWidget {
  final String message;
  final String iconPath;
  final VoidCallback? onPositiveButtonClick;

  const GeneralMessageDialog({
    Key? key,
    required this.message,
    this.iconPath = 'assets/svgs/ic_notification.svg',
    this.onPositiveButtonClick,
  }) : super(key: key);

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

                ClipOval(
                  child: Container(
                    child: SvgPicture.asset(
                      iconPath,
                      fit: BoxFit.scaleDown,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: Spaces.normY(1.0),
                        horizontal: Spaces.normY(1)),
                    color: ColorConstants.veryLightBlue,
                  ),
                ),

                /// Message
                Spaces.y3,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyles.subHeadingSemiBold.copyWith(
                      fontSize: Spaces.normSP(14),
                      fontFamily: FontConstants.montserratSemiBold,
                    ),
                  ),
                ),
                Spaces.y3,
                if (onPositiveButtonClick != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spaces.x3,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onPositiveButtonClick,
                            child: Text('select_again'.tr),
                            style: ElevatedButton.styleFrom(
                              primary: ColorConstants.appBlue,
                              padding: EdgeInsets.symmetric(
                                horizontal: Spaces.normX(10),
                                vertical: Spaces.normY(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
