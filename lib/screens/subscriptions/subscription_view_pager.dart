import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_controller.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_list_item.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'active_subscriptions.dart';
part 'expired_subscriptions.dart';

class SubscriptionViewPager extends StatelessWidget {
  const SubscriptionViewPager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _initialIndex = Get.arguments == null ? 0 : Get.arguments['pageIndex'];
    final controller = Get.put(SubscriptionController());

    return CustomScreen(
      titleTopMargin: 3,
      titleBottomMargin: 2,
      hasRightButton: true,
      hasSearchBar: true,
      onSearchbarClearText: () => controller.searchSubscriptions(''),
      onSearchBarTextChange: (s) => controller.searchSubscriptions(s),
      rightButton: const HomeButton(),
      screenTitleTranslated: 'subscriptions'.tr,
      child: DefaultTabController(
        length: 2,
        initialIndex: _initialIndex,
        child: Column(
          children: [
            TabBar(
              indicatorWeight: 2,
              tabs: [
                Tab(
                  text: 'active'.tr,
                ),
                Tab(
                  text: 'expired'.tr,
                ),
              ],
            ),
            Spaces.y4,
            const Expanded(
              child: TabBarView(
                children: [
                  ActiveSubscriptions(),
                  ExpiredSubscriptions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
