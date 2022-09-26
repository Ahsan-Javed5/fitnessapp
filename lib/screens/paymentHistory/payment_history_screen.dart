import 'package:fitnessapp/screens/subscriptions/subscription_controller.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_list_item.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubscriptionController subsController = Get.find();

    return CustomScreen(
        hasSearchBar: false,
        titleTopMargin: 2,
        titleBottomMargin: 6,
        hasRightButton: true,
        rightButton: const HomeButton(),
        screenTitleTranslated: 'payment_history'.tr,
        child: GetBuilder<SubscriptionController>(
          id: subsController.getActiveSubs,
          builder: (controller) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.subsHistoryList.length,
              itemBuilder: (context, index) => SubscriptionListItem(
                index: index,
                subscription: controller.subsHistoryList[index],
                translatedTitle: 'Coach Name',
                onPressed: () {},
              ),
            );
          },
        ));
  }
}
