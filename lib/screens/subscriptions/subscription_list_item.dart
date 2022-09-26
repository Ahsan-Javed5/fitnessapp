import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/subscription.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class SubscriptionListItem extends StatelessWidget {
  final int index;
  final String translatedTitle;
  final String? tag1Text;
  final String? tag2Text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final EdgeInsets padding;
  final Color? tagBackgroundColor;
  final Color? tagTextColor;
  final Subscription? subscription;

  const SubscriptionListItem({
    Key? key,
    this.subscription,
    required this.index,
    required this.translatedTitle,
    this.tag1Text,
    this.tag2Text,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.tagBackgroundColor,
    this.tagTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String arrow = ' → ';
    if (Utils.isRTL()) {
      arrow = ' ￩ ';
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: backgroundColor,
            shadowColor: Colors.transparent,
            padding: padding,
          ),
          child: Container(
            padding: EdgeInsets.all(2.h),
            margin: EdgeInsets.only(bottom: 2.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.w),
                border: Border.all(color: ColorConstants.containerBorderColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 9.0.h,
                  width: 9.0.h,
                  child: ClipOval(
                    child: CustomNetworkImage(
                      imageUrl: subscription!.user!.imageUrl,
                    ),
                  ),
                ),
                Spaces.x4,

                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title user name
                      Text(
                        '${subscription!.user!.firstName ?? ''} ${subscription!.user!.lastName ?? ''}',
                        style: TextStyles.subHeadingBlackMedium,
                      ),

                      // Spaces.y1,
                      // CustomLabelField(
                      //   labelText: 'subscription'.tr,
                      // ),

                      Spaces.y1,
                      Text(
                        '${subscription?.formattedStartDateTime}$arrow${subscription?.formattedEndDateTime} ',
                        style: TextStyles.normalBlackBodyText.copyWith(
                          fontSize: Spaces.normSP(9.5),
                          color: ColorConstants.bodyTextColor,
                        ),
                      ),
                      Spaces.y1,
                      Text(
                        '\$ ' + subscription!.amountPaid.toString(),
                        style: TextStyles.mainScreenHeading.copyWith(
                          fontFamily: FontConstants.montserratMedium,
                          fontSize: Spaces.normSP(18),
                          color: ColorConstants.appBlue,
                        ),
                      )
                    ],
                  ),
                ),
                Spaces.x6,
                InkWell(
                  onTap: () {
                    ///this will start working when firebaseKey will be receiving from backend
                    Utils.open1to1Chat(MyHive.getUser()!.firebaseKey.toString(),
                        subscription!.user!.firebaseKey.toString(), context);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/ic_chat.svg',
                    color: ColorConstants.appBlue,
                  ),
                ),
                Spaces.x2,
                // Column(
                //   children: [
                //     Text(
                //       'amount'.tr,
                //       style: TextStyles.normalBlackBodyText.copyWith(
                //         fontSize: Spaces.normSP(10),
                //         fontWeight: FontWeight.w500,
                //         color: ColorConstants.bodyTextColor,
                //         fontFamily: FontConstants.montserratSemiBold,
                //       ),
                //     ),
                //     Text(
                //       '\$ ' + subscription!.amountPaid.toString(),
                //       style: TextStyles.mainScreenHeading.copyWith(
                //         fontFamily: FontConstants.montserratMedium,
                //         fontSize: Spaces.normSP(24),
                //         color: ColorConstants.appBlue,
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
