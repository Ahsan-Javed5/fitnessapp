import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatementListItem extends StatelessWidget {
  final String title;
  final String date;
  final String countOfSubscriber;
  final VoidCallback onDownloadClick;

  const StatementListItem(
      {Key? key,
      required this.title,
      required this.date,
      required this.countOfSubscriber,
      required this.onDownloadClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Spaces.normY(2.5)),
      decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.containerBorderColor),
          borderRadius: BorderRadius.circular(Spaces.normX(1))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Spaces.normX(3), vertical: Spaces.normX(3)),
        child: Column(
          children: [
            /// Title and download button row
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  title,
                  style: TextStyles.subHeadingWhiteMedium.copyWith(
                      color: ColorConstants.appBlack,
                      fontSize: Spaces.normSP(11.5)),
                ),
                const Spacer(),
                SizedBox(
                  height: Spaces.normY(3.5),
                  width: Spaces.normX(25),
                  child: CustomElevatedButton(
                    onPressed: onDownloadClick,
                    text: 'download'.tr,
                    textStyle: Theme.of(context).textTheme.button!.copyWith(
                          fontFamily: FontConstants.montserratMedium,
                          fontSize: Spaces.normSP(10),
                        ),
                  ),
                )
              ],
            ),

            Spaces.y2,

            /// Date and Subscriber
            Row(
              children: [
                // Date Text
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'date'.tr.toUpperCase() + '\n',
                      style: TextStyles.textFieldLabelStyleSmallGray
                          .copyWith(fontSize: Spaces.normSP(9)),
                      children: [
                        TextSpan(
                          text: date,
                          style: TextStyles.normalBlackBodyText.copyWith(
                            fontSize: Spaces.normSP(11.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subscriber Text
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'subscriber'.tr.toUpperCase() + '\n',
                      style: TextStyles.textFieldLabelStyleSmallGray
                          .copyWith(fontSize: Spaces.normSP(9)),
                      children: [
                        TextSpan(
                          text: countOfSubscriber,
                          style: TextStyles.normalBlackBodyText.copyWith(
                            fontSize: Spaces.normSP(11.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Spaces.y0,
          ],
        ),
      ),
    );
  }
}
