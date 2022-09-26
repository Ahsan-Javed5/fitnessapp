import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/screens/monthlyStatements/monthly_statement_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  CustomCalendar({Key? key}) : super(key: key);
  final Decoration rangMarkerDecoration = const BoxDecoration(
    shape: BoxShape.circle,
    color: ColorConstants.appBlue,
  );

  final MonthlyStatementController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonthlyStatementController>(
      init: MonthlyStatementController(),
      builder: (controller) {
        return Stack(
          children: [
            TableCalendar(
              headerVisible: true,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              rangeStartDay: controller.startRange,
              rangeEndDay: controller.endRange,
              lastDay: controller.kLastDay,
              focusedDay: controller.startRange ?? controller.focusedDay,
              firstDay: controller.kFirstDay,

              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                defaultTextStyle: TextStyles.normalBlackBodyText,
                weekendTextStyle: TextStyles.normalBlackBodyText,
                rangeHighlightColor: ColorConstants.veryVeryLightGray,
                withinRangeTextStyle: TextStyles.normalBlackBodyText,
                rangeEndDecoration: rangMarkerDecoration,
                rangeStartDecoration: rangMarkerDecoration,
                rangeHighlightScale: Spaces.normY(0.1),
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  var text = DateFormat.MMMM().format(day);
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 5.w, bottom: 2.h),
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontFamily: FontConstants.montserratMedium,
                        color: ColorConstants.appBlack,
                      ),
                    ),
                  );
                },
                dowBuilder: (context, day) {
                  var text = DateFormat.E().format(day);
                  text = text.substring(0, 1);
                  return Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontFamily: FontConstants.montserratMedium,
                    ),
                  );
                },
              ),
              onRangeSelected: (start, end, focusedDay) {
                controller.setDateRange(start, end);
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                alignment: AlignmentDirectional.center,
                padding: Spaces.getHoriPadding(),
                height: Spaces.normY(23),
                decoration: const BoxDecoration(
                  color: ColorConstants.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.containerBorderColor,
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Date Range
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DatePresenterView(date: controller.startRange),
                        SvgPicture.asset(
                          'assets/svgs/ic_chevron_right.svg',
                          color: ColorConstants.bodyTextColor,
                          matchTextDirection: true,
                          height: Spaces.normX(3),
                        ),
                        DatePresenterView(date: controller.endRange),
                      ],
                    ),

                    Spaces.y2,

                    /// Apply button
                    CustomElevatedButton(
                        text: 'apply'.tr,
                        onPressed: () {
                          if (controller.startRange == null) {
                            Utils.showSnack(
                                'error'.tr, 'please select start range');
                            return;
                          } else if (controller.endRange == null) {
                            Utils.showSnack(
                                'error'.tr, 'please select end range');
                            return;
                          }
                          Get.back();
                          controller.applyFilters();
                        }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DatePresenterView extends StatelessWidget {
  final DateTime? date;

  const DatePresenterView({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spaces.normX(6),
          vertical: Spaces.normY(2),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spaces.normX(1)),
          color: ColorConstants.veryVeryLightGray,
        ),
        child: FittedBox(
          child: Text(
            date == null
                ? 'select_date'.tr
                : DateFormat('dd MMM, yyyy', Get.locale!.languageCode)
                    .format(date!),
            style: TextStyles.normalBlackBodyText,
          ),
        ),
      ),
    );
  }
}
