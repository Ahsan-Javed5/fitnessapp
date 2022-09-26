import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';


/// This screen has a back button
/// And you can also enable a right text button by setting [rightButtonText, showRightButton]
class BackAndRightActionBar extends StatelessWidget {
  final bool showRightButton;
  final String rightButtonText;
  final VoidCallback? rightButtonClickListener;

  const BackAndRightActionBar(
      {Key? key,
      this.showRightButton = false,
      this.rightButtonText = '',
      this.rightButtonClickListener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// Back button
        SizedBox(
          width: 8.0.w,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(
              'assets/svgs/ic_arrow.svg',
              matchTextDirection: true,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        /// Right Text Button
        showRightButton
            ? TextButton(
                onPressed: rightButtonClickListener,
                style: TextButton.styleFrom(
                    minimumSize: Size(18.0.w, 4.0.h),
                    padding: const EdgeInsetsDirectional.only(end: 0)),
                child: Text(
                  rightButtonText,
                  style: Get.textTheme.button!.copyWith(
                    color: ColorConstants.appBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    fontFamily: FontConstants.montserratRegular,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
