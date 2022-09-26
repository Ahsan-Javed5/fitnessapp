import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/monthlyStatements/statement_list_item.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'monthly_statement_controller.dart';

class MonthlyStatementScreen extends StatefulWidget {
  const MonthlyStatementScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyStatementScreen> createState() => _MonthlyStatementScreenState();
}

class _MonthlyStatementScreenState extends State<MonthlyStatementScreen> {
  final controller = Get.put(MonthlyStatementController());

  @override
  Widget build(BuildContext context) {
    controller.startRange = null;
    controller.endRange = null;
    controller.getMonthlyStatementsOfCoach();

    return CustomScreen(
      hasBackButton: true,
      hasSearchBar: false,
      hasRightButton: true,
      titleTopMargin: 1.5,
      titleBottomMargin: 6,
      rightButton: Row(
        children: [
          TextButton.icon(
            onPressed: () => Get.toNamed(Routes.dateRangeFilterPage),
            icon: SvgPicture.asset('assets/svgs/ic_filter_calendar.svg'),
            label: Text(
              '',
              style: TextStyles.normalBlackBodyText,
            ),
          ),
          const HomeButton(),
        ],
      ),
      screenTitleTranslated: 'monthly_statements'.tr,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.monthlyStatements.isEmpty
                  ? const Center(child: EmptyView(showFullMessage: false))
                  : ListView.builder(
                      itemCount: controller.monthlyStatements.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = controller.monthlyStatements[index];
                        final title =
                            '${'statement_of'.tr} ${Utils.getMonthNameFromDate(item.lastStatementDate ?? '')}';
                        return StatementListItem(
                          title: title,
                          countOfSubscriber: item.totalSubscribers.toString(),
                          date: Utils.formatDateTime(
                              item.lastStatementDate ?? ''),
                          onDownloadClick: () async {
                            if (item.statementPdf?.isEmpty ?? true) {
                              Utils.showSnack(
                                  'Error', 'Download link is not found',
                                  isError: true);
                              return;
                            }
                            await controller.retryRequestPermission();

                            if (controller.downloadDirPath == null ||
                                controller.downloadDirPath!.isEmpty) {
                              Utils.showSnack('Error',
                                  'Unexpected error, please restart application',
                                  isError: true);
                            } else {
                              controller.downloadFile(
                                  item.statementPdf! + MyHive.sasKey,
                                  '$title.pdf',
                                  controller.downloadDirPath ?? '');
                            }
                          },
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
