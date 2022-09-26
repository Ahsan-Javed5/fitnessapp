import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'config/space_values.dart';
import 'config/text_styles.dart';
import 'constants/color_constants.dart';

///////////////////////////////////////////
//
//        Square Coach list item design
//
///////////////////////////////////////////
class CoachListItem extends StatelessWidget {
  final User coach;
  final VoidCallback onPressed;

  const CoachListItem({Key? key, required this.coach, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: ColorConstants.veryVeryLightGray,
        elevation: 0.5,
        shadowColor: ColorConstants.veryVeryLightGray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.w),
                child: SizedBox(
                  width: 48.w,
                  child: CustomNetworkImage(
                    imageUrl: coach.imageUrl ?? '',
                  ),
                ),
              ),
            ),
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                child: Text(
                  coach.getFullName().trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyles.normalBlackBodyText.copyWith(
                    fontSize: Spaces.normSP(9),
                    fontWeight: FontWeight.bold,
                    fontFamily: FontConstants.montserratRegular,
                  ),
                ),
              ),
              alignment: AlignmentDirectional.centerStart,
            ),
          ],
        ),
      ),
    );
  }
}
