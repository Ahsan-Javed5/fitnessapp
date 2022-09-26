import 'package:fitnessapp/models/subscription.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'config/space_values.dart';
import 'config/text_styles.dart';
import 'constants/color_constants.dart';

////////////////////////////////////////////////////
//                                                //
//        Rectangular Coach list item design      //
//                                                //
////////////////////////////////////////////////////
class CoachListItemRect extends StatelessWidget {
  final Subscription? subscription;
  final VoidCallback onPressed;

  const CoachListItemRect({
    Key? key,
    this.subscription,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
        margin: EdgeInsetsDirectional.only(end: 1.h),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.containerBorderColor),
          borderRadius: BorderRadius.circular(1.w),
        ),
        child: Row(
          children: [
            ClipOval(
                child: SizedBox(
              height: 7.5.h,
              width: 7.5.h,
              child: subscription!.user?.imageUrl != null
                  ? CustomNetworkImage(
                      placeholderUrl: 'assets/images/profile_ph.png',
                      imageUrl: subscription!.user!.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : SvgPicture.asset(
                      'assets/svgs/profile_ph.svg',
                      fit: BoxFit.contain,
                    ),
            )),
            Spaces.x3,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${subscription!.user!.firstName ?? ''} ${subscription!.user!.lastName ?? ''}',
                  style: TextStyles.normalGrayBodyText
                      .copyWith(color: ColorConstants.appBlack, fontSize: 9.sp),
                ),
                Spaces.y1,
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'start_on'.tr.toUpperCase(),
                          style: TextStyles.normalGrayBodyText
                              .copyWith(fontSize: 7.sp),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            subscription!.formattedStartDateTime,
                            style: TextStyles.normalGrayBodyText.copyWith(
                                color: ColorConstants.appBlack, fontSize: 8.sp),
                            locale: const Locale('en', 'US'),
                          ),
                        ),
                      ],
                    ),
                    Spaces.x5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'end_date'.tr.toUpperCase(),
                          style: TextStyles.normalGrayBodyText
                              .copyWith(fontSize: 7.sp),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            subscription!.formattedEndDateTime,
                            style: TextStyles.normalGrayBodyText.copyWith(
                              color: ColorConstants.appBlack,
                              fontSize: 8.sp,
                            ),
                            locale: const Locale('en', 'US'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
