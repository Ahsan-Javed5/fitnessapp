import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/screens/monthlyStatements/monthly_statement_controller.dart';
import 'package:fitnessapp/widgets/custom_calendar.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangeFilterPage extends StatelessWidget {
  DateRangeFilterPage({Key? key}) : super(key: key);
  final MonthlyStatementController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      hasSearchBar: false,
      hasRightButton: true,
      includeBodyPadding: false,
      titleTopMargin: 2,
      titleBottomMargin: 2,
      screenTitleTranslated: 'date_range'.tr,
      backButtonIconPath: 'assets/svgs/ic_close.svg',
      rightButton: TextButton(
        child: Text(
          'clear'.tr,
          style: TextStyles.normalBlueBodyText,
        ),
        onPressed: () {
          controller.setDateRange(null, null);
          Get.back();
          controller.applyFilters();
        },
      ),
      child: CustomCalendar(),
    );
  }
}
