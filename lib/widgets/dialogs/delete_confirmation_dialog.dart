import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback deleteListener;
  final VoidCallback cancelListener;

  const DeleteConfirmationDialog(
      {Key? key, required this.deleteListener, required this.cancelListener})
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

                ClipOval(
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/svgs/ic_delete.svg',
                      fit: BoxFit.scaleDown,
                      color: ColorConstants.appBlue,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: Spaces.normY(3.0),
                        horizontal: Spaces.normX(8)),
                    color: ColorConstants.veryLightBlue,
                  ),
                ),

                /// Title
                Spaces.y2,
                Text(
                  'are_you_sure'.tr,
                  style: TextStyles.subHeadingSemiBold.copyWith(
                    fontSize: Spaces.normSP(15),
                    fontFamily: FontConstants.montserratExtraBold,
                  ),
                ),

                Spaces.y3,

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: cancelListener,
                          child: Text('cancel'.tr),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spaces.normX(10),
                              vertical: Spaces.normY(2),
                            ),
                          ),
                        ),
                      ),
                      Spaces.x3,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: deleteListener,
                          child: FittedBox(child: Text('delete'.tr)),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
